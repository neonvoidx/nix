{ pkgs, ... }:
{
  # Plugin: OXY2DEV/helpview.nvim - Enhanced help file viewing
  extraPlugins = [
    (pkgs.vimUtils.buildVimPlugin {
      name = "helpview.nvim";
      src = pkgs.fetchFromGitHub {
        owner = "OXY2DEV";
        repo = "helpview.nvim";
        rev = "main";
        sha256 = "sha256-Utcdm/9nAIfIx6oOXHgArS59/oTAOPg+wK+4/Z3TQUQ=";
      };
    })
  ];

  extraConfigLua = ''
    require('helpview').setup({})
  '';
}
