{ den, inputs, ... }:
{
  den.aspects.overlays.nixos =
    { ... }:
    {
      nixpkgs = {
        overlays = [
          inputs.hyprpicker.overlays.hyprpicker-with-deps
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
          (final: prev:
          let
            xembsni-src = final.fetchFromGitHub {
              owner = "jmylchreest";
              repo = "xembsni";
              rev = "7de94a2afdc8bed78afd448b4dbe49076de3b98a";
              hash = "sha256-vtm9dzj9b7YMEntu76nqLNGlDMhVicWmQ5IjsmTFtRE=";
            };
          in
          {
            xembsni = final.rustPlatform.buildRustPackage {
              pname = "xembsni";
              version = "0.0.1";

              src = xembsni-src;

              cargoLock.lockFile = xembsni-src + "/Cargo.lock";

              nativeBuildInputs = with final; [
                pkg-config
              ];

              buildInputs = with final; [
                libxcb
                xcbutil
                xcbutilimage
                xcbutilkeysyms
              ];

              meta = with final.lib; {
                description = "XEmbed to StatusNotifierItem tray bridge for Wayland";
                homepage = "https://github.com/jmylchreest/xembsni";
                license = licenses.mit;
                platforms = platforms.linux;
                mainProgram = "xembsni";
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
