{ den, inputs, ... }:
{
  den.aspects.wow.homeManager =
    { pkgs, ... }:
    let
      archon-lite = pkgs.fetchurl {
        url = "https://github.com/RPGLogs/Uploaders-archon-lite/releases/download/v9.5.0/archon-lite-v9.5.0.AppImage";
        hash = "sha256-ZuALgVtqsYtvnSq8hkJL4A+i4UaEpk+2L3bpSEXrhRM=";
      };
    in
    {
      imports = [ inputs.curseforge.homeManagerModules.default ];

      programs.curseforge.enable = true;

      home.packages = [
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
          PartOf = [
            "hyprland-session.target"
            "umbriel-session.target"
          ];
          After = [
            "hyprland-session.target"
            "umbriel-session.target"
          ];
        };
        Service = {
          Type = "simple";
          ExecStart = "${pkgs.xembsni}/bin/xembsni";
          Restart = "on-failure";
          RestartSec = 2;
          Environment = "RUST_LOG=info";
        };
        Install = {
          WantedBy = [
            "hyprland-session.target"
            "umbriel-session.target"
          ];
        };
      };
    };
}
