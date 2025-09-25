{ pkgs, ... }:
{
  programs.helix = {
    enable = true;
    extraPackages = with pkgs; [
      biome
      kdlfmt
      lldb_21
      markdown-oxide
      nixd
      nixfmt-rfc-style
      nodePackages.typescript-language-server
      pest-ide-tools
      rust-analyzer
      taplo
      taplo-lsp
      tailwindcss-language-server
      vscode-langservers-extracted
      vtsls
      zls

      (mdformat.withPlugins (
        p: with p; [
          mdformat-admon
          mdformat-footnote
          mdformat-frontmatter
          mdformat-myst
          mdformat-simple-breaks
          mdformat-tables
          mdformat-wikilink
        ]
      ))
    ];
    defaultEditor = true;
    settings = {
      editor = {
        bufferline = "multiple";
        color-modes = true;
        completion-timeout = 50;
        completion-trigger-len = 1;
        cursorline = true;
        end-of-line-diagnostics = "hint";
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
          other-lines = "disable";
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
        rust-analyzer.config = {
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
        tailwind = {
          command = "tailwindcss-language-server";
          args = [ "--stdio" ];
        };
        biome = {
          command = "biome";
          args = [ "lsp-proxy" ];
        };
        vtsls = {
          command = "vtsls";
          args = [ "--stdio" ];
          config.hostInfo = "helix";
        };
      };
      language =
        let
          jsConfig = name: {
            inherit name;
            auto-format = true;
            language-servers = [
              {
                name = "vtsls";
                except-features = [ "format" ];
              }
              "biome"
              "tailwind"
            ];
          };
        in
        [
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
              command = "mdformat";
              args = [
                "-"
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
            name = "toml";
            auto-format = true;
            auto-pairs = {
              "[" = "]";
              "{" = "}";
              "\"" = ''"'';
            };
          }

          # kdl
          {
            name = "kdl";
            auto-format = true;
            formatter = {
              command = "kdlfmt";
              args = [
                "format"
                "--stdin"
              ];
            };
          }

          # javascript and adjacent languages
          (jsConfig "javascript")
          (jsConfig "typescript")
          (jsConfig "tsx")
          (jsConfig "jsx")
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

  systemd.user.sessionVariables = {
    EDITOR = "hx";
    VISUAL = "hx";
  };
}
