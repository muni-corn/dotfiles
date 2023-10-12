{
  imports = [
    ./clue.nix
    ./starter.nix
  ];

  programs.nixvim.plugins.mini = {
    enable = true;
    modules = {
      animate = {__empty = null;};
      basics = {
        options = {
          extra_ui = true;
          win_borders = "rounded";
        };
      };
      bracketed = {__empty = null;};
      comment = {__empty = null;};
      files = {__empty = null;};
      indentscope = {__empty = null;};
      sessions = {__empty = null;};
      trailspace = {__empty = null;};
    };
  };
}
