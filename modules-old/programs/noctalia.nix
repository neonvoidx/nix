{ pkgs, inputs, ... }:
{
  environment.systemPackages = [
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
  environment.variables.QS_ICON_THEME = "Dracula";
}
