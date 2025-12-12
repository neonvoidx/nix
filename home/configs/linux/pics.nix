{ config, pkgs, lib, ... }:
let picsDir = "${config.home.homeDirectory}/pics";
in {
  home.activation.clonePicsConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ ! -d "${picsDir}" ]; then
      $DRY_RUN_CMD ${pkgs.git}/bin/git clone https://github.com/neonvoidx/pics "${picsDir}"
    else
      $DRY_RUN_CMD ${pkgs.git}/bin/git -C "${picsDir}" pull --ff-only || true
    fi
  '';
}
