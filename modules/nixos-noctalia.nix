{ config, inputs, ... }:
{
  flake.modules.nixos.noctalia = { pkgs, ... }: {
    environment.systemPackages = [
      inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
    environment.variables.QS_ICON_THEME = "Dracula";
  };
}
