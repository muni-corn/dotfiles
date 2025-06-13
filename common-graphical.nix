{
  config,
  pkgs,
  ...
}:
{
  imports = [
    ./greetd.nix
    ./niri.nix
  ];

  boot = {
    extraModulePackages = builtins.attrValues {
      inherit (config.boot.kernelPackages) v4l2loopback;
    };
    kernelModules = [ "v4l2loopback" ];
    plymouth = {
      enable = true;
      font = "${pkgs.inter}/share/fonts/truetype/Inter.ttc";
      theme = "musicaloft-rainbow";
      themePackages = [
        pkgs.plymouth-theme-musicaloft-rainbow
      ];
    };
  };

  environment = {
    defaultPackages = with pkgs; [
      gnome-bluetooth
      kodi
      kdePackages.ksshaskpass
      libcanberra
      libcanberra-gtk3
      muse-sounds
      surrealist
      v4l-utils
      wayfire

      # needed for xdg-open and such
      xdg-utils

      # may or may not be needed after removing hyprland, idk
      qt5.qtwayland
      qt6.qtwayland
    ];

    sessionVariables.NIXOS_OZONE_WL = "1";
  };

  fonts = {
    fontDir.enable = true;

    packages = with pkgs; [
      nerd-fonts.iosevka
      libertine
      material-design-icons
      noto-fonts-cjk-sans
      noto-fonts-extra
    ];
  };

  hardware = {
    # bluetooth
    bluetooth = {
      enable = true;
      settings.General.Experimental = true;
    };

    # enable brillo
    brillo.enable = true;

    # enable driSupport
    graphics.enable = true;

    keyboard.qmk.enable = true;

    # ledger devices
    ledger.enable = true;

    xpadneo.enable = true;
  };

  home-manager.users.muni.programs.chromium = {
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

  location.provider = "geoclue2";

  networking.networkmanager = {
    enable = true;
    dns = "systemd-resolved";
  };

  programs = {
    adb.enable = true;

    evolution = {
      enable = true;
      plugins = [ pkgs.evolution-ews ];
    };

    gphoto2.enable = true;

    # probably needed for minecraft
    java = {
      enable = true;
      package = pkgs.jdk;
    };
  };

  security = {
    # for hyprlock to use password
    pam.services.hyprlock.text = ''
      auth include login
    '';

    # for pipewire. optional, but recommended
    rtkit.enable = true;

    soteria.enable = true;
  };

  services = {
    automatic-timezoned.enable = true;

    blueman.enable = true;

    # for pinentry-gnome3
    dbus.packages = [ pkgs.gcr ];

    geoclue2 = {
      enable = true;
      appConfig.gammastep = {
        isSystem = false;
        isAllowed = true;
      };
    };

    # for mpris album art on muse-shell
    gvfs.enable = true;

    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      jack.enable = true;
    };

    # profile sync daemon, for SSDs and browsers
    psd.enable = true;

    # systemd name resolution
    resolved.enable = true;

    # configure keymap in X11
    xserver.xkb.layout = "us";
  };

  systemd.packages = [
    pkgs.libcanberra
  ];

  users.users.muni = {
    isNormalUser = true;
    description = "municorn";
    extraGroups = [
      "adbusers"
      "audio"
      "camera"
      "corectrl"
      "docker"
      "input"
      "kvm"
      "libvirtd"
      "networkmanager"
      "plugdev"
      "video"
      "wheel"
    ];
    uid = 1001;
  };

  xdg = {
    portal = {
      enable = true;
      xdgOpenUsePortal = true;
    };
    sounds.enable = true;
    terminal-exec = {
      enable = true;
      settings.default = [
        "kitty.desktop"
      ];
    };
  };
}
