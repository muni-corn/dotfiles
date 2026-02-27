{ pkgs, ... }:
{
  programs.helix = {
    enable = true;
    extraPackages = with pkgs; [
      kdlfmt
      lldb_21
      ltex-ls-plus
      markdown-oxide
      nixd
      nixfmt
      nodePackages.typescript-language-server
      oxlint
      oxfmt
      pest-ide-tools
      rust-analyzer
      sqruff
      taplo
      tailwindcss-language-server
      tsgolint
      vscode-langservers-extracted
      vtsls
      wgsl-analyzer

      (mdformat.withPlugins (
        p: with p; [
          mdformat-admon
          mdformat-footnote
          mdformat-frontmatter
          mdformat-simple-breaks
          mdformat-gfm
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
      # language server configurations
      language-server = {
        # ls's not bundled with helix
        sqruff = {
          command = "sqruff";
          args = [
            "lsp"
            "--parsing-errors"
          ];
        };
        tailwind = {
          command = "tailwindcss-language-server";
          args = [ "--stdio" ];
        };
        oxlint = {
          command = "oxlint";
          args = [ "--lsp" ];
          required-root-patterns = [
            ".oxlintrc.json"
            "oxlint.config.ts"
          ];
          config = {
            typeAware = true;
            fixKind = "safe_fix";
          };
        };
        oxfmt = {
          command = "oxfmt";
          args = [ "--lsp" ];
          required-root-patterns = [
            ".oxfmtrc.json"
          ];
        };
        vtsls = {
          command = "vtsls";
          args = [ "--stdio" ];
          config.hostInfo = "helix";
        };

        # configure rust-analyzer
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
      };

      # configurations for languages
      language =
        let
          jsConfig = name: {
            inherit name;
            auto-format = true;
            language-servers = [
              "oxfmt"
              "oxlint"
              {
                name = "vtsls";
                except-features = [ "format" ];
              }
              "tailwind"
            ];
          };
        in
        [
          {
            name = "rust";
            auto-pairs = {
              "(" = ")";
              "{" = "}";
              "[" = "]";
              "\"" = ''"'';
              "`" = "`";
              "<" = ">";
            };
            formatter.command = "rustfmt";
          }

          # hledger
          {
            name = "hledger";
            scope = "source.hledger";
            file-types = [
              { glob = "*.hledger"; }
              { glob = "*.j"; }
              { glob = "*.journal"; }
              { glob = "*.rules"; }
            ];
            grammar = "ledger";
          }

          # markdown
          {
            name = "markdown";
            auto-format = true;
            formatter = {
              command = "mdformat";
              args = [
                "-"
              ];
            };
            language-servers = [
              "ltex-ls-plus"
              "markdown-oxide"
            ];
            auto-pairs = {
              "*" = "*";
              "_" = "_";
              "(" = ")";
              "[" = "]";
            };
          }

          # nix
          {
            name = "nix";
            formatter.command = "nixfmt";
            auto-format = true;
          }

          # scss
          {
            name = "scss";
            auto-format = true;
            formatter = {
              command = "dprint";
              args = [
                "fmt"
                "--stdin"
                "scss"
              ];
            };
          }

          # sql
          {
            name = "sql";
            auto-format = true;
            formatter = {
              command = "sqruff";
              args = [
                "fix"
                "-"
              ];
            };
            language-servers = [ "sqruff" ];
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

          # wgsl
          {
            name = "wgsl";
            auto-format = true;
            formatter.command = "wgslfmt";
          }

          # javascript and adjacent languages
          (jsConfig "javascript")
          (jsConfig "typescript")
          (jsConfig "tsx")
          (jsConfig "jsx")
          {
            name = "json";
            language-servers = [
              "oxfmt"
              "oxlint"
              {
                name = "vscode-json-language-server";
                except-features = [ "format" ];
              }
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
