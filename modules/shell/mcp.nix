{ den, ... }:
{
  den.aspects.mcp.homeManager =
    { ... }:
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
}
