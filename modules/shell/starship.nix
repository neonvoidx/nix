{ den, ... }:
{
  den.aspects.starship = {
    homeManager = {
      programs.starship = {
        enable = true;
        enableFishIntegration = true;
        enableInteractive = true;
        settings = {
          format = "$username$hostname$directory$vcsh$git_branch$git_commit$git_state$git_metrics$git_status$hg_branch$hg_state$all$line_break$character\n";
          character = {
            success_symbol = "[❯](green)";
            error_symbol = "[✖](red)";
            vimcmd_symbol = "[](green)";
          };
        };
      };
    };
  };
}
