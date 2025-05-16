{
  services = {
    caddy = {
      enable = true;
      email = "caddy@musicaloft.com";

      virtualHosts."ai.musicaloft.com" = {
        extraConfig = ''
          reverse_proxy 127.0.0.1:3030
        '';
      };
    };

    comfyui = {
      enable = true;
      # package = pkgs.comfyui-nvidia;
      host = "0.0.0.0";
      # models = builtins.attrValues pkgs.nixified-ai.models;
      # customNodes = with pkgs.comfyui.pkgs; [
      #   comfyui-gguf
      #   comfyui-impact-pack
      # ];
    };

    ollama = {
      enable = true;
      environmentVariables = {
        OLLAMA_CONTEXT_LENGTH = "32768";
        GGML_CUDA_ENABLE_UNIFIED_MEMORY = "1";
      };
      host = "[::]";
      loadModels = [
        "deepseek-r1:70b"
        "deepseek-r1:8b"
        "gemma3:1b"
        "gemma3:4b"
        "gemma3:27b"
        "llama3.1:8b"
        "llama3.2:3b"
        "llama3.3:70b"
        "llama4:scout"
        "qwen3:0.6b"
        "qwen3:8b"
        "qwen3:14b"
        "qwen3:32b"
        "qwen3:30b-a3b"
        "qwen3:235b-a22b"
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
