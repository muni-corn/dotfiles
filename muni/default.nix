{ pkgs, ... }:
{
  imports = [
    ./programs
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
      docker-compose
      gcc
      lld
      meld
      nixd
      nixfmt-rfc-style
      nodejs
      nodePackages.typescript-language-server
      python3
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

  services.taskwarrior-sync.enable = true;
}
