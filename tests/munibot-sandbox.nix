# checks that the sandboxed munibot service still logs into mariadb and runs
# its migrations, and that it behaves the same as the binary run without the
# sandbox. discord and twitch can't be reached offline, so both runs use dummy
# tokens and fail the same way on the network
{
  name = "munibot-sandbox";

  nodes.server =
    { inputs, lib, ... }:
    {
      imports = [
        inputs.munibot.nixosModules.default
        ../server/munibot.nix
      ];

      # stand-in for sops-nix: server/munibot.nix only reads secrets.<name>.path
      options.sops.secrets = lib.mkOption {
        type = lib.types.attrsOf (
          lib.types.submodule (
            { name, ... }:
            {
              options.path = lib.mkOption { default = "/etc/test-secrets/${name}"; };
            }
          )
        );
        default = { };
      };

      config = {
        sops.secrets."munibot.env" = { };
        environment.etc."test-secrets/munibot.env".text = ''
          DISCORD_APPLICATION_ID=1
          DISCORD_CLIENT_SECRET=dummy
          DISCORD_PUBLIC_KEY=dummy
          DISCORD_TOKEN=dummy.token.value
          TWITCH_CLIENT_ID=dummy
          TWITCH_CLIENT_SECRET=dummy
          TWITCH_TOKEN=dummy
        '';
        virtualisation.memorySize = 2048;
      };
    };

  testScript = ''
    import datetime
    import re

    server.wait_for_unit("mysql.service")

    # the sandboxed bot logs into mariadb via unix_socket and runs migrations
    server.wait_until_succeeds(
        "mysql -N munibot -e 'show tables' | grep -q __diesel_schema_migrations",
        timeout=datetime.timedelta(seconds=180),
    )
    server.sleep(datetime.timedelta(seconds=20))
    sandboxed = server.succeed("journalctl -u munibot.service --no-pager -o cat")

    # the same binary, user, and environment, without the sandbox
    m_argv = re.search(r"argv\[\]=([^;]+);", server.succeed("systemctl show -P ExecStart munibot.service"))
    m_db = re.search(r'DATABASE_URL=([^\s"]+)', server.succeed("systemctl show -P Environment munibot.service"))
    assert m_argv is not None and m_db is not None, "couldn't read the unit's command or environment"
    server.succeed(
        "systemd-run --unit=munibot-plain --uid=munibot --gid=munibot "
        "-p EnvironmentFile=/etc/test-secrets/munibot.env "
        f"-E 'DATABASE_URL={m_db.group(1)}' -E RUST_LOG=error,munibot=info {m_argv.group(1).strip()}"
    )
    server.sleep(datetime.timedelta(seconds=15))
    plain = server.succeed("journalctl -u munibot-plain.service --no-pager -o cat")

    def messages(log: str) -> list[str]:
        # drop timestamps and colors so the two runs can be compared
        lines = [re.sub(r"\x1b\[[0-9;]*m", "", line) for line in log.splitlines()]
        return [re.sub(r"^\S+\s+", "", line) for line in lines if re.match(r"^\d{4}-", line)]

    print("sandboxed:", *messages(sandboxed), sep="\n  ")
    print("unsandboxed:", *messages(plain), sep="\n  ")

    denial = r"SIGSYS|status=31|Bad system call|permission denied|read-only file system|operation not permitted"
    assert not re.search(denial, sandboxed, re.I), "the sandbox caused a denial"
    assert messages(sandboxed) == messages(plain), "the sandboxed run behaves differently"
  '';
}
