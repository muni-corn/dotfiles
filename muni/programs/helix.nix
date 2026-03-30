{ pkgs, ... }:
{
  programs.helix = {
    enable = true;
    extraPackages = with pkgs; [
      hledger-fmt
      kdlfmt
      lldb_21
      ltex-ls-plus
      markdown-oxide
      mpls
      nixd
      nixfmt
      nodePackages.typescript-language-server
      oxfmt
      oxlint
      pest-ide-tools
      rustledger
      rust-analyzer
      sqruff
      tailwindcss-language-server
      taplo
      tsgolint
      vscode-langservers-extracted
      vtsls
      wgsl-analyzer
      yaml-language-server
    ];
    defaultEditor = true;
    settings = {
      editor = {
        bufferline = "multiple";
        color-modes = true;
        completion-timeout = 50;
        completion-trigger-len = 1;
        cursorline = true;
        end-of-line-diagnostics = "warning";
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

        inline-diagnostics.cursor-line = "hint";

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
          C-m = ":lsp-workspace-command open-preview";
        };
        insert = {
          j.f = "normal_mode";
          j.j = "normal_mode";
        };
      };
    };

    languages = {
      # language server configurations
      language-server = {
        # ls's not bundled with helix
        devenv = {
          command = "devenv";
          args = [ "lsp" ];
          required-root-patterns = [ "devenv.nix" ];
        };
        mpls = {
          command = "mpls";
          args = [
            "--theme"
            "dark"
            "--enable-emoji"
            "--enable-wikilinks"
          ];
        };
        rledger-lsp.command = "rledger-lsp";
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
          args = [
            "--lsp"
          ];
          required-root-patterns = [
            ".oxlintrc.json"
            "oxlint.config.ts"
          ];
          config = {
            typeAware = true;
            typeCheck = true;
            fixKind = "safe_fix";
            unusedDisableDirectives = "warn";
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

          jsonConfig = name: {
            inherit name;
            language-servers = [
              "oxfmt"
              "oxlint"
              {
                name = "vscode-json-language-server";
                except-features = [ "format" ];
              }
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
            name = "ledger";
            file-types = [
              { glob = "*.hledger"; }
              { glob = "*.j"; }
              { glob = "*.journal"; }
            ];
            auto-format = true;
            formatter = {
              command = "hledger-fmt";
              args = [
                "-"
                "--no-diff"
                "--exit-zero-on-changes"
              ];
            };
          }
          {
            name = "hlrules";
            scope = "source.ledger";
            file-types = [
              { glob = "*.rules"; }
            ];
            auto-format = false;
            grammar = "ledger";
          }

          # markdown
          {
            name = "markdown";
            auto-format = true;
            language-servers = [
              "oxfmt"
              "ltex-ls-plus"
              "markdown-oxide"
              "mpls"
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
            language-servers = [
              "nixd"
              "devenv"
            ];
          }

          # python
          {
            name = "python";
            auto-format = true;
          }

          # rustledger
          {
            name = "beancount";
            auto-format = true;
            language-servers = [ "rledger-lsp" ];
          }

          # scss
          {
            name = "scss";
            auto-format = true;
            language-servers = [
              "oxfmt"
              "tailwind"
            ];
          }

          # sql
          {
            name = "sql";
            auto-format = true;
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
          (jsonConfig "json")
          (jsonConfig "json-ld")
          (jsonConfig "jsonc")
        ];
    };
  };

  systemd.user.sessionVariables = {
    EDITOR = "hx";
    VISUAL = "hx";
  };
}
