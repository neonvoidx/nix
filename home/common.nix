{
  username,
  inputs,
  config,
  ...
}:
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
      GTK_THEME = "adw-gtk3-dark";
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

  home.file.".config/nvim/snippets" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix/assets/common/nvim/snippets";
  };
}
