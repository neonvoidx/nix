{ inputs, ... }:
{
  den.aspects.firefox.homeManager =
    {
      config,
      pkgs,
      ...
    }:
    {
      home.sessionVariables = {
        MOZ_ENABLE_WAYLAND = 1;
        MOZ_USE_XINPUT2 = "1";
      };
      programs.firefox = {
        enable = true;
        package = pkgs.firefox.override {
          nativeMessagingHosts = [ pkgs.tridactyl-native ];
        };
        policies = {
          ExtensionSettings = {
            # TODO add each extension here
            "uBlock0@raymondhill.net" = {
              default_area = "menupanel";
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
              installation_mode = "force_installed";
              private_browsing = true;
            };
          };
          DisableTelemetry = true;
          DisplayBookmarksToolbar = "always";
          NoDefaultBookmarks = true;
          OfferToSaveLogins = false;
        };
        profiles.${config.home.username} = {
          isDefault = true;
          extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
            darkreader
            ublock-origin
            violentmonkey
            stylus
            proton-pass
            tab-reloader
            proton-vpn
            gesturefy
            tridactyl
          ];
          settings = {
            "extensions.autoDisableScopes" = 0;
          };
          extraConfig = builtins.readFile "${inputs.self}/assets/.mozilla/user.js";
          userChrome = builtins.readFile "${inputs.self}/assets/.mozilla/chrome/userChrome.css";
          userContent = builtins.readFile "${inputs.self}/assets/.mozilla/chrome/userContent.css";
          search = {
            force = true;
            default = "kagi";
            privateDefault = "kagi";
            order = [
              "kagi"
              "ddg"
            ];
            engines = {
              kagi = {
                name = "Kagi";
                urls = [ { template = "https://kagi.com/search?q={searchTerms}"; } ];
                icon = "https://kagi.com/favicon.ico";
              };
              "ProtonDB" = {
                urls = [
                  {
                    template = "https://www.protondb.com/search";
                    params = [
                      {
                        name = "q";
                        value = "{searchTerms}";
                      }
                    ];
                  }
                ];
                definedAliases = [ "@p" ];
              };
              "Nix Packages" = {
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
                definedAliases = [ "@n" ];
              };
              "Nixpkg PR Tracker" = {
                urls = [
                  {
                    template = "https://nixpkgs-tracker.ocfox.me/";
                    params = [
                      {
                        name = "pr";
                        value = "{searchTerms}";
                      }
                    ];
                  }
                ];
                icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                definedAliases = [ "@npr" ];
              };
              "Home Manager options" = {
                urls = [
                  {
                    template = "https://home-manager-options.extranix.com/";
                    params = [
                      {
                        name = "release";
                        value = "master";
                      }
                      {
                        name = "query";
                        value = "{searchTerms}";
                      }
                    ];
                  }
                ];
                icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                definedAliases = [ "@h" ];
              };
              "NixOS Wiki" = {
                urls = [
                  {
                    template = "https://nixos.wiki/index.php?search={searchTerms}";
                  }
                ];
                icon = "https://nixos.wiki/favicon.png";
                updateInterval = 24 * 60 * 60 * 1000; # every day
                definedAliases = [ "@nw" ];
              };
              bing.metaData.hidden = true;
              google.metaData.hidden = true;
            };
          };
        };
      };
      home.file.".mozilla/firefox/${config.home.username}/chrome/simpleMenuWizard" = {
        recursive = true;
        source = "${inputs.self}/assets/.mozilla/chrome/simpleMenuWizard";
      };
    };
}
