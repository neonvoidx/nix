{
  description = "A Nix-flake-based C/C++ development environment with Clang and Vulkan";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    { ... }@inputs:

    inputs.flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = inputs.nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            clang-tools
            cmake
            cppcheck
            glslang
            glfw
            glm
            vulkan-headers
            vulkan-loader
            vulkan-memory-allocator
            vulkan-validation-layers
            imgui

          ];
          shellHook = ''
            echo "Welcome to hell (Vulkan and C++)"
          '';

          LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [
            pkgs.vulkan-loader
            pkgs.vulkan-validation-layers
          ];

          VULKAN_SDK = "${pkgs.vulkan-headers}";
          VK_LAYER_PATH = "${pkgs.vulkan-validation-layers}/share/vulkan/explicit_layer.d";
        };
      }
    );
}
