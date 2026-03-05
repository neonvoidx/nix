{
  description = "neonvoidx neovim configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-wrapper-modules = {
      url = "github:BirdeeHub/nix-wrapper-modules";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nix-wrapper-modules,
      ...
    }@inputs:
    let
      forAllSystems = nixpkgs.lib.genAttrs nixpkgs.lib.platforms.all;
      module = nixpkgs.lib.modules.importApply ./nix/module.nix inputs;
      wrapper = nix-wrapper-modules.lib.evalModule module;
    in
    {
      # Consumed by neonvoidx/nix via:
      #   inputs.nvim-config.wrappers.neovim.wrap { inherit pkgs; }
      wrappers = {
        neovim = wrapper.config;
        default = self.wrappers.neovim;
      };
      overlays = {
        neovim = final: _: { neovim = wrapper.config.wrap { pkgs = final; }; };
        default = self.overlays.neovim;
      };
      packages = forAllSystems (
        system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        {
          neovim = wrapper.config.wrap { inherit pkgs; };
          default = self.packages.${system}.neovim;
        }
      );
      # `wrappers.neovim.enable = true` in nixos configuration
      nixosModules = {
        neovim = nix-wrapper-modules.lib.mkInstallModule {
          name = "neovim";
          value = module;
        };
        default = self.nixosModules.neovim;
      };
      # `wrappers.neovim.enable = true` in home-manager configuration
      homeModules = {
        neovim = nix-wrapper-modules.lib.mkInstallModule {
          name = "neovim";
          value = module;
          loc = [
            "home"
            "packages"
          ];
        };
        default = self.homeModules.neovim;
      };
    };
}
