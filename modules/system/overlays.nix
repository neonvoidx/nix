{ inputs, ... }:
{
  nixpkgs.overlays = [
    # TODO
    # inputs.nix-cachyos-kernel.overlays.default
    (final: prev: {
      nur = import inputs.nur {
        nurpkgs = prev;
        pkgs = prev;
      };
    })
  ];

  # CachyOS Kernel
  # TODO
  # boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest;
}
