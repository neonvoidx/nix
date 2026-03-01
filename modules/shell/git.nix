{ ... }:
{
  flake.modules.homeManager.git =
    { config, ... }:
    let
      c = config.lib.stylix.colors;
    in
    {
      programs.git = {
        enable = true;
        settings = {
          user = {
            name = "neonvoidx";
            email = "me@neonvoid.dev";
          };
          core = {
            editor = "nvim";
          };
          init = {
            defaultBranch = "master";
          };

          delta = {
            navigate = true;
            side-by-side = true;
          };

          pull = {
            rebase = true;
          };

          push = {
            autoSetupRemote = true;
          };

          http = {
            postBuffer = 157286400;
          };

          alias = {
            lg = "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)' --all";
            squash = ''!f(){ git reset $(git commit-tree "HEAD^{tree}" "$@");};f'';
          };

          rerere = {
            enabled = true;
          };

          column = {
            ui = "auto";
          };

          branch = {
            sort = "-committerdate";
          };
        };
      };
      programs.delta = {
        enable = true;
        enableGitIntegration = true;
        options = {
          syntax-theme = "base16";
          line-numbers = true;
          side-by-side = true;
          navigate = true;
          plus-style = "syntax \"#${c.base0B}\"";
          minus-style = "syntax \"#${c.base08}\"";
          plus-emph-style = "syntax \"#${c.base0B}\"";
          minus-emph-style = "syntax \"#${c.base08}\"";
          line-numbers-plus-style = "#${c.base0B}";
          line-numbers-minus-style = "#${c.base08}";
          line-numbers-zero-style = "#${c.base03}";
        };
      };
      programs.gh = {
        enable = true;
        gitCredentialHelper.enable = true;
        settings = {
          git_protocol = "ssh";
        };
      };
    };
}
