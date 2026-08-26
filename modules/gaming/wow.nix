{ den, ... }:
{
  den.aspects.wow.homeManager =
    { pkgs, ... }:
    let
      curseforge = pkgs.fetchurl {
        url = "https://curseforge.overwolf.com/downloads/curseforge-latest-linux.AppImage";
        hash = "sha256-ocLq6EaM2E/yvH9zH2ESXZ8eLiquRHxStT/CDhJ2OdQ=";
      };
      archon = pkgs.fetchurl {
        url = "https://github.com/RPGLogs/Uploaders-archon/releases/download/v9.6.0/archon-v9.6.0.AppImage";
        hash = "sha256-69xo+1jMo91KQ6yoMOBTXLUzFRNGUJqH7G5ZeEiiX4I=";
      };
    in
    {
      home.packages = [
        (pkgs.appimageTools.wrapType2 {
          pname = "CurseForge";
          name = "curseforge";
          version = "1.314.0";
          src = curseforge;
          extraInstallCommands =
            let
              contents = pkgs.appimageTools.extract {
                pname = "CurseForge";
                version = "1.314.0";
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
        (pkgs.appimageTools.wrapType2 {
          pname = "archon";
          name = "archon";
          version = "9.6.0";
          src = archon;
          extraInstallCommands =
            let
              contents = pkgs.appimageTools.extract {
                pname = "archon";
                version = "9.6.0";
                src = archon;
              };
            in
            ''
              install -m 444 -D ${contents}/archon.desktop $out/share/applications/archon.desktop
              substituteInPlace $out/share/applications/archon.desktop \
                  --replace-fail 'Exec=AppRun' 'Exec=archon'
              install -m 444 -D ${contents}/archon.png $out/share/icons/hicolor/256x256/apps/archon.png
            '';
        })
        pkgs.xembsni
      ];

      xdg.mimeApps = {
        enable = true;
        defaultApplications = {
          "x-scheme-handler/curseforge" = "curseforge.desktop";
        };
      };

      systemd.user.services.xembsni = {
        Unit = {
          Description = "XEmbed to StatusNotifierItem tray bridge";
          PartOf = "graphical-session.target";
          After = "graphical-session.target";
        };
        Service = {
          Type = "simple";
          ExecStart = "${pkgs.xembsni}/bin/xembsni";
          Restart = "on-failure";
          RestartSec = 2;
          Environment = "RUST_LOG=info";
        };
        Install = {
          WantedBy = [ "graphical-session.target" ];
        };
      };
    };
}
