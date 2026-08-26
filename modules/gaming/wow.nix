{ den, ... }:
{
  den.aspects.wow.homeManager =
    { pkgs, ... }:
    let
      curseforge = pkgs.fetchurl {
        url = "https://curseforge.overwolf.com/downloads/curseforge-latest-linux.AppImage";
        hash = "sha256-ocLq6EaM2E/yvH9zH2ESXZ8eLiquRHxStT/CDhJ2OdQ=";
      };
      archon-lite = pkgs.fetchurl {
        url = "https://github.com/RPGLogs/Uploaders-archon-lite/releases/download/v9.5.0/archon-lite-v9.5.0.AppImage";
        hash = "sha256-ZuALgVtqsYtvnSq8hkJL4A+i4UaEpk+2L3bpSEXrhRM=";
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
          pname = "archon-lite";
          name = "archon-lite";
          version = "9.5.0";
          src = archon-lite;
          extraInstallCommands =
            let
              contents = pkgs.appimageTools.extract {
                pname = "archon-lite";
                version = "9.5.0";
                src = archon-lite;
              };
            in
            ''
              install -m 444 -D ${contents}/archon-lite.desktop $out/share/applications/archon-lite.desktop
              substituteInPlace $out/share/applications/archon-lite.desktop \
                  --replace-fail 'Exec=AppRun' 'Exec=archon-lite'
              install -m 444 -D ${contents}/archon-lite.png $out/share/icons/hicolor/256x256/apps/archon-lite.png
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
