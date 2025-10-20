{
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
        ${pkgs.opencommit}/bin/oco config set OCO_AI_PROVIDER=anthropic
        ${pkgs.opencommit}/bin/oco config set OCO_API_KEY=$(${pkgs.coreutils}/bin/cat ${config.sops.secrets.oco_api_key.path})
        ${pkgs.opencommit}/bin/oco config set OCO_MODEL=claude-haiku-4-5

        ${pkgs.opencommit}/bin/oco config set OCO_DESCRIPTION=false
        ${pkgs.opencommit}/bin/oco config set OCO_EMOJI=false
        ${pkgs.opencommit}/bin/oco config set OCO_GITPUSH=false
        ${pkgs.opencommit}/bin/oco config set OCO_ONE_LINE_COMMIT=true
        ${pkgs.opencommit}/bin/oco config set OCO_TOKENS_MAX_INPUT=32768
      '';
      RemainAfterExit = true;
    };
    Install.WantedBy = [ "default.target" ];
  };
}
