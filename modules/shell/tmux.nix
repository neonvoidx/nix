{ den, ... }:
{
  den.aspects.tmux.homeManager =
    { pkgs, ... }:
    {
      programs.tmux = {
        enable = true;
        prefix = "C-Space";
        keyMode = "vi";
        customPaneNavigationAndResize = true;
        mouse = true;
        baseIndex = 1;
        newSession = true;
        escapeTime = 0;
        terminal = "tmux-256color";
        shell = "${pkgs.zsh}/bin/zsh";
        historyLimit = 10000;
      };
    };
}