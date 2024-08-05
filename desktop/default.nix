{
  config,
  pkgs,
  ...
}: {
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
    ./btrbk.nix
    ./hardware.nix
    ./home-assistant.nix
    ./vfio.nix
  ];

  boot.loader = {
    efi.efiSysMountPoint = "/boot/efi";
    systemd-boot.memtest86.enable = true;
  };

  hardware.graphics = {
    extraPackages = with pkgs; [
      amdvlk
      rocmPackages.clr
      rocmPackages.clr.icd
    ];
    extraPackages32 = with pkgs; [
      driversi686Linux.amdvlk
    ];
    enable32Bit = true;
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
          {id = "ajopnjidmegmdimjlfnijceegpefgped";} # betterttv
          {id = "naepdomgkenhinolocfifgehidddafch";} # browserpass
          {id = "eimadpbcbfnmbkopoojfekhnkhdbieeh";} # dark reader
          {id = "nkbihfbeogaeaoehlefnkodbefgpgknn";} # metamask
          {id = "inpoelmimmiplkcldmdljiboidfkcfbh";} # presearch
          {id = "bpaoeijjlplfjbagceilcgbkcdjbomjd";} # ttv lol pro
          {id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";} # ublock origin
          {id = "dbepggeogbaibhgnhhndojpepiihcmeb";} # vimium
        ];
      };

      hyprlock.settings = (import ../utils.nix {inherit config;}).mkHyprlockSettings ["DP-1" "DP-2" "HDMI-A-1"];
    };

    services.easyeffects.enable = true;

    wayland.windowManager.hyprland.settings.workspace = [
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

  musnix.soundcardPciId = "0e:00.4";

  networking = {
    hostName = "ponycastle";
    hostId = "edafa5da";
  };

  nixpkgs.config = {
    rocmTargets = ["gfx1102"];
    rocmSupport = true;
  };

  # for easyeffects
  programs.dconf.enable = true;

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
      fileSystems = ["/" "/vault"];
    };

    # enable fstrim for btrfs
    fstrim.enable = true;

    # openrgb
    hardware.openrgb = {
      enable = true;
      package = pkgs.openrgb-with-all-plugins;
    };

    smartd.enable = true;
  };

  systemd = {
    extraConfig = "DefaultLimitNOFILE=524288";
    user.extraConfig = "DefaultLimitNOFILE=524288";
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?
}
