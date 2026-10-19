# checks that the sandboxed timew-sync-server still works, and that it only
# accepts connections from localhost even when its firewall port is open
{
  name = "timew-sync-server-sandbox";

  nodes = {
    server = {
      imports = [ ../extra-modules/nixos/timew-sync-server.nix ];

      # open the port so only the sandbox's ip restriction can block the client
      services.timew-sync-server = {
        enable = true;
        openFirewall = true;
      };
    };

    client =
      { pkgs, ... }:
      {
        environment.systemPackages = [ pkgs.curl ];
      };
  };

  testScript = ''
    start_all()
    server.wait_for_unit("timewarrior-sync-server.service")
    server.wait_for_open_port(8463)

    # any http status means the server handled the request
    code = server.succeed("curl -s -o /dev/null -w '%{http_code}' http://127.0.0.1:8463/api/sync").strip()
    assert code != "000", "no http response locally"

    # the database lives in the data dir, the only writable path
    server.succeed("test -e /var/lib/timew-sync-server/sqlite.db")
    server.succeed("systemctl is-active timewarrior-sync-server.service")
    server.fail(
        "journalctl -u timewarrior-sync-server.service"
        " | grep -iE 'SIGSYS|status=31|permission denied|read-only file system|operation not permitted'"
    )

    # another machine is refused, even with the firewall port open
    client.wait_for_unit("multi-user.target")
    client.succeed("ping -c1 -W3 server")
    client.fail("curl -s -m 5 -o /dev/null http://server:8463/api/sync")

    # control: lifting only the ip restriction lets the same request through
    server.succeed(
        "systemctl set-property --runtime timewarrior-sync-server.service IPAddressDeny= IPAddressAllow="
    )
    code = client.succeed("curl -s -m 5 -o /dev/null -w '%{http_code}' http://server:8463/api/sync").strip()
    assert code != "000", "client still refused with the ip restriction lifted"
  '';
}
