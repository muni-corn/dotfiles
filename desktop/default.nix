{pkgs, ...}: {
  imports = [
    ../common.nix
    ../common-graphical.nix

    ../docker.nix
    ../openssh.nix
    ../firewall.nix
    ../sops
    ../steam.nix
    ./btrbk.nix
    ./hardware.nix
    ./home-assistant.nix
    ./vfio.nix
  ];

  boot = {
    loader = {
      efi.efiSysMountPoint = "/boot/efi";
      systemd-boot.memtest86.enable = true;
    };
    kernelPackages = pkgs.linuxKernel.packages.linux_testing;
  };

  hardware = {
    opengl = {
      enable = true;
      extraPackages = with pkgs; [
        amdvlk
        rocmPackages.clr
        rocmPackages.clr.icd
      ];
      extraPackages32 = with pkgs; [
        driversi686Linux.amdvlk
      ];
      driSupport = true;
      driSupport32Bit = true;
    };
  };

  home-manager.users.muni.wayland.windowManager.hyprland.settings.workspace = [
    "1,monitor:DP-2,default:true"
    "2,monitor:DP-2"
    "3,monitor:DP-2"
    "4,monitor:DP-2"
    "5,monitor:HDMI-A-2,default:true"
    "6,monitor:HDMI-A-2"
    "7,monitor:HDMI-A-2"
    "8,monitor:HDMI-A-1"
    "9,monitor:HDMI-A-1"
    "10,monitor:HDMI-A-1,default:true"
  ];

  musnix = {
    enable = true;
    soundcardPciId = "0e:00.4";
  };

  networking = {
    hostName = "ponycastle";
    hostId = "edafa5da";
  };

  nixpkgs.config = {
    rocmTargets = ["gfx1102"];
    rocmSupport = true;
  };

  programs.gamescope = {
    enable = true;
    capSysNice = true;
    args = [
      "-f"
      "-r 75"
      "-o 75"
      "-H 1440"
      "-h 1440"
      "-w 2560"
      "-W 2560"
      "-g"
      "--expose-wayland"
    ];
  };

  security.pam.loginLimits = [
    {
      domain = "muni";
      type = "hard";
      item = "nofile";
      value = "524288";
    }
  ];

  services = {
    # btrfs auto scrubbing (defaults to monthly scrubs).
    # useless without data redundancy; disabling until we're back to raid5. manual
    # scrubs will suffice for finding corrupted files, which can be replaced by
    # backups.
    btrfs.autoScrub = {
      enable = false;
      fileSystems = ["/" "/vault"];
    };

    # enable fstrim for btrfs
    fstrim.enable = true;

    # openrgb
    hardware.openrgb = {
      enable = true;
      package = pkgs.openrgb-with-all-plugins;
    };

    invokeai.enable = true;

    ollama.enable = true;

    psd.enable = true;

    smartd.enable = true;
  };

  systemd = {
    extraConfig = "DefaultLimitNOFILE=524288";
    user.extraConfig = "DefaultLimitNOFILE=524288";

    services = {
      boot-sound = {
        enable = true;
        description = "bootup sound";
        wants = ["sound.target"];
        after = ["sound.target"];
        wantedBy = ["multi-user.target"];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${pkgs.alsa-utils}/bin/aplay -c 2 -D hdmi:CARD=HDMI,DEV=0 ${pkgs.muse-sounds}/share/sounds/musicaloft/stereo/system-ready.wav";
          RemainAfterExit = false;
        };
      };
    };

    # for Blender
    tmpfiles.rules = [
      "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
    ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?
}
