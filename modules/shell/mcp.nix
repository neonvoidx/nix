{ den, ... }:
{
  den.aspects.mcp = {
    nixos = {
      environment.extraInit = ''
        if [ -f /run/secrets/github-pat ]; then
          export GITHUB_TOKEN="$(cat /run/secrets/github-pat)"
        fi
      '';
    };

    homeManager =
      { pkgs, ... }:
      {
        home.packages = [ pkgs.github-mcp-server ];

        programs.mcp = {
          enable = true;
          servers = {
            mcp-nixos = {
              command = "nix";
              args = [
                "run"
                "github:utensils/mcp-nixos"
                "--"
              ];
            };
            nix-agent = {
              command = "nix";
              args = [
                "run"
                "github:JEFF7712/nix-agent"
              ];
            };
            github = {
              command = "github-mcp-server";
              args = [ "stdio" ];
            };
          };
        };
      };
  };
}
