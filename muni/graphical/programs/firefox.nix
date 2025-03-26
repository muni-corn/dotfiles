{ pkgs, ... }:
{
  programs.firefox = {
    enable = true;
    package = pkgs.firefox-wayland;
    profiles.muni = {
      extensions = {
        packages = with pkgs.nur.repos.rycee.firefox-addons; [
          betterttv
          browserpass
          darkreader
          metamask
          polkadot-js
          pronoundb
          shinigami-eyes
          ublock-origin
          vimium
          # ronin-wallet
          # ponify-reharmonized
        ];
      };
      settings = {
        "extensions.autoDisableScopes" = 0;
        "sidebar.verticalTabs" = true;
      };
    };
  };
}
