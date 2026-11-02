{ den, inputs, ... }:
{
  den.aspects.mcp = {
    homeManager =
      { pkgs, config, ... }:
      let
        # Upstream's pytest suite includes a distribution test that reads
        # .github/workflows/ci.yml, which GitHub source tarballs omit, so the
        # package cannot build unmodified from the flake input.
        nix-agent = inputs.nix-agent.packages.${pkgs.stdenv.hostPlatform.system}.default.overrideAttrs {
          disabledTests = [ "test_ci_workflow_runs_pytest" ];
        };
      in
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
              command = "${nix-agent}/bin/nix-agent";
              env.NIX_AGENT_FLAKE = config.dotfiles.checkoutPath;
            };
          };
        };
      };
  };
}
