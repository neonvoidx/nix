{ inputs, pkgs, ... }:
{
  home.packages = [
    inputs.self.packages.${pkgs.system}.nixCats
  ];
  
  # Set as default editor
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };
}
