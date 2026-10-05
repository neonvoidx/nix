{ den, ... }:
{
  den.aspects.xembsni.homeManager =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.xembsni ];

      systemd.user.services.xembsni = {
        Unit = {
          Description = "XEmbed to StatusNotifierItem tray bridge";
          PartOf = [ "umbriel-session.target" ];
          After = [ "umbriel-session.target" ];
        };
        Service = {
          Type = "simple";
          ExecStart = "${pkgs.xembsni}/bin/xembsni";
          Restart = "on-failure";
          RestartSec = 2;
          Environment = "RUST_LOG=info";
        };
        Install.WantedBy = [ "umbriel-session.target" ];
      };
    };
}
