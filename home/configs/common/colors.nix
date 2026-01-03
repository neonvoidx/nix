{ nix-colors, ... }:
{
  imports = [ nix-colors.homeManagerModules.default ];
  # colorScheme = nix-colors.colorSchemes.eldritch;
  # TODO wait for eldritch to show up?
  colorScheme = {
    slug = "eldritch";
    name = "Eldritch";
    author = "neonvoidx (https://github.com/eldritch-theme)";
    palette = {
      base00 = "#212337";
      base01 = "#323449";
      base02 = "#3b4261";
      base03 = "#7081d0";
      base04 = "#a1abe0";
      base05 = "#ebfafa";
      base06 = "#f0f2f4";
      base07 = "#ffffff";
      base08 = "#f16c75";
      base09 = "#f7c67f";
      base0A = "#f1fc79";
      base0B = "#37f499";
      base0C = "#04d1f9";
      base0D = "#04d1f9";
      base0E = "#a48cf2";
      base0F = "#f265b5";
    };
  };
}
