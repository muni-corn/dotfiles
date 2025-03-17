{ pkgs, ... }:
{
  imports = [
    ./programs
    ./sops
  ];

  home = {
    extraOutputsToInstall = [
      "doc"
      "info"
      "devdoc"
    ];

    stateVersion = "21.11";

    # Home Manager needs a bit of information about you and the
    # paths it should manage.
    username = "muni";
    homeDirectory = "/home/muni";

    sessionPath = [
      "$HOME/.cargo/bin"
      "$HOME/.local/bin"
      "$HOME/.npm/bin"
    ];

    sessionVariables = {
      "ZELLIJ_AUTO_EXIT" = "true";
    };

    packages = with pkgs; [
      # audio and music
      flac
      playerctl
      sox

      # terminal/cli stuff
      fd
      fend
      ffmpeg-full
      jdupes
      neovim-remote
      ouch
      pv
      qpdf
      sd
      sshfs
      zip

      # development/programming
      biome
      docker-compose
      dprint
      gcc
      lld
      markdown-oxide
      meld
      nixd
      nixfmt-rfc-style
      nodePackages.prettier
      nodePackages.typescript-language-server
      nodejs
      python3
      tailwindcss-language-server
      zls

      # other things
      fnlfmt
      fortune
      imagemagick
      peaclock
      protonvpn-cli
      qrencode
      vrc-get
      wirelesstools
    ];
  };

  services.taskwarrior-sync = {
    enable = true;
    package = pkgs.taskwarrior3;
  };
}
