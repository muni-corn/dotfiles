{
  config,
  inputs,
  pkgs,
  ...
}:
{
  services = {
    caddy = {
      enable = true;
      email = "caddy@musicaloft.com";

      virtualHosts = {
        "comfy.musicaloft.com".extraConfig = ''
          reverse_proxy 127.0.0.1:${builtins.toString config.services.comfyui.port}
        '';
        "ai.musicaloft.com".extraConfig = ''
          reverse_proxy 127.0.0.1:${builtins.toString config.services.open-webui.port}
        '';
      };
    };

    comfyui = {
      enable = true;
      package = inputs.nixified-ai.packages.x86_64-linux.comfyui-nvidia;
      host = "0.0.0.0";
      openFirewall = true;
      # models = builtins.attrValues pkgs.nixified-ai.models;
      customNodes = with pkgs.comfyuiPackages; [
        comfyui-gguf
        # comfyui-impact-pack
      ];
    };

    ollama = {
      enable = true;
      environmentVariables = {
        OLLAMA_CONTEXT_LENGTH = "32768";
        GGML_CUDA_ENABLE_UNIFIED_MEMORY = "1";
      };
      host = "[::]";
      loadModels = [
        "command-r"
        "deepseek-r1"
        "deepseek-r1:32b"
        "devstral"
        "gemma3n"
        "gemma3:1b"
        "gemma3:4b"
        "gemma3:27b"
        "llama3.1"
        "llama3.2"
        "llama3.3"
        "llama4:scout"
        "mistral-small3.1"
        "qwen3-coder"
        "qwen3:0.6b"
        "qwen3:8b"
        "qwen3:14b"
        "qwen3:30b"
        "qwen3:32b"
        "qwq" # hehe
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
