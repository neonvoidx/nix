{ den, ... }:
{
  den.aspects.just.homeManager =
    { pkgs, config, ... }:
    {
      home.packages = [ pkgs.just ];
      # Sets global justfile
      home.file.".config/just/justfile" = {
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix/assets/justfile";
      };
      # adds `j` as an alias to `just -g`, so we can do `j update`, `j rebuild` etc from any directory
      programs.zsh.shellAliases.j = "just -g";
    };
}
