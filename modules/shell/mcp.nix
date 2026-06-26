{ den, ... }:
{
  den.aspects.mcp = {
    homeManager =
      { pkgs, ... }:
      {
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
          };
        };
      };
  };
}
