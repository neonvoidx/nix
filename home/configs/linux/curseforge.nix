{ pkgs, ... }:
# not using atm
let
  curseforge = pkgs.fetchurl {
    url = "https://curseforge.overwolf.com/downloads/curseforge-latest-linux.AppImage";
    hash = "sha256-IqdGtblWD4wnqWp2kGJT3O40Xz3ORZpyKCFikIjb2S4=";
  };
in
{
  home.packages = [
    (pkgs.appimageTools.wrapType2 {
      pname = "CurseForge";
      name = "curseforge";
      version = "1.296";
      src = curseforge;
      extraInstallCommands =
        let
          contents = pkgs.appimageTools.extract {
            pname = "CurseForge";
            version = "1.296";
            src = curseforge;
          };
        in
        ''
          install -m 444 -D ${contents}/curseforge.desktop $out/share/applications/curseforge.desktop
          substituteInPlace $out/share/applications/curseforge.desktop \
              --replace-fail 'Exec=AppRun' 'Exec=CurseForge'
          cp -r ${contents}/usr/share/icons $out/share/icons
        '';
    })
  ];
}
