{
  imports = [
    ./clue.nix
    ./completion.nix
    ./files.nix
    ./starter.nix
  ];

  programs.nixvim.plugins.mini = {
    enable = true;
    modules = {
      ai.__empty = null;
      animate.__empty = null;
      basics.options.extra_ui = true;
      bracketed.__empty = null;
      bufremove.__empty = null;
      comment.__empty = null;
      diff.view = {
        signs = {
          add = "+";
          change = "~";
          delete = "_";
        };
        style = "sign";
      };
      extra.__empty = null;
      git.__empty = null;
      indentscope.__empty = null;
      jump.__empty = null;
      jump2d.__empty = null;
      move.__empty = null;
      notify = {
        lsp_progress.enable = false;
        window.config.border = "rounded";
      };
      operators.__empty = null;
      pairs.__empty = null;
      pick = {
        options.use_cache = true;
        window = {
          config.border = "rounded";
          prompt_prefix = ": ";
        };
      };
      sessions.__empty = null;
      # statusline = { # TODO
      #   content = {
      #     active = "";
      #     inactive = "";
      #   };
      # };
      splitjoin.__empty = null;
      surround.__empty = null;
      # tabline.format = {__raw = "";}; # TODO
      trailspace.__empty = null;
      visits.__empty = null;
    };
  };
}
