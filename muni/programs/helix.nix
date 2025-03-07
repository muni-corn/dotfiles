{
  programs.helix = {
    enable = true;
    defaultEditor = true;
    settings = {
      editor = {
        line-number = "relative";
        completion-timeout = 50;
        completion-trigger-len = 1;
        bufferline = "multiple";
        color-modes = true;
        jump-label-alphabet = "fjdkslaghtyrueiwoqpbnvmcxz";
        end-of-line-diagnostics = "info";

        auto-save = {
          focus-lost = true;
          after-delay.enable = true;
        };

        cursor-shape.insert = "bar";

        indent-guides = {
          render = true;
          character = "┆";
        };

        inline-diagnostics = {
          cursor-line = "hint";
          other-lines = "info";
        };

        lsp = {
          display-messages = true;
          display-progress-messages = true;
          display-inlay-hints = true;
        };

        soft-wrap.enable = true;

        statusline = {
          left = ["mode" "file-name" "read-only-indicator" "file-modification-indicator" "version-control"];
          center = ["spinner" "diagnostics"];
          right = ["file-type" "register" "selections" "primary-selection-length" "position" "total-line-numbers" "position-percentage"];

          mode = {
            normal = "n";
            insert = "i";
            select = "s";
          };
        };

        whitespace.render = "all";
      };
      keys.normal = {
        space.space = "file_picker";
        space.w = ":w";
        space.q = ":q";
      };
    };
    languages.language = [
      {
        name = "rust";
        auto-pairs = {
          "(" = '')'';
          "{" = ''}'';
          "[" = '']'';
          "\"" = ''"'';
          "`" = ''`'';
          "<" = ''>'';
        };
      }
    ];
  };
}
