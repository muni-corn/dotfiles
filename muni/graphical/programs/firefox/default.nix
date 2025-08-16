{ pkgs, ... }:
{
  programs.firefox = {
    enable = true;
    package = pkgs.firefox-wayland;
    profiles.muni = {
      containers = {
        Personal = {
          icon = "fingerprint";
          color = "blue";
          id = 1;
        };
        Work = {
          icon = "briefcase";
          color = "orange";
          id = 2;
        };
        Banking = {
          icon = "dollar";
          color = "green";
          id = 3;
        };
        Shopping = {
          icon = "cart";
          color = "pink";
          id = 4;
        };
      };
      containersForce = true;

      extensions = {
        packages = with pkgs.nur.repos.rycee.firefox-addons; [
          betterttv
          browserpass
          darkreader
          metamask
          polkadot-js
          pronoundb
          ublock-origin
          vimium
          clearurls
          # ronin-wallet
          # ponify-reharmonized
        ];
      };
      settings = {
        "extensions.autoDisableScopes" = 0;
        "sidebar.verticalTabs" = false;
        "sidebar.revamp" = true;
        "browser.aboutConfig.showWarning" = false;
        "browser.ml.chat.provider" = "https://chatgpt.com";
        "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
        "browser.newtabpage.activity-stream.newtabWallpapers.highlightDismissed" = true;
        "browser.newtabpage.activity-stream.newtabWallpapers.wallpaper" = "black-waves";
        "browser.newtabpage.activity-stream.newtabWallpapers.wallpaper-dark" = "black-waves";
        "browser.newtabpage.activity-stream.newtabWallpapers.wallpaper-light" = "black-waves";
        "browser.newtabpage.activity-stream.showSponsored" = false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;

        # for waterfall theme
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "layers.acceleration.force-enabled" = true;
        "gfx.webrender.all" = true;
        "svg.context-properties.content.enabled" = true;
      };
      userChrome = ./waterfall.css;
    };
  };
}
