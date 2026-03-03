{ den, ... }:
{
  den.aspects.pics.homeManager =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      picsDir = "${config.home.homeDirectory}/pics";
    in
    {
      # NOTE: Update this to your wallpaper repo if you want your own
      home.activation.clonePicsConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        if [ ! -d "${picsDir}" ]; then
          $DRY_RUN_CMD ${pkgs.git}/bin/git clone https://github.com/neonvoidx/pics "${picsDir}"
        fi
      '';
    };
}
