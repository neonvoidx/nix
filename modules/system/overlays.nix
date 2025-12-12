{ pkgs, inputs, ... }:
{
  nixpkgs.overlays = [
    # inputs.nix-cachyos-kernel.overlays.default
    (final: prev: {
      nur = import inputs.nur {
        nurpkgs = prev;
        pkgs = prev;
      };
    })
  ];

  # CachyOS Kernel
  # boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest;
}
