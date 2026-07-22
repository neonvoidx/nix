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
              DisableTelemetry = true;
              DisplayBookmarksToolbar = "always";
              NoDefaultBookmarks = true;
              OfferToSaveLogins = false;
            };
            profiles.${user.userName} = {
              isDefault = true;
              settings = {
                "extensions.autoDisableScopes" = 0;
              };
              # Betterfox first, then personal overrides — order guarantees our prefs win
              extraConfig =
                let
                  uiCustomization = builtins.toJSON {
                    placements = {
                      "widget-overflow-fixed-list" = [ ];
                      "unified-extensions-area" = [
                        "smallweb_kagi_com-browser-action"
                        "_506e023c-7f2b-40a3-8066-bc5deb40aebe_-browser-action"
                        "_react-devtools-browser-action"
                        "_f60d7183-d8f1-4a2b-891b-f2de614ada9e_-browser-action"
                        "_09acf9ff-55d4-4366-a1a9-c9b3c8877c09_-browser-action"
                        "_c4b582ec-4343-438c-bda2-2f691c16c262_-browser-action"
                        "search_kagi_com-browser-action"
                        "_09d1226f-0dd0-4ad7-8a0f-cca316ea271e_-browser-action"
                      ];
                      "nav-bar" = [
                        "sidebar-button"
                        "back-button"
                        "forward-button"
                        "stop-reload-button"
                        "customizableui-special-spring1"
                        "vertical-spacer"
                        "urlbar-container"
                        "jid0-bnmfwww2w2w4e4edvcddbnmhdvg_jetpack-browser-action"
                        "_57e8684d-5ae8-47d6-93c9-f870ef0e40a3_-browser-action"
                        "_a6c4a591-f1b2-4f03-b3ff-767e5bedf4e7_-browser-action"
                        "78272b6fa58f4a1abaac99321d503a20_proton_me-browser-action"
                        "_446900e4-71c2-419f-a6a7-df9c091e268b_-browser-action"
                        "ublock0_raymondhill_net-browser-action"
                        "_aecec67f-0d10-4fa7-b7c7-609a2db280cf_-browser-action"
                        "_7a7a4a92-a2a0-41d1-9fd7-1e92480d612d_-browser-action"
                        "addon_darkreader_org-browser-action"
                        "vpn_proton_ch-browser-action"
                        "unified-extensions-button"
                        "downloads-button"
                        "fxa-toolbar-menu-button"
                        "preferences-button"
                        "developer-button"
                        "firefox-view-button"
                        "alltabs-button"
                        "reset-pbm-toolbar-button"
                      ];
                      "toolbar-menubar" = [ "menubar-items" ];
                      "TabsToolbar" = [ ];
                      "vertical-tabs" = [ "tabbrowser-tabs" ];
                      "PersonalToolbar" = [ "personal-bookmarks" ];
                    };
                    seen = [
                      "developer-button"
                      "profiler-button"
                      "screenshot-button"
                      "_react-devtools-browser-action"
                      "_f60d7183-d8f1-4a2b-891b-f2de614ada9e_-browser-action"
                      "_7a7a4a92-a2a0-41d1-9fd7-1e92480d612d_-browser-action"
                      "78272b6fa58f4a1abaac99321d503a20_proton_me-browser-action"
                      "_09acf9ff-55d4-4366-a1a9-c9b3c8877c09_-browser-action"
                      "vpn_proton_ch-browser-action"
                      "jid0-bnmfwww2w2w4e4edvcddbnmhdvg_jetpack-browser-action"
                      "_aecec67f-0d10-4fa7-b7c7-609a2db280cf_-browser-action"
                      "ublock0_raymondhill_net-browser-action"
                      "_c4b582ec-4343-438c-bda2-2f691c16c262_-browser-action"
                      "_506e023c-7f2b-40a3-8066-bc5deb40aebe_-browser-action"
                      "_a6c4a591-f1b2-4f03-b3ff-767e5bedf4e7_-browser-action"
                      "addon_darkreader_org-browser-action"
                      "reset-pbm-toolbar-button"
                      "search_kagi_com-browser-action"
                      "smallweb_kagi_com-browser-action"
                      "_09d1226f-0dd0-4ad7-8a0f-cca316ea271e_-browser-action"
                      "_57e8684d-5ae8-47d6-93c9-f870ef0e40a3_-browser-action"
                      "_446900e4-71c2-419f-a6a7-df9c091e268b_-browser-action"
                    ];
                    dirtyAreaCache = [
                      "nav-bar"
                      "vertical-tabs"
                      "toolbar-menubar"
                      "TabsToolbar"
                      "PersonalToolbar"
                      "unified-extensions-area"
                    ];
                    currentVersion = 24;
                    newElementCount = 9;
                  };
                in
                builtins.readFile (
                  builtins.fetchurl {
                    url = "https://raw.githubusercontent.com/yokoffing/Betterfox/main/user.js";
                    sha256 = "sha256:11q7yl8l10zybf43fvkvlaiqibviank7s47yqrsbfa881nz47sf9";
                  }
                )
                + /* javascript */ ''
                  // Personal overrides — applied after Betterfox to take precedence
                  user_pref("browser.ai.control.default", "available");
                  user_pref("browser.ai.control.smartTabGroups", "enabled");
                  // TODO https://bugzilla.mozilla.org/show_bug.cgi?id=1642854 once this is merged
                  // user_pref("gfx.wayland.hdr", true);
                  // user_pref("gfx.wayland.hdr.force-enabled", true);
                  // user_pref("gfx.webrender.compositor", true);
                  // user_pref("gfx.webrender.compositor.force-enabled", true);
                  user_pref("browser.bookmarks.addedImportButton", false);
                  // NOTE: To disable dns cache
                  // user_pref("network.dnsCacheEntries", 0);
                  // user_pref("network.dnsCacheExpiration", 0);
                  // user_pref("network.dnsCacheExpirationGracePeriod", 0);
                  // Nova UI
                  user_pref("widget.non-native-theme.scrollbar.style", 4);
                  // user_pref("browser.nova.enabled", true);
                  // user_pref("browser.newtabpage.activity-stream.nova.enabled", true);
                  // user_pref("browser.urlbar.nova.featureGate", true);
                  // user_pref("browser.settings-redesign.enabled", true);
                  // user_pref("browser.smartwindow.nova.enabled", true);
                  // user_pref("browser.urlbar.quicksuggest.ampTopPickUseNovaIconSize", true);
                  user_pref("print.print_in_color", true);
                  user_pref("print.default-print-settings.printBGColors", true);
                  user_pref("print.default-print-settings.printBGImages", true);
                  user_pref("browser.uiCustomization.state", "${
                    builtins.replaceStrings [ "\"" ] [ "\\\"" ] uiCustomization
                  }");
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
                  user_pref("extensions.quarantinedDomains.enabled", false);
                  user_pref("browser.tabs.groups.enabled", true);
                  user_pref("browser.tabs.groups.smart.enabled", true);
                  user_pref("browser.tabs.closeWindowWithLastTab", false);
                  user_pref("gfx.webrender.layer-compositor", true);
                  user_pref("network.dns.disableIPv6", true);
                  user_pref("media.wmf.zero-copy-nv12-textures-force-enabled", true);
                  user_pref("browser.urlbar.showSearchSuggestionsFirst", false);
                  user_pref("ui.context_menus.after_mouseup", true);
                  user_pref("privacy.resistFingerprinting.block_mozAddonManager", false);
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
                            name = "channel";
                            value = "unstable";
                          }
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
                  "youtube" = {
                    urls = [
                      {
                        template = "https://youtube.com/results?search_query={searchTerms}";
                      }
                    ];
                    icon = "https://www.youtube.com/s/desktop/b232f2cf/img/favicon_144x144.png";
                    updateInterval = 24 * 60 * 60 * 1000; # every day
                    definedAliases = [ "@y" ];
                  };
                  "devenv" = {
                    urls = [
                      {
                        template = "https://devenv.new";
                        params = [
                          {
                            name = "q";
                            value = "{searchTerms}";
                          }
                        ];
                      }
                    ];
                    icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                    definedAliases = [ "@d" ];
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
