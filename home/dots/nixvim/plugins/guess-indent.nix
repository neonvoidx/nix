{ pkgs, ... }:
{
  programs.nixvim = {
    extraPlugins = with pkgs.vimPlugins; [
      {
        plugin = pkgs.vimUtils.buildVimPlugin {
          name = "guess-indent";
          src = pkgs.fetchFromGitHub {
            owner = "NMAC427";
            repo = "guess-indent.nvim";
            rev = "6cd61f7a600bb756e558627cd2e740302c58e32d";
            hash = "sha256-QsSVVwG1GYt1+m+mjpdLW8d8J3wSQyRSe+SZBHWCm14=";
          };
        };
        config = ''
          lua << EOF
          require("guess-indent").setup()
          EOF
        '';
      }
    ];
  };
}
