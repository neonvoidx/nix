{ den, ... }:
{
  den.aspects.just.homeManager =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    {
      home.packages = [ pkgs.just ];
      # Sets global justfile
      xdg.configFile."just/justfile" = {
        # The installed justfile works before a new shell imports HM variables.
        # Direct use of the asset falls back to the invocation directory.
        text =
          lib.replaceStrings [ "invocation_directory()" ] [ (builtins.toJSON config.dotfiles.checkoutPath) ]
            (builtins.readFile ../../assets/justfile);
      };
      # adds `j` as an alias to `just -g`, so we can do `j update`, `j rebuild` etc from any directory
      programs.zsh.shellAliases.j = "just -g";
    };
}
