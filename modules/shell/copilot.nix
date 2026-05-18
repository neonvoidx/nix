{ den, ... }:
{
  den.aspects.copilot.homeManager =
    { ... }:
    {
      programs.github-copilot-cli = {
        enable = true;
        enableMcpIntegration = true;
        skills = ../../assets/ai/skills;
        mcpServers = {
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
          godot = {
            command = "npx";
            args = [ "@coding-solo/godot-mcp" ];
          };
        };
        settings = {
          allowedUrls = [ "*.github.com" ];
          beep = false;
          footer = {
            showModelEffort = true;
            showDirectory = true;
            showBranch = true;
            showContextWindow = true;
            showQuota = true;
            showAgent = true;
          };
          includeCoAutheredBy = false;
          renderMarkdown = true;
          storeTokenPlaintext = false;
          trusted_folders = [
            "~/nix"
            "~/dev"
          ];
          updateTerminalTitle = false;
        };
      };
    };
}
