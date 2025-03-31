{
  programs.helix = {
    enable = true;
    defaultEditor = true;
    settings = {
      editor = {
        bufferline = "multiple";
        color-modes = true;
        completion-timeout = 50;
        completion-trigger-len = 1;
        cursorline = true;
        end-of-line-diagnostics = "info";
        jump-label-alphabet = "fjdkslaghtyrueiwoqpbnvmcxz";
        line-number = "relative";

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
          left = [
            "mode"
            "file-name"
            "read-only-indicator"
            "file-modification-indicator"
            "version-control"
          ];
          center = [
            "spinner"
            "diagnostics"
          ];
          right = [
            "file-type"
            "register"
            "selections"
            "primary-selection-length"
            "position"
            "total-line-numbers"
            "position-percentage"
          ];

          mode = {
            normal = "n";
            insert = "i";
            select = "s";
          };
        };

        whitespace.render = {
          space = "none";
          tab = "all";
          nbsp = "all";
          nnbsp = "all";
          newline = "none";
        };
      };
      keys = {
        normal = {
          space.space = "file_picker";
          space.w = ":w";
          space.q = ":q";
        };
        insert = {
          f.j = "normal_mode";
          j.j = "normal_mode";
        };
      };
    };
    languages = {
      language-server = {
        rust-analyzer = {
          config = {
            cargo = {
              autoreload = true;
              buildScripts.enable = true;
              features = "all";
            };
            check.command = "clippy";
            diagnostics.disabled = [
              "unresolved-proc-macro"
              "unresolved-macro-call"
              "macro-error"
            ];
            inlayHints = {
              closureReturnTypeHints.enable = "with_block";
              expressionAdjustmentHints = {
                enable = "reborrow";
                hideOutsideUnsafe = true;
              };
              lifetimeElisionHints.enable = "skip_trivial";
              renderColons = false;
              parameterHints.enable = false;
              typeHints = {
                enable = false;
                hideClosureInitialization = true;
                hideClosureParameter = true;
                hideNamedConstructor = true;
              };
            };
            rustfmt.rangeFormatting.enable = true;
            notifications.cargoTomlNotFound = false;
          };
        };
        biome = {
          command = "biome";
          args = [ "lsp-proxy" ];
        };
      };
      language = [
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
        {
          name = "markdown";
          auto-format = true;
          formatter = {
            command = "dprint";
            args = [
              "fmt"
              "--stdin"
              "md"
            ];
          };
          auto-pairs = {
            "*" = "*";
            "_" = "_";
            "(" = ")";
            "[" = "]";
          };
        }
        {
          name = "nix";
          formatter.command = "nixfmt";
          auto-format = true;
        }
        {
          name = "neorg";
          grammar = "tree-sitter-norg";
          file-types = [ "norg" ];
          scope = "text.norg";
        }
        {
          name = "toml";
          auto-format = true;
          formatter = {
            command = "dprint";
            args = [
              "fmt"
              "--stdin"
              "toml"
            ];
          };
          auto-pairs = {
            "[" = "]";
            "{" = "}";
            "\"" = ''"'';
          };
        }

        # javascript and adjacent languages
        {
          name = "tsx";
          formatter = {
            command = "prettier";
            args = [
              "-w"
              "--parser"
              "typescript"
            ];
          };
          auto-format = true;
        }
        {
          name = "javascript";
          language-servers = [
            {
              name = "typescript-language-server";
              except-features = [ "format" ];
            }
            "biome"
          ];
          auto-format = true;
        }
        {
          name = "typescript";
          language-servers = [
            {
              name = "typescript-language-server";
              except-features = [ "format" ];
            }
            "biome"
          ];
          auto-format = true;
        }
        {
          name = "tsx";
          auto-format = true;
          language-servers = [
            {
              name = "typescript-language-server";
              except-features = [ "format" ];
            }
            "biome"
          ];
        }
        {
          name = "jsx";
          auto-format = true;
          language-servers = [
            {
              name = "typescript-language-server";
              except-features = [ "format" ];
            }
            "biome"
          ];
        }
        {
          name = "json";
          language-servers = [
            {
              name = "vscode-json-language-server";
              except-features = [ "format" ];
            }
            "biome"
          ];
        }
      ];
    };
  };
}
