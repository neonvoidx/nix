{ pkgs, ... }: {
  programs.firefox = {
    enable = true;
    package = pkgs.firefox-devedition;
    profiles.neonvoid = {
      extraConfig = builtins.readFile ./.mozilla/user.js;
      userChrome = builtins.readFile ./.mozilla/chrome/userChrome.css;
      userContent = builtins.readFile ./.mozilla/chrome/userContent.css;
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
        };
      };
    };
  };
}
