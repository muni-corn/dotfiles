{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ../common.nix
    ../common-graphical.nix

    ../docker.nix
    ../firewall.nix
    ../gaming.nix
    ../music_production.nix
    ../openssh.nix
    ../sops
    ../video_production.nix
    ../vr.nix
    ./btrbk.nix
    ./hardware.nix
    ./vfio.nix
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
      ];
    };

    services.easyeffects.enable = true;

    wayland.windowManager.hyprland.settings = {
      monitor = [
        "HDMI-A-1,preferred,0x180,1"
        "DP-1,2560x1440@180,1920x0,1"
        "DP-2,preferred,4480x180,1"
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
    hostName = "ponycastle";
    hostId = "edafa5da";
  };

  nixpkgs.config.rocmSupport = true;

  # for easyeffects
  programs = {
    dconf.enable = true;
    corectrl = {
      enable = true;
      gpuOverclock = {
        enable = true;
        ppfeaturemask = "0xffffffff";
      };
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

    create_ap = {
      enable = true;
      settings = {
        CHANNEL = 48;
        INTERNET_IFACE = "enp14s0";
        PASSPHRASE = "mi1ksh@ke";
        WIFI_IFACE = "wlan0";
        SSID = "ponycastle_hotspot";
      };
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
