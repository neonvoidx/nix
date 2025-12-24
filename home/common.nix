{ username, inputs, ... }:
{
  imports = [
    ./configs/common
    ./packages.nix
    inputs.spicetify-nix.homeManagerModules.default
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
    };
    shell.enableZshIntegration = true;
  };

  programs.home-manager.enable = true;
}
