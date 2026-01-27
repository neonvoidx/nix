{ config, ... }:
{
  flake.modules.homeManager.common-base = {
    username,
    inputs,
    config,
    pkgs,
    lib,
    ...
  }: {
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
      shell.enableZshIntegration = true;
    };

    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      matchBlocks."*".addKeysToAgent = "yes";
    };
    services.ssh-agent.enable = true;

    programs.home-manager.enable = true;
  };
}
