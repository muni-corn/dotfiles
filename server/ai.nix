{
  services.ollama = {
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
    ];
    openFirewall = true;
  };
}
