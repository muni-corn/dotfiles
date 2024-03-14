{
  programs.nixvim.plugins.lspkind = {
    enable = true;

    cmp = {
      enable = true;
      menu = {
        buffer = "buf";
        nvim_lsp = "lsp";
        calc = "cal";
      };
    };

    symbolMap = {
      Boolean = " ";
      Character = "󰾹 ";
      Class = " ";
      Color = " ";
      Constant = " ";
      Constructor = "󰫣 ";
      Enum = " ";
      EnumMember = " ";
      Event = " ";
      Field = " ";
      File = " ";
      Folder = " ";
      Function = "󰊕 ";
      Interface = " ";
      Keyword = " ";
      Method = " ";
      Module = "󱒌 ";
      Number = " ";
      Operator = " ";
      Parameter = " ";
      Property = " ";
      Reference = " ";
      Snippet = " ";
      String = " ";
      Struct = " ";
      Text = "󰬴 ";
      TypeParameter = " ";
      Unit = " ";
      Value = "󰞾 ";
      Variable = " ";
    };
  };
}
