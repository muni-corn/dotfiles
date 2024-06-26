{
  config,
  pkgs,
  ...
}: {
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
  };

  hardware = {
    opengl = {
      extraPackages = with pkgs; [
        amdvlk
        rocmPackages.clr
        rocmPackages.clr.icd
      ];
      extraPackages32 = with pkgs; [
        driversi686Linux.amdvlk
      ];
      driSupport32Bit = true;
    };
  };

  home-manager.users.muni = {
    home.packages = with pkgs; [
      vscode-fhs

      # photo
      gmic
      gmic-qt
      upscayl

      # audio, sound, and music
      ardour
      audacity
      autotalent
      calf
      easyeffects
      geonkick
      lsp-plugins
      musescore
      pamixer
      qpwgraph
      sfizz
      x42-gmsynth
      x42-plugins
      zyn-fusion

      # video
      blender-hip
      ffmpeg-full
      kdenlive
      libva-utils
      mediainfo
      movit
      synfigstudio

      # emulators and "emulators"
      wineWowPackages.waylandFull
      winetricks

      # games
      ace-of-penguins
      gnome.aisleriot
      godot_4
      #itch
      kdePackages.kmines
      kdePackages.kpat
      lutris
      prismlauncher
      protonup-qt
      r2modman
      tty-solitaire
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

      hyprlock.settings = (import ../utils.nix {inherit config;}).mkHyprlockSettings ["DP-2" "HDMI-A-1" "HDMI-A-2"];

      obs-studio = {
        enable = true;
        plugins = with pkgs.obs-studio-plugins; [
          obs-pipewire-audio-capture
        ];
      };
    };

    systemd.user.services.hydroxide = {
      Unit = {
        Description = "hydroxide service";
      };

      Service = {
        ExecStart = "${pkgs.hydroxide}/bin/hydroxide -carddav-port 8079 serve";
        Restart = "always";
        RestartSec = 10;
      };

      Install = {
        WantedBy = ["default.target"];
      };
    };

    wayland.windowManager.hyprland.settings.workspace = [
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
  };

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
