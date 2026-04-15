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
    ./tmpfiles.nix
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
      "$HOME/.local/bin"
      "$HOME/.npm/bin"
    ];
  };

  nix.extraOptions = ''
    !include ${config.sops.secrets.nix-access-tokens.path}
  '';

  services.tldr-update.enable = true;

  xdg = {
    enable = true;
    configFile = {
      "peaclock.conf".source = ./peaclock.conf;
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
    userDirs = {
      enable = true;
      setSessionVariables = true;
    };
  };
}
