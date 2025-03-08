{
  config,
  inputs,
  pkgs,
  ...
}:
let
  gen-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "gen.nvim";
    src = inputs.gen-nvim;
  };
  nv = config.lib.nixvim;

  settings = {
    model = "llama3.1";
    display_mode = "split";
    no_auto_close = true;
    show_prompt = true;
    show_model = true;
  };

  resolveConflict = {
    prompt = "Resolve the following git merge conflict. Only output the result in format ```$filetype\n...\n```:\n```$filetype\n$text\n```";
    replace = true;
    extract = "```$filetype\n(.-)```";
  };
in
{
  programs.nixvim = {
    extraPlugins = [ gen-nvim ];
    extraConfigLua = ''
      require('gen').setup(${nv.toLuaObject settings})
      require('gen').prompts['Resolve_Conflict'] = ${nv.toLuaObject resolveConflict}
    '';
  };
}
