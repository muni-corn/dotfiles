{pkgs, ...}: {
  home-manager.users.muni.home.packages = with pkgs; [
    # games
    ace-of-penguins
    gamehub
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
}
