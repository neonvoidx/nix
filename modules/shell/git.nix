{ den, ... }:
{
  den.aspects.git =
    { user, ... }:
    {
      homeManager =
        { config, ... }:
        {
          programs.git = {
            enable = true;
            settings = {
              user = {
                name = user.gitName;
                email = user.gitEmail;
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

          home.sessionVariables = {
            GITHUB_PERSONAL_ACCESS_TOKEN = "$(cat /run/secrets/github-pat)";
          };

          programs.gh = {
            enable = true;
            gitCredentialHelper.enable = true;
            settings = {
              git_protocol = "ssh";
            };
          };
        };
    };
}
