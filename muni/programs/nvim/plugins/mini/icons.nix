{
  programs.nixvim = {
    plugins.mini.modules.icons.__empty = null;
    extraConfigLuaPost = ''
      MiniIcons.mock_nvim_web_devicons()
      MiniIcons.tweak_lsp_kind()
    '';
  };
}
