{ config, ... }:
{
  flake.modules.homeManager.pics = { pkgs, lib, config, ... }: {
    home.activation.clonePicsConfig = let picsDir = "${config.home.homeDirectory}/pics"; in lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      if [ ! -d "${picsDir}" ]; then
        $DRY_RUN_CMD ${pkgs.git}/bin/git clone https://github.com/neonvoidx/pics "${picsDir}"
      fi
    '';
  };
}
