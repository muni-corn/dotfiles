# Home Manager module for periodic timewarrior sync
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkPackageOption
    mkOption
    types
    ;

  settingsFormat = pkgs.formats.ini { };
  settingsSubmodule = {
    options = {
      Server.BaseURL = mkOption {
        type = types.str;
        description = "The base URL of the server.";
        example = "http://192.168.12.34:5678";
      };
      Client.UserID = mkOption {
        type = types.int;
        description = "User id.";
        example = 0;
      };
    };
  };
in
{
  meta.maintainers = with lib.maintainers; [ municorn ];

  options.services.timewarrior-sync = {
    enable = mkEnableOption "configuring timew-sync-client";
    package = mkPackageOption pkgs "timew-sync-client" { };
    settings = mkOption {
      description = ''
        Settings written to
        {file}`timewsync.conf`.
      '';
      type = types.submodule settingsSubmodule;
    };
  };

  config =
    let
      cfg = config.services.timewarrior-sync;
    in
    lib.mkIf cfg.enable {
      home = {
        packages = [ cfg.package ];
        file.".timewsync/timewsync.conf".source = settingsFormat.generate "timewsync.conf" cfg.settings;
      };
    };
}
