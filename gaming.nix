{
  config,
  inputs,
  pkgs,
  ...
}: let
  universal-pidff = config.boot.kernelPackages.callPackage "${inputs.moza-racing-wheel}/universal-pidff/universal-pidff.nix" {};
  # boxflat = inputs.moza-racing-wheel.packages.${pkgs.hostPlatform.system}.boxflat;
in {
  boot.extraModulePackages = [universal-pidff];

  # environment.systemPackages = [boxflat];

  home-manager.users.muni.home.packages = with pkgs; [
    ace-of-penguins
    gamehub
    aisleriot
    godot_4
    #itch
    kdePackages.kmines
    kdePackages.kpat
    lutris
    oversteer
    prismlauncher
    protonup-qt
    r2modman
    tty-solitaire
  ];

  programs = {
    gamescope = {
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
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
    };
  };

  services.udev.extraRules = ''
    SUBSYSTEM=="tty", KERNEL=="ttyACM*", ATTRS{idVendor}=="346e", ACTION=="add", MODE="0666", TAG+="uaccess"
  '';
}
