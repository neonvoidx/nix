{ den, ... }:
{
  den.aspects.pics = { user, ... }: {
    homeManager =
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
        home.activation.clonePicsConfig = lib.mkIf (user ? wallpaperRepository) (
          lib.hm.dag.entryAfter [ "writeBoundary" ] ''
            if [ ! -d "${picsDir}" ]; then
              $DRY_RUN_CMD ${pkgs.git}/bin/git clone -- ${lib.escapeShellArg user.wallpaperRepository} ${lib.escapeShellArg picsDir}
            fi
          ''
        );
      };
  };
}
