{
  config,
  lib,
  pkgs,
  ...
}:
{
  home = {
    activation.setupOpencommit = lib.hm.dag.entryAfter [ "sops-nix" "writeBoundary" ] ''
      run oco config set OCO_AI_PROVIDER=anthropic
      run oco config set OCO_API_KEY=$(cat ${config.sops.secrets.oco_api_key.path})
      run oco config set OCO_MODEL=claude-sonnet-4-0

      run oco config set OCO_DESCRIPTION=false
      run oco config set OCO_EMOJI=false
      run oco config set OCO_GITPUSH=false
      run oco config set OCO_ONE_LINE_COMMIT=true
      run oco config set OCO_TOKENS_MAX_INPUT=32768
    '';
    packages = with pkgs; [
      opencommit
    ];
  };
}
