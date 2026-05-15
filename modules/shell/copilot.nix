{ den, ... }:
{
  den.aspects.copilot.homeManager =
    { ... }:
    {
      programs.github-copilot-cli = {
        enable = true;
        enableMcpIntegration = true;
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
