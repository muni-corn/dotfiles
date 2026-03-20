{ config, pkgs, ... }:
{
  xdg.configFile."cocoa/cocoa.toml".source = pkgs.writers.writeTOML "cocoa.toml" {
    ai = {
      provider = "Anthropic";
      model = "claude-haiku-4-5";
      temperature = 0.2;
      secret.file = config.sops.secrets.cocoa_anthropic_key.path;
    };
  };
}
