{ den, ... }:
{
  den.aspects.files = { user, ... }: {
    homeManager =
      { config, lib, ... }:
      {
        options.dotfiles.checkoutPath = lib.mkOption {
          type = lib.types.str;
          default = "${config.home.homeDirectory}/nix";
          description = "Local checkout used by build helpers and deliberately mutable assets.";
        };

        config = {
          home.file.".face" = lib.mkIf (user ? avatar) { source = user.avatar; };
          home.sessionVariables.DOTFILES_CHECKOUT_PATH = config.dotfiles.checkoutPath;
          home.file."scripts".source = ../../assets/scripts;
        };
      };
  };
}
