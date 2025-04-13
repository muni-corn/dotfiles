{
  services = {

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
        OLLAMA_CONTEXT_LENGTH = "8192";
        GGML_CUDA_ENABLE_UNIFIED_MEMORY = "1";
      };
      host = "[::]";
      loadModels = [
        "llama3.1:8b"
        "llama3.2:3b"
        "llama3.3:70b"
        "deepseek-r1:8b"
        "deepseek-r1:70b"
        "qwq" # hehe
        "gemma3:1b"
        "gemma3:4b"
        "gemma3:27b"
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
