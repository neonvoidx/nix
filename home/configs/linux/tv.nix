{ ... }:
{
  programs = {
    television = {
      enable = true;
      enableZshIntegration = true;
      channels = { };
      settings = { };
    };
    nix-search-tv = {
      enable = true;
      enableTelevisionIntegration = true;
      settings = {
        indexes = [
          "nixpkgs"
          "home-manager"
          "nixos"
        ];

        experimental = {
          render_docs_indexes = {
            nvf = "https://notashelf.github.io/nvf/options.html";
          };
        };
      };
    };
  };
}
