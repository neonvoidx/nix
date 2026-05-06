{ den, inputs, ... }:
{
  den.aspects.firefox =
    { user, ... }:
    {
      homeManager =
        {
          config,
          lib,
          pkgs,
          ...
        }:
        let
          buildXpi = pkgs.nur.repos.rycee.lib.mozilla.mkBuildMozillaXpiAddon {
            inherit (pkgs) stdenv fetchurl;
          };
          customAddons = [
            (buildXpi {
              pname = "alternate-player-twitch";
              version = "5.1.1";
              addonId = "twitch5@coolcmd";
              url = "https://addons.mozilla.org/firefox/downloads/file/4455891/alternate_player_for_twitchtv-5.1.1.xpi";
              sha256 = "4a15770726ed283e4fdcdbede7054338d9ced46a3a631048e3c54ee32c3e210c";
              meta = { };
            })
            (buildXpi {
              pname = "discord-quest-hunter";
              version = "1.1.8";
              addonId = "{ccaf3dc1-9dab-4296-bb1f-0015fb853920}";
              url = "https://addons.mozilla.org/firefox/downloads/file/4454085/discord_quest_hunter-1.1.8.xpi";
              sha256 = "d3f339c87d3319dcef7a755f6ab31df31bd5c2a86909b17a30e7bd02139badc9";
              meta = { };
            })
            (buildXpi {
              pname = "lumo-proton-sidebar";
              version = "1.0.12";
              addonId = "{f36bdac8-e4a5-45f5-bcf0-33127a2b36ba}";
              url = "https://addons.mozilla.org/firefox/downloads/file/4478800/lumo_by_proton_sidebar-1.0.12.xpi";
              sha256 = "b3104bd0783f2065a8ba8f3a29517f14711ea9d48b8e752de1be8c766f6db4e1";
              meta = { };
            })
          ];
        in
        {
          home.sessionVariables = {
            MOZ_ENABLE_WAYLAND = 1;
            MOZ_USE_XINPUT2 = "1";
          };
          programs.firefox = {
            enable = true;
            configPath = "${config.xdg.configHome}/mozilla/firefox";
            package = pkgs.firefox.override {
              nativeMessagingHosts = [ pkgs.tridactyl-native ];
            };
            policies = {
              ExtensionSettings = {
                "*" = {
                  private_browsing = true;
                };
              };
              DisableTelemetry = true;
              DisplayBookmarksToolbar = "always";
              NoDefaultBookmarks = true;
              OfferToSaveLogins = false;
            };
            profiles.${user.userName} = {
              isDefault = true;
              extensions.packages =
                (with pkgs.nur.repos.rycee.firefox-addons; [
                  darkreader
                  ublock-origin
                  violentmonkey
                  stylus
                  proton-pass
                  tab-reloader
                  proton-vpn
                  gesturefy
                  tridactyl
                  awesome-rss
                  kagi-search
                  user-agent-string-switcher
                ])
                ++ customAddons;
              settings = {
                "extensions.autoDisableScopes" = 0;
              };
              # Betterfox first, then personal overrides — order guarantees our prefs win
              extraConfig =
                builtins.readFile (
                  builtins.fetchurl {
                    url = "https://raw.githubusercontent.com/yokoffing/Betterfox/main/user.js";
                    sha256 = "1bgwdzr8g0fdw9p2zw34scinj5684ag13kjr7di4b48lags5ccp8";
                  }
                )
                + /* javascript */ ''
                  // Personal overrides — applied after Betterfox to take precedence
                  user_pref("browser.bookmarks.addedImportButton", false);
                  user_pref("network.dnsCacheEntries", 0);
                  user_pref("network.dnsCacheExpiration", 0);
                  user_pref("network.dnsCacheExpirationGracePeriod", 0);
                  user_pref("print.print_in_color", true);
                  user_pref("print.default-print-settings.printBGColors", true);
                  user_pref("print.default-print-settings.printBGImages", true);
                  user_pref("browser.uiCustomization.state", "{\"placements\":{\"widget-overflow-fixed-list\":[],\"unified-extensions-area\":[\"_react-devtools-browser-action\",\"_f60d7183-d8f1-4a2b-891b-f2de614ada9e_-browser-action\",\"_09acf9ff-55d4-4366-a1a9-c9b3c8877c09_-browser-action\",\"_c4b582ec-4343-438c-bda2-2f691c16c262_-browser-action\",\"_506e023c-7f2b-40a3-8066-bc5deb40aebe_-browser-action\",\"_a6c4a591-f1b2-4f03-b3ff-767e5bedf4e7_-browser-action\"],\"nav-bar\":[\"sidebar-button\",\"back-button\",\"forward-button\",\"stop-reload-button\",\"customizableui-special-spring1\",\"vertical-spacer\",\"urlbar-container\",\"jid0-bnmfwww2w2w4e4edvcddbnmhdvg_jetpack-browser-action\",\"78272b6fa58f4a1abaac99321d503a20_proton_me-browser-action\",\"ublock0_raymondhill_net-browser-action\",\"_aecec67f-0d10-4fa7-b7c7-609a2db280cf_-browser-action\",\"_7a7a4a92-a2a0-41d1-9fd7-1e92480d612d_-browser-action\",\"addon_darkreader_org-browser-action\",\"vpn_proton_ch-browser-action\",\"unified-extensions-button\",\"downloads-button\",\"fxa-toolbar-menu-button\",\"preferences-button\",\"developer-button\",\"firefox-view-button\",\"alltabs-button\",\"reset-pbm-toolbar-button\"],\"toolbar-menubar\":[\"menubar-items\"],\"TabsToolbar\":[],\"vertical-tabs\":[\"tabbrowser-tabs\"],\"PersonalToolbar\":[\"personal-bookmarks\"]},\"seen\":[\"developer-button\",\"profiler-button\",\"screenshot-button\",\"_react-devtools-browser-action\",\"_f60d7183-d8f1-4a2b-891b-f2de614ada9e_-browser-action\",\"_7a7a4a92-a2a0-41d1-9fd7-1e92480d612d_-browser-action\",\"78272b6fa58f4a1abaac99321d503a20_proton_me-browser-action\",\"_09acf9ff-55d4-4366-a1a9-c9b3c8877c09_-browser-action\",\"vpn_proton_ch-browser-action\",\"jid0-bnmfwww2w2w4e4edvcddbnmhdvg_jetpack-browser-action\",\"_aecec67f-0d10-4fa7-b7c7-609a2db280cf_-browser-action\",\"ublock0_raymondhill_net-browser-action\",\"_c4b582ec-4343-438c-bda2-2f691c16c262_-browser-action\",\"_506e023c-7f2b-40a3-8066-bc5deb40aebe_-browser-action\",\"_a6c4a591-f1b2-4f03-b3ff-767e5bedf4e7_-browser-action\",\"addon_darkreader_org-browser-action\",\"reset-pbm-toolbar-button\"],\"dirtyAreaCache\":[\"nav-bar\",\"vertical-tabs\",\"toolbar-menubar\",\"TabsToolbar\",\"PersonalToolbar\",\"unified-extensions-area\"],\"currentVersion\":23,\"newElementCount\":7}");
                  user_pref("places.frecency.bookmarkVisitBonus", 2000);
                  user_pref("places.frecency.unvisitedBookmarkBonus", 2000);
                  user_pref("browser.preferences.experimental.hidden", false);
                  user_pref("devtools.debugger.prompt-connection", false);
                  user_pref("sidebar.revamp", true);
                  user_pref("sidebar.verticalTabs", true);
                  user_pref("sidebar.visibility", "always-show");
                  user_pref("sidebar.expandOnHover", false);
                  user_pref("browser.engagement.sidebar-button.has-used", true);
                  user_pref("browser.toolbars.bookmarks.visibility", "always");
                  user_pref("services.sync.prefs.sync-seen.browser.urlbar.showSearchSuggestionsFirst", false);
                  user_pref("extensions.activeThemeID", "{f2bcd203-646c-4f72-8da5-092a671277cc}");
                  user_pref("extensions.webextensions.restrictedDomains", "");
                  user_pref("browser.tabs.groups.enabled", true);
                  user_pref("browser.tabs.groups.smart.enabled", true);
                  user_pref("browser.tabs.closeWindowWithLastTab", false);
                  user_pref("gfx.webrender.layer-compositor", true);
                  user_pref("network.dns.disableIPv6", true);
                  user_pref("media.wmf.zero-copy-nv12-textures-force-enabled", true);
                  user_pref("browser.urlbar.showSearchSuggestionsFirst", false);
                  user_pref("ui.context_menus.after_mouseup", true);
                  user_pref("privacy.resistFingerprinting.block_mozAddonManager", true);
                  user_pref("media.videocontrols.picture-in-picture.enable-when-switching-tabs.enabled", true);
                  user_pref("media.videocontrols.picture-in-picture.enabled", true);
                  user_pref("media.videocontrols.picture-in-picture.video-toggle.enabled", true);
                  user_pref("media.videocontrols.picture-in-picture.video-toggle.flyout-enabled", true);
                  user_pref("media.videocontrols.picture-in-picture.respect-disablePictureInPicture", false);
                  user_pref("browser.startup.page", 3);
                  user_pref("network.trr.mode", 5);
                  user_pref("browser.search.separatePrivateDefault", false);
                  user_pref("browser.search.separatePrivateDefault.ui.enabled", true);
                  user_pref("browser.search.suggest.enabled.private", true);
                  user_pref("browser.cache.memory.capacity", 512000);
                  user_pref("gfx.font_rendering.cleartype_params.rendering_mode", 5);
                  user_pref("gfx.font_rendering.cleartype_params.cleartype_level", 100);
                  user_pref("gfx.font_rendering.cleartype_params.force_gdi_classic_for_families", "");
                  user_pref("gfx.font_rendering.directwrite.use_gdi_table_loading", false);
                  user_pref("accessibility.force_disabled", true);
                  user_pref("browser.urlbar.trimHttps", false);
                  user_pref("permissions.default.geo", 1);
                  user_pref("browser.newtabpage.activity-stream.feeds.topsites", true);
                  user_pref("browser.newtabpage.activity-stream.default.sites", "");
                  user_pref("browser.newtabpage.activity-stream.showSponsoredTopSites", false);
                  user_pref("browser.newtabpage.activity-stream.feeds.section.topstories", false);
                  user_pref("browser.newtabpage.activity-stream.showSponsored", false);
                  user_pref("browser.newtabpage.activity-stream.showWeather", false);
                  user_pref("browser.search.suggest.enabled", true);
                  user_pref("media.ffmpeg.vaapi.enabled", true);
                  user_pref("media.rdd-ffmpeg.enabled", true);
                  user_pref("media.av1.enabled", false);
                  user_pref("gfx.x11-egl.force-enabled", true);
                  user_pref("widget.dmabuf.force-enabled", true);
                  user_pref("network.predictor.enabled", true);
                  user_pref("network.predictor.enable-prefetch", true);
                  user_pref("network.dns.disablePrefetch", false);
                  user_pref("network.dns.disablePrefetchFromHTTPS", false);
                  user_pref("network.prefetch-next", true);
                '';
              userChrome = builtins.readFile "${inputs.self}/assets/mozilla/chrome/userChrome.css";
              userContent = builtins.readFile "${inputs.self}/assets/mozilla/chrome/userContent.css";
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
                    definedAliases = [ "@hm" ];
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
                  "noogle.dev" = {
                    urls = [
                      {
                        template = "https://noogle.dev/q?term={searchTerms}";
                      }
                    ];
                    icon = "https://nixos.wiki/favicon.png";
                    updateInterval = 24 * 60 * 60 * 1000; # every day
                    definedAliases = [ "@no" ];
                  };
                  bing.metaData.hidden = true;
                  google.metaData.hidden = true;
                };
              };
            };
          };

          # Context menu tweaks
          home.file.".config/mozilla/firefox/${user.userName}/chrome/simpleMenuWizard" = {
            recursive = true;
            source = "${inputs.self}/assets/mozilla/chrome/simpleMenuWizard";
          };

          # Firefox 113+ uses ~/.config/mozilla/firefox (XDG) but still reads the
          # legacy ~/.mozilla/firefox/profiles.ini first. If that file declares a
          # default profile, Firefox ignores the HM-managed XDG profile. Back it up
          # so Firefox falls through to the correct XDG location.
          home.activation.firefoxLegacyProfiles = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
            legacy="$HOME/.mozilla/firefox/profiles.ini"
            if [ -f "$legacy" ]; then
              $DRY_RUN_CMD rm "$legacy"
            fi
          '';

        };
    };
}
