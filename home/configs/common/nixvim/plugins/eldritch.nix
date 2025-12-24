{ pkgs, ... }:
{
  extraPlugins = [
    (pkgs.vimUtils.buildVimPlugin {
      name = "eldritch.nvim";
      src = pkgs.fetchFromGitHub {
        owner = "eldritch-theme";
        repo = "eldritch.nvim";
        rev = "0415fa72c348e814a7a6cc9405593a4f812fe12f";
        hash = "sha256-nEt25TqsYePRCYkCI9zEk/awFBQ9ENyYWR0hSyy24GY=";
      };
    })
  ];

}
