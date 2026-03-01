{ ... }:
{
  flake.modules.homeManager.common =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      username = "neonvoid";
    in
    {
      # External modules are now imported via sharedModules in lib.nix

      home = {
        inherit username;
        homeDirectory = "/home/${username}";
        stateVersion = "25.11";
        sessionVariables = {
          EDITOR = "nvim";
          VISUAL = "nvim";
          BROWSER = "firefox";
          TERMINAL = "kitty";
          SSH_ASKPASS_REQUIRE = "prefer";
        };
      };

      programs.ssh = {
        enable = true;
        enableDefaultConfig = false;
        matchBlocks."*".addKeysToAgent = "yes";
      };

      services = {
        ssh-agent.enable = true;
        udiskie.enable = true;
        playerctld.enable = true;
        xembed-sni-proxy.enable = true;
      };

      programs.bash.enable = true;
      programs.home-manager.enable = true;
    };
}
