{ den, inputs, ... }:
{
  den.aspects.overlays.nixos =
    { ... }:
    {
      nixpkgs = {
        overlays = [
          (final: prev: {
            # Temporary: test spicetify-cli wrapper fix from neonvoidx/nixpkgs
            spicetify-cli = final.callPackage (
              final.fetchFromGitHub {
                owner = "neonvoidx";
                repo = "nixpkgs";
                rev = "spicetify-cli-fix";
                hash = "sha256-5WoV3bNEmmbCKBSwCgH9n5x8IKwq9D5mPswzbKNtUy0=";
                name = "source";
              } + "/pkgs/by-name/sp/spicetify-cli/package.nix"
            ) { };
          })
          (final: prev: {
            eldritch-icon-theme = prev.stdenv.mkDerivation {
              pname = "eldritch-icon-theme";
              version = "20260529";

              src = final.fetchurl {
                url = "https://github.com/eldritch-theme/icon-theme/releases/download/20260529/Eldritch-Suru-Cthulhu.tar.xz";
                hash = "sha256-HilMQCo3vaZxz1LcCyV5/9SNZ536CkQ9c2c9b14mIbA=";
              };

              dontBuild = true;

              installPhase = ''
                mkdir -p $out/share/icons
                tar -xJf $src -C $out/share/icons
              '';

              meta = {
                description = "Eldritch Suru Cthulhu icon theme";
                homepage = "https://github.com/eldritch-theme/icon-theme";
                license = final.lib.licenses.mit;
                platforms = final.lib.platforms.all;
              };
            };
          })
        ];
      };
    };
}
