{
  programs.nixvim.plugins.mini = {
    luaConfig.post = "MiniIcons.tweak_lsp_kind()";
    modules.icons.__empty = null;
  };
}
