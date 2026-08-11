{ den, inputs, ... }:
{
  den.aspects.overlays.nixos =
    { ... }:
    {
      nixpkgs = {
        overlays = [
          (final: prev: {
            neonmono = prev.stdenv.mkDerivation {
              pname = "NeonMono";
              version = "0.1.3";

              src = ../../assets/fonts/neonmono;

              dontBuild = true;

              installPhase = ''
                mkdir -p $out/share/fonts/truetype
                cp -v $src/*.ttf $out/share/fonts/truetype/
              '';

              meta = {
                description = "Custom Iosevka font build — NeonMono";
                homepage = "https://github.com/neonvoidx/NeonMono";
                license = final.lib.licenses.ofl;
                platforms = final.lib.platforms.all;
              };
            };
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
