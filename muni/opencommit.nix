{
  config,
  lib,
  pkgs,
  ...
}:
{
  home = {
    activation.setupOpencommit = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      run oco config set OCO_AI_PROVIDER=anthropic
      run oco config set OCO_TOKENS_MAX_INPUT=32768
      run oco config set OCO_TOKENS_MAX_OUTPUT=1000
      run oco config set OCO_EMOJI=false
      run oco config set OCO_MODEL=claude-sonnet-4-0
      run oco config set OCO_API_KEY=$(cat ${config.sops.secrets.oco_api_key.path})
    '';
    packages = with pkgs; [
      opencommit
    ];
  };
}
