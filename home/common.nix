{
  username,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./configs/common
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
  };

  home.packages = with pkgs; [
    home-manager
    kitty
    kitty-themes
    github-copilot-cli
    gh
    proton-pass
    lazygit
    zoxide
    ffmpeg
    pay-respects
    tealdeer
    fastfetch
  ];

  home.file.".config/scopebuddy".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix/assets/scopebuddy";

  services.udiskie.enable = true;
  programs.home-manager.enable = true;
}
