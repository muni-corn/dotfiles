{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.firefox = {
    enable = true;
    package = pkgs.firefox;

    # new default behavior
    configPath = "${config.xdg.configHome}/mozilla/firefox";

    profiles.muni = {
      storeId = "b171c1bd";

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
        #  https://gitlab.com/rycee/nur-expressions/blob/master/pkgs/firefox-addons/generated-firefox-addons.nix
        packages = with pkgs.nur.repos.rycee.firefox-addons; [
          aw-watcher-web
          betterttv
          browserpass
          darkreader
          metamask
          polkadot-js
          pronoundb
          sponsorblock
          ublock-origin
          vimium
          clearurls
          # ronin-wallet
          # ponify-reharmonized
        ];
        settings = lib.mkForce { };
      };
      settings = {
        "extensions.autoDisableScopes" = 0;
        "sidebar.verticalTabs" = false;
        "sidebar.revamp" = true;
        "browser.aboutConfig.showWarning" = false;
        "browser.ml.chat.provider" = "https://chatgpt.com";
        "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
        "browser.newtabpage.activity-stream.newtabWallpapers.highlightDismissed" = true;
        "browser.newtabpage.activity-stream.showSponsored" = false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
      };

      search = {
        default = "musicaloft";
        privateDefault = "musicaloft";
        force = true;
        engines = {
          musicaloft = {
            name = "Musicaloft";
            urls = [
              {
                template = "https://search.musicaloft.com/search";
                params = [
                  {
                    name = "q";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            definedAliases = [ "@m" ];
          };
          nix-packages = {
            name = "Nix Packages";
            urls = [
              {
                template = "https://search.nixos.org/packages";
                params = [
                  {
                    name = "type";
                    value = "packages";
                  }
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];

            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [
              "@n"
              "@np"
            ];
          };
        };
      };
    };
  };
}
