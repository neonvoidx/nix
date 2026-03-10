{ den, ... }:
{
  den.aspects.cline.homeManager =
    { pkgs, ... }:
    let
      cline =
        let
          pname = "cline";
          version = "2.6.1";

          src = pkgs.fetchurl {
            url = "https://registry.npmjs.org/cline/-/cline-${version}.tgz";
            hash = "sha512-9k9YxeRklvQQh90FcVXtJRetuL8rODv7lC/YyMgblHID1EGchZql7X4uegf+qjcvP8ntMoiXuAAwWhH2wvIJWA==";
          };

          # Replace @vscode/ripgrep with a shim that points at nixpkgs ripgrep
          vsCodeRipgrep = pkgs.runCommand "vscode-ripgrep-shim" { } ''
            mkdir -p $out/bin $out/lib
            echo '{"name":"@vscode/ripgrep","version":"1.17.0","main":"lib/index.js"}' \
              > $out/package.json
            echo "module.exports.rgPath = '${pkgs.ripgrep}/bin/rg';" \
              > $out/lib/index.js
            ln -s ${pkgs.ripgrep}/bin/rg $out/bin/rg
          '';
        in
        pkgs.buildNpmPackage {
          inherit pname version src;

          npmDeps = pkgs.importNpmLock {
            npmRoot = ./_data/cline;
            packageSourceOverrides = {
              "node_modules/@vscode/ripgrep" = vsCodeRipgrep;
            };
          };

          inherit (pkgs.importNpmLock) npmConfigHook;

          dontNpmBuild = true;

          nativeBuildInputs = [ pkgs.makeWrapper ];

          installPhase = ''
            mkdir -p $out/bin $out/lib
            cp -r dist $out/lib/
            cp -r node_modules $out/lib/
            makeWrapper ${pkgs.nodejs}/bin/node $out/bin/cline \
              --add-flags "$out/lib/dist/cli.mjs" \
              --set NODE_PATH "$out/lib/node_modules"
          '';

          meta = {
            description = "Autonomous coding agent CLI";
            homepage = "https://cline.bot";
            license = pkgs.lib.licenses.asl20;
            mainProgram = "cline";
          };
        };
    in
    {
      home.packages = [ cline ];
    };
}
