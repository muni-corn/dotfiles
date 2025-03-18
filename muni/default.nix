{ pkgs, ... }:
{
  imports = [
    ./programs
    ./sops
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

    sessionVariables = {
      "ZELLIJ_AUTO_EXIT" = "true";
    };

    packages = with pkgs; [
      # audio and music
      flac
      playerctl
      sox

      # terminal/cli stuff
      fd
      fend
      ffmpeg-full
      jdupes
      neovim-remote
      ouch
      pv
      qpdf
      sd
      sshfs
      zip

      # development/programming
      biome
      docker-compose
      dprint
      gcc
      gitui
      lld
      markdown-oxide
      meld
      mr
      nixd
      nixfmt-rfc-style
      nodePackages.prettier
      nodePackages.typescript-language-server
      nodejs
      python3
      tailwindcss-language-server
      zls

      # other things
      fnlfmt
      fortune
      imagemagick
      peaclock
      protonvpn-cli
      qrencode
      vrc-get
      wirelesstools
    ];
  };

  services.taskwarrior-sync = {
    enable = true;
    package = pkgs.taskwarrior3;
  };

  xdg =
    let
      toml = pkgs.formats.toml { };
    in
    {
      enable = true;
      configFile = {
        "peaclock.conf".source = ./peaclock.conf;
        "rustfmt/rustfmt.toml".source = toml.generate "rustfmt-config" {
          condense_wildcard_suffixes = true;
          edition = "2021";
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
        "gitui/key_bindings.ron".text = ''
          (
              move_left: Some(( code: Char('h'), modifiers: "")),
              move_right: Some(( code: Char('l'), modifiers: "")),
              move_up: Some(( code: Char('k'), modifiers: "")),
              move_down: Some(( code: Char('j'), modifiers: "")),

              stash_open: Some(( code: Char('l'), modifiers: "")),
              open_help: Some(( code: F(1), modifiers: "")),

              status_reset_item: Some(( code: Char('U'), modifiers: "SHIFT")),
          )
        '';
      };
    };

}
