{ pkgs, ... }:
{
  programs.nixvim = {
    extraPlugins = with pkgs.vimPlugins; [
      {
        plugin = pkgs.vimUtils.buildVimPlugin {
          name = "hmts";
          src = pkgs.fetchFromGitHub {
            owner = "calops";
            repo = "hmts.nvim";
            rev = "9a1ef2f22f999c53a36e5b82e6af14cb4e0ac14f";
            hash = "sha256-0zq+yXYZlYDmR06Z/mUlKqhN8ygZYRKGrxo9tnJJFGo=";
          };
        };
      }
    ];
  };
}
