# checks that the sandboxed hdparm units still apply their settings. a disk on
# an ahci sata controller takes the same libata path as munibot's real disks,
# and is linked at every by-uuid path the unit's script uses
{
  name = "hdparm-sandbox";

  nodes.server = {
    imports = [ ../server/hdparm.nix ];

    # null-co reads zeros and discards writes
    virtualisation.qemu.options = [
      "-blockdev driver=null-co,node-name=sata0,size=67108864"
      "-device ahci,id=ahci0"
      "-device ide-hd,drive=sata0,bus=ahci0.0,model=TESTDISK"
    ];
  };

  testScript = ''
    import re

    server.wait_for_unit("multi-user.target")
    disk = server.succeed("lsblk -dpno NAME,MODEL | awk '$2==\"TESTDISK\"{print $1}'").strip()
    assert disk.startswith("/dev/sd"), f"expected a libata disk, got {disk!r}"

    # read the disk paths from the unit itself, so the test follows hdparm.nix
    m = re.search(r"path=(\S+)", server.succeed("systemctl show -P ExecStart hdparm-disk-settings.service"))
    assert m is not None, "couldn't read the unit's script"
    script = m.group(1)
    paths = sorted(set(re.findall(r"/dev/disk/by-uuid/[0-9a-f-]+", server.succeed(f"cat {script}"))))
    assert paths, "the script names no disks"
    for path in paths:
        server.succeed(f"mkdir -p /dev/disk/by-uuid && ln -sf {disk} {path}")

    # the real, sandboxed unit
    server.succeed("systemctl restart hdparm-disk-settings.service")
    result = server.succeed("systemctl show -P Result hdparm-disk-settings.service").strip()
    invocation = server.succeed("systemctl show -P InvocationID hdparm-disk-settings.service").strip()
    sandboxed = server.succeed(f"journalctl -o cat _SYSTEMD_INVOCATION_ID={invocation}")

    # control: the same script as unrestricted root
    plain = server.succeed(f"systemd-run --wait --pipe --collect {script} 2>&1")

    # control: the same device access without capabilities must fail, which
    # proves the emulated disk really takes the privileged ata path
    nocap = server.execute(
        "systemd-run --wait --pipe --collect -p CapabilityBoundingSet= -p DevicePolicy=closed "
        f"-p 'DeviceAllow={disk} r' {script} 2>&1"
    )[1]

    def output(log: str) -> list[str]:
        # hdparm's own lines, without systemd-run's summary
        return [
            line.strip()
            for line in log.splitlines()
            if line.strip().startswith(("/dev/", "setting", "APM", "HDIO", "SG_IO"))
        ]

    print("sandboxed:", *output(sandboxed), sep="\n  ")
    assert result == "success", f"unit result was {result}"
    assert output(sandboxed) == output(plain), "the sandboxed run behaves differently"
    assert "not permitted" in nocap.lower(), "the no-capability control unexpectedly succeeded"
  '';
}
