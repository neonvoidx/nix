{ den, inputs, ... }:
{
  den.aspects.overlays.nixos =
    {
      config,
      lib,
      ...
    }:
    let
      multiverseConfig = config.multiverse or { };
      multiversePins = multiverseConfig.pins or { };
      hasMultiversePins = builtins.length (builtins.attrNames multiversePins) > 0;
    in
    {
      nixpkgs = {
        overlays =
          lib.optional hasMultiversePins (
            inputs.multiverse.lib.pinOverlay {
              pins = multiversePins;
              config = multiverseConfig.config or { allowUnfree = true; };
            }
          )
          ++ [
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
            (
              final: prev:
              let
                master-src = final.fetchFromGitHub {
                  owner = "Supreeeme";
                  repo = "xwayland-satellite";
                  rev = "add2795134593faafce60e404a0a75df68e9ee0c";
                  hash = "0hs11f774p7pqb4w7kpgsfp9h8hc75ky6gc31x5z1lwn18r5yg6i";
                };
              in
              {
                xwayland-satellite-master = final.rustPlatform.buildRustPackage {
                  pname = "xwayland-satellite";
                  version = "master";

                  src = master-src;

                  cargoLock.lockFile = master-src + "/Cargo.lock";

                  nativeBuildInputs = with final; [
                    installShellFiles
                    makeBinaryWrapper
                    pkg-config
                    rustPlatform.bindgenHook
                  ];

                  buildInputs = with final; [
                    libxcb
                    libxcb-cursor
                  ];

                  buildNoDefaultFeatures = true;
                  buildFeatures = lib.optional final.withSystemd "systemd";

                  outputs = [
                    "out"
                    "man"
                  ];

                  doCheck = false;

                  postInstall = ''
                    installManPage --name xwayland-satellite.1 xwayland-satellite.man
                  ''
                  + lib.optionalString final.withSystemd ''
                    install -Dm0644 resources/xwayland-satellite.service -t $out/lib/systemd/user
                  '';

                  postFixup = ''
                    wrapProgram $out/bin/xwayland-satellite --prefix PATH : "${lib.makeBinPath [ final.xwayland ]}"
                  '';

                  passthru.updateScript = final.nix-update-script;

                  meta = with final.lib; {
                    description = "Xwayland outside your Wayland compositor";
                    longDescription = ''
                      Grants rootless Xwayland integration to any Wayland compositor
                      implementing xdg_wm_base.
                    '';
                    homepage = "https://github.com/Supreeeme/xwayland-satellite";
                    changelog = "https://github.com/Supreeeme/xwayland-satellite/commits/master";
                    license = licenses.mpl20;
                    maintainers = with maintainers; [
                      if-loop69420
                      sodiboo
                      getchoo
                    ];
                    mainProgram = "xwayland-satellite";
                    platforms = platforms.linux;
                  };
                };
              }
            )
            (
              final: prev:
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
              }
            )
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
