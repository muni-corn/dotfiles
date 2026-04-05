{ config, ... }:
{
  services = {
    caddy = {
      enable = true;
      email = "caddy@musicaloft.com";

      virtualHosts."ai.musicaloft.com".extraConfig = ''
        reverse_proxy 127.0.0.1:${toString config.services.open-webui.port}
      '';
    };

    ollama = {
      enable = true;
      environmentVariables = {
        OLLAMA_CONTEXT_LENGTH = "16384";
        GGML_CUDA_ENABLE_UNIFIED_MEMORY = "1";
      };
      host = "[::]";
      loadModels = [
        "gemma4:e2b"
        "gemma4:e4b"
        "gemma4:26b"
        "gemma4:31b"
        "llama3.1"
        "llama3.2"
      ];
      openFirewall = true;
    };

    open-webui = {
      enable = true;
      host = "0.0.0.0";
      openFirewall = true;
      port = 3030;
    };
  };

  # give ollama-post-start an infinite timeout
  systemd.services.ollama.serviceConfig.TimeoutStartSec = "infinity";
}
