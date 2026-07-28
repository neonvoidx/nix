{ den, ... }:
{
  den.aspects.opencode.homeManager =
    { ... }:
    {
      programs = {
        # NOTE: Input/Output token costs
        # https://opencode.ai/docs/zen#pricing
        opencode = {
          enable = true;
          enableMcpIntegration = true;

          commands = ../../assets/ai/commands;
          skills = ../../assets/ai/skills;

          settings = {
            default_agent = "build";

            permission = {
              external_directory = "ask";
              bash = {
                "git commit*" = "ask";
                "git pull*" = "ask";
                "git merge*" = "ask";
                "git push*" = "ask";
                "git reset*" = "ask";
                "git clean*" = "ask";
                "git branch -D*" = "ask";
                "git checkout --*" = "ask";
                "git restore*" = "ask";
                "git rebase*" = "ask";
                "git commit --amend*" = "ask";
              };
            };

            model = "opencode/big-pickle";
            enabled_providers = [ "opencode" ];
            tools.websearch = true;
            small_model = "opencode/big-pickle";
            share = "disabled";
          };
          tui = {
            scroll_speed = 3;
            scroll_acceleration = {
              enabled = true;
            };
            diff_style = "auto";
          };
        };
        zsh.initContent = "alias oc=opencode";
      };
    };
}
