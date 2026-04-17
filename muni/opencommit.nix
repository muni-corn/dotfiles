{
  lib,
  config,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    opencommit
  ];

  systemd.user.services.opencommit-config = {
    Unit = {
      Description = "Configure opencommit settings";
      After = [ "sops-nix.service" ];
      Requires = [ "sops-nix.service" ];
      Wants = [ "sops-nix.service" ];
    };
    Service = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "setup-opencommit" ''
        ${lib.getExe pkgs.opencommit} config set OCO_AI_PROVIDER=anthropic
        ${lib.getExe pkgs.opencommit} config set OCO_API_KEY=$(${lib.getExe' pkgs.coreutils "cat"} ${config.sops.secrets.oco_api_key.path})
        ${lib.getExe pkgs.opencommit} config set OCO_MODEL=claude-sonnet-4-0

        ${lib.getExe pkgs.opencommit} config set OCO_DESCRIPTION=false
        ${lib.getExe pkgs.opencommit} config set OCO_EMOJI=false
        ${lib.getExe pkgs.opencommit} config set OCO_GITPUSH=false
        ${lib.getExe pkgs.opencommit} config set OCO_ONE_LINE_COMMIT=true
        ${lib.getExe pkgs.opencommit} config set OCO_TOKENS_MAX_INPUT=32768
      '';
      RemainAfterExit = true;
    };
    Install.WantedBy = [ "default.target" ];
  };
}
