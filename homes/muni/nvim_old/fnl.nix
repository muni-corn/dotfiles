{
  config,
  lib,
  pkgs,
  ...
}: let
  compileFnl = name: file:
    pkgs.runCommand name {} ''
      ${pkgs.fennel}/bin/fennel --compile ${file} > $out
    '';
in {
  options = {
    programs.neovim.extraFnlConfigFiles = with lib;
      mkOption {
        type = types.nullOr (types.listOf types.path);
        default = null;
      };
  };
  config = with lib; {
    programs.neovim.extraConfig = ''
      ${optionalString (config.programs.neovim.extraFnlConfigFiles != null) "lua require('init-hm-fnl-extra')"}
      ${optionalString (hasAttr "fennel" config.programs.neovim.generatedConfigs) "lua require('init-hm-fnl-plugins')"}
    '';

    xdg.configFile = {
      "nvim/lua/init-hm-fnl-plugins.lua" = mkIf (hasAttr "fennel" config.programs.neovim.generatedConfigs) (
        let
          fnlFile = pkgs.writeText "init-hm-plugins.fnl" config.programs.neovim.generatedConfigs.fennel;
        in {
          source = compileFnl "nvim-fnl-plugins-config" fnlFile;
        }
      );
      "nvim/lua/init-hm-fnl-extra.lua" = mkIf (config.programs.neovim.extraFnlConfigFiles != null) (
        let
          fnlFile = pkgs.writeText "init-hm-extra.fnl" (concatMapStrings (path: builtins.readFile path) config.programs.neovim.extraFnlConfigFiles);
        in {
          source = compileFnl "nvim-fnl-extra-config" fnlFile;
        }
      );
    };
  };
}
