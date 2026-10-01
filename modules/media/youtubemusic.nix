{ den, inputs, ... }:
{
  den.aspects.youtubemusic.homeManager =
    { pkgs, config, lib, ... }:
    {
      programs.pear-desktop = {
        enable = true;
        options = {
          customWindowTitle = "Pear";
          hideMenu = true;
          language = "en";
          likeButtons = "force";
          restartOnConfigChanges = true;
          startingPage = "Home";
          themes = [
            "${config.home.homeDirectory}/.config/ytm/themes/cthulhu.css"
          ];
          tray = true;
          trayClickPlayPause = true;
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
            opacity = 0.3;
          };
          tuna-obs.enable = true;
          video-toggle = {
            enable = true;
          };
        };
      };

      home.file.".config/ytm/themes/cthulhu.css" = {
        source = lib.file.mkOutOfStoreSymlink
          "${config.home.homeDirectory}/nix/assets/ytm/cthulhu.css";
      };
    };
}
