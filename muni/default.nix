{ pkgs, ... }:
let
  toml = pkgs.formats.toml { };
in
{
  imports = [
    ./ai
    ./opencommit.nix
    ./packages
    ./programs
    ./sops
    ./syncthing.nix
  ];

  home = {
    extraOutputsToInstall = [
      "doc"
      "info"
      "devdoc"
    ];

    stateVersion = "21.11";

    # Home Manager needs a bit of information about you and the
    # paths it should manage.
    username = "muni";
    homeDirectory = "/home/muni";

    sessionPath = [
      "$HOME/.cargo/bin"
      "$HOME/.local/bin"
      "$HOME/.npm/bin"
    ];
  };

  services.tldr-update.enable = true;

  xdg = {
    enable = true;
    configFile = {
      "peaclock.conf".source = ./peaclock.conf;
      "rustfmt/rustfmt.toml".source = toml.generate "rustfmt-config" {
        condense_wildcard_suffixes = true;
        edition = "2024";
        format_code_in_doc_comments = true;
        format_macro_bodies = true;
        format_macro_matchers = true;
        group_imports = "StdExternalCrate";
        imports_granularity = "Crate";
        normalize_comments = true;
        normalize_doc_attributes = true;
        reorder_impl_items = true;
        use_field_init_shorthand = true;
        use_try_shorthand = true;
        wrap_comments = true;
      };
      "helix/runtime/queries/rust/injections.scm".text = ''
        ((macro_invocation
           macro:
             [
               (scoped_identifier
                 name: (_) @_macro_name)
               (identifier) @_macro_name
             ]
           (token_tree) @injection.content)
         (#eq? @_macro_name "view")
         (#set! injection.language "html")
         (#set! injection.include-children))
      '';
    };
  };
}
