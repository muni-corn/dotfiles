{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkOption mkIf types;
  cfg = config.services.muse-status;
in {
  options = {
    services.muse-status = {
      enable = mkEnableOption "the muse-status-daemon service";
      settings = mkOption {
        description = ''
          Settings for the muse-status-daemon service. Doesn't
          generate a config file if null.
        '';
        type = types.nullOr types.attrs;
        default = null;
      };
    };
  };
  config = let
    yaml = pkgs.formats.yaml {};
  in {
    home.packages = [pkgs.muse-status];
    systemd.user.services.muse-status-daemon = {
      Unit.Description = "muse-status daemon";
      Service = {
        Environment = "PATH=$PATH:${pkgs.pamixer}/bin";
        ExecStart = "${pkgs.muse-status}/bin/muse-status-daemon";
      };
      Install.WantedBy = ["graphical-session.target"];
    };
    xdg.configFile."muse-status/daemon.yaml" = mkIf (cfg.settings != null) {
      source = yaml.generate "muse-status-daemon-config" cfg.settings;
    };
  };
}
