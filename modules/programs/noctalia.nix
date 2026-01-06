{ pkgs, inputs, ... }:
{
  environment.systemPackages = with pkgs; [
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
  environment.variables.QS_ICON_THEME = "Dracula";
}
