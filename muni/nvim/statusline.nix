{pkgs, ...}: let
  compileFnl = name: file:
    pkgs.runCommand name {} ''
      ${pkgs.fennel}/bin/fennel --compile ${file} | head -n-1 > $out
    '';
in {
  programs.nixvim = {
    extraConfigLua = builtins.readFile (compileFnl "statusline" ./statusline.fnl);
    autoCmd = [
      {
        event = ["BufEnter" "WinEnter" "BufRead" "BufWinEnter"];
        pattern = "*";
        command = "setlocal statusline=%!v:lua.active_statusline()";
        group = "statusline";
      }
      {
        event = ["BufLeave" "WinLeave"];
        pattern = "*";
        command = "setlocal statusline=%!v:lua.inactive_statusline()";
        group = "statusline";
      }
    ];
    autoGroups.statusline.clear = false;
  };
}
