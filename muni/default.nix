{ pkgs, ... }:
let
  toml = pkgs.formats.toml { };
in
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

    file = {
      # must be included verbatim because toml.generate will quote keys with slashes, and mr doesn't like that
      # maybe we should try ini instead
      ".mrconfig".text = ''
        [Documents]
        update = git annex assist
        order = 1

        [Music]
        update = git annex assist
        order = 90

        [Pictures]
        update = git annex assist
        order = 20

        [Videos]
        update = git annex assist
        order = 15

        [dotfiles]
        checkout = git clone 'https://codeberg.org/municorn/dotfiles' 'dotfiles'

        [code/muni-wallpapers]
        checkout = git clone 'git@github.com:muni-corn/muni-wallpapers.git' 'muni-wallpapers'

        [code/muni_bot]
        checkout = git clone 'https://github.com/muni-corn/muni_bot' 'muni_bot'

        [code/muse-shell]
        checkout = git clone 'https://github.com/muni-corn/muse-shell' 'muse-shell'

        [code/muse-sounds]
        checkout = git clone 'git@codeberg.org:municorn/muse-sounds' 'muse-sounds'

        [code/musicaloft-web]
        checkout = git clone 'git@github.com:musicaloft/musicaloft-web.git' 'musicaloft-web'

        [code/silverfox]
        checkout = git clone 'https://github.com/muni-corn/silverfox' 'silverfox'

        [code/unity/muni-vrc]
        checkout = git clone 'git@github.com:muni-corn/muni-vrc' 'muni-vrc'

        [code/apollo]
        skip = true
        chain = true

        [code/liberdus]
        skip = true
        chain = true
      '';
    };

    sessionPath = [
      "$HOME/.cargo/bin"
      "$HOME/.local/bin"
      "$HOME/.npm/bin"
    ];

    sessionVariables = {
      "ZELLIJ_AUTO_EXIT" = "true";
      "STARSHIP_LOG" = "error";
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
      perl # for mr
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

  xdg = {
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
