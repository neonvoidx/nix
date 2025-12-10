{ config, pkgs, lib, ... }:
let nvimConfigDir = "${config.home.homeDirectory}/.config/nvim";
in {
  # Clone nvim config repository directly to ~/.config/nvim
  home.activation.cloneNvimConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ ! -d "${nvimConfigDir}" ]; then
      $DRY_RUN_CMD ${pkgs.git}/bin/git clone https://github.com/neonvoidx/nvim "${nvimConfigDir}"
    else
      $DRY_RUN_CMD ${pkgs.git}/bin/git -C "${nvimConfigDir}" pull --ff-only || true
    fi
  '';
}
