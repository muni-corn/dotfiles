{
  programs.zed-editor = {
    enable = true;
    extensions = [
      "biome"
      "html"
      "nix"
      "toml"
    ];

    userKeymaps = [
      {
        context = "vim_mode == insert";
        bindings = {
          "j f" = "vim::NormalBefore";
          "f j" = "vim::NormalBefore";
          "j j" = "vim::NormalBefore";
        };
      }
    ];

    userSettings = {
      agent = {
        default_profile = "write";
        always_allow_tool_actions = true;
        profiles.write = {
          name = "Write";
          tools = {
            copy_path = true;
            create_directory = true;
            create_file = true;
            delete_path = true;
            diagnostics = true;
            edit_file = true;
            fetch = true;
            list_directory = true;
            move_path = true;
            now = true;
            find_path = true;
            read_file = true;
            grep = true;
            terminal = true;
            thinking = true;
            web_search = true;
            open = true;
          };
          enable_all_context_servers = true;
          context_servers = { };
        };
        default_model = {
          provider = "zed.dev";
          model = "claude-sonnet-4-thinking-latest";
        };
        version = "2";
      };
      auto_update = false;
      autosave = "on_window_change";
      buffer_font_family = "Iosevka Muse";
      close_on_file_delete = true;
      diagnostics.inline.enabled = true;
      format_on_save = "on";
      inlay_hints.enabled = true;
      language_models.ollama = {
        api_url = "http://192.168.68.70:11434";
        available_models = [
          {
            name = "gemma3:27b";
            max_tokens = 32768;
          }
        ];
      };
      languages =
        let
          typescriptConfig = {
            language_servers = [
              "typescript-language-server"
              "biome"
            ];
            formatter.external = {
              command = "biome";
              arguments = [
                "check"
                "--fix"
                "--formatter-enabled=true"
                "--linter-enabled=false"
                "--organize-imports-enabled=true"
                "--stdin-file-path={buffer_path}"
              ];
            };
          };
        in
        {
          TypeScript = typescriptConfig;
          TSX = typescriptConfig;
        };
      minimap.show = "auto";
      preview_tabs.enable_preview_from_code_navigation = true;
      soft_wrap = "editor_width";
      tabs.show_diagnostics = "errors";
      telemetry = {
        diagnostics = false;
        metrics = false;
      };
      ui_font_family = "Adwaita Sans";
      use_smartcase_search = true;
      vim.default_mode = "helix_normal";
      vim_mode = true;
    };
  };
}
