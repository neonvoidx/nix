{ den, ... }:
{
  den.aspects.opencode.homeManager =
    { ... }:
    {
      programs = {
        opencode = {
          enable = true;
          enableMcpIntegration = true;

          commands = ../../assets/ai/commands;
          skills = ../../assets/ai/skills;

          settings = {
            default_agent = "build";
            model = "oca/oca/gpt-5.4";
            small_model = "oca/oca/gpt-5.4-nano";
            enabled_providers = [ "oca" ];

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

            tools.websearch = true;
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
      };
    };
}
