{
  config,
  pkgs,
  ...
}:
{
  home.sessionVariables = {
    NNN_FCOLORS = "06030c0200050e08010b0d01";
    NNN_OPENER = pkgs.writeTextFile {
      name = "nuke";
      text = ''
        #!${config.programs.fish.package}/bin/fish

        ${builtins.readFile ./nuke.fish}
      '';
      executable = true;
    };
    NNN_OPTS = "acEHU";
  };

  programs.nnn = {
    enable = true;
    package = pkgs.nnn.override { withNerdIcons = true; };
    extraPackages = with pkgs; [
      ffmpegthumbnailer
      mediainfo
    ];

    bookmarks = {
      D = "~/dotfiles";
      M = "~/Documents";
      a = "~/Music/ardour";
      c = "~/code";
      d = "~/Documents";
      m = "~/Music";
      n = "~/notebook";
      o = "~/Downloads";
      p = "~/Pictures";
      s = "~/sync";
      v = "~/Videos";
    };
    plugins = {
      src =
        (pkgs.fetchFromGitHub {
          owner = "jarun";
          repo = "nnn";
          rev = "v4.8";
          sha256 = "sha256-QbKW2wjhUNej3zoX18LdeUHqjNLYhEKyvPH2MXzp/iQ=";
        })
        + "/plugins";
      mappings = {
        c = "fzcd";
        d = "dragdrop";
        f = "fzopen";
        o = "launch";
        p = "preview-tui";
        v = "imgview";
      };
    };
  };
}
