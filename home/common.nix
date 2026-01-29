{
  username,
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./configs
    ./packages.nix
    inputs.spicetify-nix.homeManagerModules.default
    inputs.nix-index-database.homeModules.default
  ];

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
}
