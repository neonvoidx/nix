{ pkgs, self, ... }: {
  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = 1;
    MOZ_USE_XINPUT2 = "1";
  };
  programs.firefox = {
    enable = true;
    package = pkgs.firefox-devedition.override {
      nativeMessagingHosts = [ pkgs.tridactyl-native ];
    };
    profiles.dev-edition-default = {
      isDefault = true;
        settings ={force=true; extensions.autoDisableScopes=0;};
      extensions = {
        packages = with pkgs.nur.repos.rycee.firefox-addons; [
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
      };
      extraConfig = builtins.readFile "${self}/assets/.mozilla/user.js";
      userChrome =
        builtins.readFile "${self}/assets/.mozilla/chrome/userChrome.css";
      userContent =
        builtins.readFile "${self}/assets/.mozilla/chrome/userContent.css";
      search = {
        force = true;
        default = "kagi";
        privateDefault = "kagi";
        order = [ "kagi" "ddg" ];
        engines = {
          kagi = {
            name = "Kagi";
            urls = [{ template = "https://kagi.com/search?q={searchTerms}"; }];
            icon = "https://kagi.com/favicon.ico";
          };
          "ProtonDB" = {
            urls = [{
              template = "https://www.protondb.com/search";
              params = [{
                name = "q";
                value = "{searchTerms}";
              }];
            }];
            definedAliases = [ "@p" ];
          };
          "Nix Packages" = {
            urls = [{
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
            }];
            icon =
              "''${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "@np" ];
          };
          "NixOS Wiki" = {
            urls = [{
              template = "https://nixos.wiki/index.php?search={searchTerms}";
            }];
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
}
