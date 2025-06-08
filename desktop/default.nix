{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ../art.nix
    ../docker.nix
    ../firewall.nix
    ../gaming.nix
    ../music-production.nix
    ../openssh.nix
    ../sops
    ../video-production.nix
    ../vr.nix
    ./btrbk.nix
    ./hardware.nix
  ];

  boot.loader = {
    efi.efiSysMountPoint = "/boot/efi";
    systemd-boot.memtest86.enable = true;
  };

  hardware = {
    amdgpu = {
      amdvlk.enable = false;
      initrd.enable = true;
      opencl.enable = true;
      overdrive = {
        enable = true;
        ppfeaturemask = "0xffffffff";
      };
    };
    graphics.enable32Bit = true;
  };

  home-manager.users.muni = {
    home.packages = with pkgs; [
      vscode-fhs

      # photo
      gmic
      gmic-qt
      upscayl

      # emulators and "emulators"
      wineWowPackages.waylandFull
      winetricks
    ];

    programs = {
      chromium = {
        enable = true;
        dictionaries = [
          pkgs.hunspellDictsChromium.en_US
        ];
        extensions = [
          { id = "ajopnjidmegmdimjlfnijceegpefgped"; } # betterttv
          { id = "naepdomgkenhinolocfifgehidddafch"; } # browserpass
          { id = "eimadpbcbfnmbkopoojfekhnkhdbieeh"; } # dark reader
          { id = "nkbihfbeogaeaoehlefnkodbefgpgknn"; } # metamask
          { id = "inpoelmimmiplkcldmdljiboidfkcfbh"; } # presearch
          { id = "bpaoeijjlplfjbagceilcgbkcdjbomjd"; } # ttv lol pro
          { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # ublock origin
          { id = "dbepggeogbaibhgnhhndojpepiihcmeb"; } # vimium
        ];
      };

      hyprlock.settings = (import ../utils.nix { inherit config lib; }).mkHyprlockSettings [
        "DP-1"
        "DP-2"
        "HDMI-A-1"
        "HDMI-A-2"
      ];
    };

    services.easyeffects.enable = true;

    programs.niri.settings.outputs = {
      "HDMI-A-1" = {
        position = {
          x = 0;
          y = 0;
        };
        transform.rotation = 90;
      };

      "DP-1" = {
        mode = {
          width = 2560;
          height = 1440;
          refresh = 180.;
        };
        position = {
          x = 1080;
          y = 0;
        };
      };

      # let niri place DP-2 automatically

      "HDMI-A-2".position = {
        x = 1080;
        y = 1440;
      };
    };

    wayland.windowManager.hyprland.settings = {
      monitor = [
        "HDMI-A-1,preferred,0x0,1,transform,1"
        "DP-1,2560x1440@180,1080x0,1"
        "DP-2,preferred,auto-right,1"
        "HDMI-A-2,preferred,1080x1440,1"
      ];
      workspace = [
        "1,monitor:DP-1,default:true"
        "2,monitor:DP-1"
        "3,monitor:DP-1"
        "4,monitor:DP-1"
        "5,monitor:DP-2,default:true"
        "6,monitor:DP-2"
        "7,monitor:DP-2"
        "8,monitor:HDMI-A-1"
        "9,monitor:HDMI-A-1"
        "10,monitor:HDMI-A-1,default:true"
      ];
    };
  };

  musnix.soundcardPciId = "0e:00.4";

  networking = {
    hostName = "breezi";
    hostId = "edafa5da";

    # for development
    firewall.allowedTCPPorts = [ 3000 ];

    hosts."192.168.68.70" = [
      "ai.musicaloft.com"
      "cache.musicaloft.com"
      "cloud.musicaloft.com"
      "git.musicaloft.com"
      "hydra.musicaloft.com"
      "munibot"
      "musicaloft.tplinkdns.com"
      "nixbld.musicaloft.com"
      "ssh.muni.bot"
      "watch.musicaloft.com"
    ];
  };

  nixpkgs.config.rocmSupport = true;

  # for easyeffects
  programs = {
    dconf.enable = true;
    corectrl = {
      enable = true;
    };
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
      enable = true;
      fileSystems = [
        "/"
        "/vault"
      ];
    };

    # enable fstrim for btrfs
    fstrim.enable = true;

    # openrgb
    hardware.openrgb = {
      enable = true;
      package = pkgs.openrgb-with-all-plugins;
    };

    smartd.enable = true;

    surrealdb = {
      enable = true;
      dbPath = "rocksdb:///var/lib/surrealdb";
      port = 7654;
    };
  };

  systemd = {
    extraConfig = "DefaultLimitNOFILE=524288";
    user.extraConfig = "DefaultLimitNOFILE=524288";
  };
}
