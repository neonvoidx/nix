{ den, inputs, ... }:
{
  den.aspects.youtubemusic.homeManager =
    { pkgs, config, ... }:
    {
      programs.pear-desktop = {
        enable = true;
        options = {
          appVisible = true;
          customWindowTitle = "Pear";
          hideMenu = true;
          language = "en";
          likeButtons = "force";
          restartOnConfigChanges = true;
          startingPage = "Home";
          themes = [
            "${config.home.homeDirectory}/.config/ytm/themes/cthulhu.css"
          ];
          # Setting tray = true makes the tray work, but hides the window at startup.
          tray = false;
        };
        plugins = {
          album-actions.enable = true;
          album-color-theme = {
            enable = true;
            enableSeekbar = true;
          };
          ambient-mode = {
            enable = true;
            blur = 100;
          };
          blur-nav-bar.enable = true;
          disable-autoplay = {
            enable = true;
            applyOnce = true;
          };
          discord = {
            enable = true;
            hideGitHubButton = true;
          };
          downloader = {
            enable = true;
          };
          in-app-menu.enable = true;
          performance-improvement.enable = true;
          playback-speed.enable = true;
          precise-volume.enable = true;
          quality-changer.enable = true;
          shortcuts.enable = true;
          synced-lyrics = {
            enable = true;
          };
          transparent-player = {
            enable = true;
            opacity = 0.5;
          };
          tuna-obs.enable = true;
          video-toggle = {
            enable = true;
          };
        };
      };

      home.file.".config/ytm/themes/cthulhu.css" = {
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix/assets/ytm/cthulhu.css";
      };
    };
}
