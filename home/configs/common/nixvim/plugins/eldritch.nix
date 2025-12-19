{ pkgs, ... }:
{
  programs.nixvim.extraPlugins = [
    (pkgs.vimUtils.buildVimPlugin {
      name = "eldritch.nvim";
      src = pkgs.fetchFromGitHub {
        owner = "eldritch-theme";
        repo = "eldritch.nvim";
        rev = "d153de7a8a269792b75d85ef0edee2761d7c7ac5";
        hash = "sha256-nhEn2GX5uSL78KNDEHZa+oR6y6uyYl2oPN34N1Z33cU=";
      };
    })
  ];

}
