{ den, inputs, ... }:
{
  den.aspects.deadlock =
    { host, ... }:
    {
      nixos = {
        nixpkgs = {
          overlays = [
            # Use deadlock-mod-manager from Mistyttm's nixpkgs branch (update-dmmm)
            # without switching the whole system nixpkgs.
            (final: prev: let
              mistySrc = prev.fetchFromGitHub {
                owner = "Mistyttm";
                repo = "nixpkgs";
                rev = "214f28103d81257dccb7fc14f59c6e0fb96c9ce8";
                hash = "sha256-s4Sg7uCh7trGCafKI45fIWsFvKjIyQBJ79BvYe3Qen8=";
              };
              mistyPkgs = import mistySrc {
                system = final.system;
                config = prev.config;
                overlays = [ ];
              };
            in {
              deadlock-mod-manager = mistyPkgs.deadlock-mod-manager.overrideAttrs (_: {
                patches = [ ];
                # Avoid tauri signing errors during bundling.
                env.TAURI_SIGNING_PRIVATE_KEY = "";
                env.TAURI_SIGNING_PRIVATE_KEY_PASSWORD = "";
                env.TAURI_UPDATER_PRIVATE_KEY = "";
                env.TAURI_UPDATER_PRIVATE_KEY_PASSWORD = "";

                # Ensure nix builds don't try to sign updater artifacts.
                # (Upstream may have updater enabled and a key present in-tree.)
                preBuild = ''
                  export TAURI_SIGNING_PRIVATE_KEY=""
                  export TAURI_SIGNING_PRIVATE_KEY_PASSWORD=""
                  export TAURI_UPDATER_PRIVATE_KEY=""
                  export TAURI_UPDATER_PRIVATE_KEY_PASSWORD=""

                  # Hard-disable updater during bundling: upstream `tauri.conf.json`
                  # includes updater + ota-updater pubkeys and tauri will attempt
                  # to sign artifacts if updater is enabled.
                  if [ -f apps/desktop/src-tauri/tauri.conf.json ]; then
                    ${prev.jq}/bin/jq '
                      .bundle.createUpdaterArtifacts = false
                    ' apps/desktop/src-tauri/tauri.conf.json > apps/desktop/src-tauri/tauri.conf.json.tmp
                    mv apps/desktop/src-tauri/tauri.conf.json.tmp apps/desktop/src-tauri/tauri.conf.json
                  fi
                '';
              });
            })
          ];
        };
      };
      homeManager =
        { pkgs, ... }:
        {
          home.packages = with pkgs; [
            deadlock-mod-manager
          ];
        };
    };
}
