{
  imports = [
    ./clue.nix
    ./files.nix
    ./starter.nix
  ];

  programs.nixvim.plugins.mini = {
    enable = true;
    modules = {
      ai = {__empty = null;};
      animate = {__empty = null;};
      basics.options.extra_ui = true;
      bracketed = {__empty = null;};
      comment = {__empty = null;};
      extra = {__empty = null;};
      indentscope = {__empty = null;};
      notify = {window.config.border = "rounded";};
      pairs = {__empty = null;};
      pick = {window.config.border = "rounded";};
      sessions = {autoread = true;};
      surround = {__empty = null;};
      trailspace = {__empty = null;};
    };
  };
}
