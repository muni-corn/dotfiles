{ config, pkgs, ... }:
let
  toml = pkgs.formats.toml { };
in
{
  imports = [
    ./ai
    ./files.nix
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

  nix.extraOptions = ''
    !include ${config.sops.secrets.nix-access-tokens.path}
  '';

  services.tldr-update.enable = true;

  systemd.user.tmpfiles.rules = [
    # create the downloads subvolume with cleanup after 30 days
    "v ${config.xdg.userDirs.download} - - - 30d -"

    # automatically delete trash entires older than 30 days
    "v ${config.xdg.dataHome}/Trash - - - 30d -"

    # create xdg directories as subvolumes;
    # these are also git-annex repositories
    # and subvolumes backed up with btrbk
    "v ${config.xdg.userDirs.documents} - - - - -"
    "v ${config.xdg.userDirs.music} - - - - -"
    "v ${config.xdg.userDirs.pictures} - - - - -"
    "v ${config.xdg.userDirs.videos} - - - - -"

    # create Steam recordings folder as a subvolume so it is not included in btrbk backups
    "v ${config.xdg.userDirs.videos}/Recordings/steam - - - - -"

    # create a subvolume for the code directory
    "v ${config.home.homeDirectory}/code - - - - -"
  ];

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
    mimeApps.defaultApplications = {
      "text/plain" = "Helix.desktop";
    };

    portal = {
      enable = true;
      xdgOpenUsePortal = true;

      config.common.default = [
        "gnome"
        "gtk"
      ];
      extraPortals = with pkgs; [
        xdg-desktop-portal-gnome
        xdg-desktop-portal-gtk
      ];
    };

    # let nix manage user-dirs.dirs
    userDirs.enable = true;
  };
}
