{ den, lib, ... }:
{
  den.aspects.opencode.homeManager = {
    programs = {
      # NOTE: Input/Output token costs
      # https://opencode.ai/docs/zen#pricing
      opencode = {
        enable = true;

        # The pinned stylix target still writes programs.opencode.tui.theme,
        # which OpenCode 2 ignores and Home Manager warns about. Clear the whole
        # attrset at higher precedence while keeping stylix's generated theme.
        tui = lib.mkOverride 50 { };

        enableMcpIntegration = true;

        commands = ../../assets/ai/commands;

        settings = {
          default_agent = "build";
          mcp = {
            timeout = {
              startup = 45000;
            };
          };

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

        cli = {
          theme = {
            name = "stylix";
          };
          scroll = {
            speed = 3;
            acceleration = true;
          };
          diffs = {
            view = "auto";
            wrap = "word";
          };
          session = {
            sidebar = "auto";
            scrollbar = false;
            thinking = "hide";
          };
          animations = true;
        };
      };

      zsh.initContent = "alias oc=opencode";
    };
  };
}
