{
  imports = [
    ./clue.nix
  ];

  programs.nixvim.plugins.mini = {
    enable = true;
    modules = {
      animate = {__empty = null;};
      comment = {__empty = null;};
      indentscope = {__empty = null;};
      sessions = {__empty = null;};
      trailspace = {__empty = null;};
    };
  };
}
