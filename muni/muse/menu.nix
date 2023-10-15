{
  config,
  lib,
  ...
}: {
  options.muse = let
    inherit (lib) types mkOption;
  in {
    menu = {
      type = types.submodule {
        options = {
          cmd = mkOption {
            type = types.string;
            description = "The base command for the menu.";
          };
          args = mkOption {
            type = types.listOf types.string;
            description = "List of arguments to pass to the menu command.";
          };
        };
      };
    };
  };

  config = {};
}
