{ den, ... }:
{
  den.aspects.wireguard.nixos =
    { pkgs, ... }:
    {
      # Ensure the wireguard kernel module is available. No interface is
      # auto-configured: you bring it up/tear it down on the fly with
      # `wg-quick up <config>` / `wg-quick down <config>`, pointing at any
      # Proton/WireGuard .conf you like. It never starts automatically.
      boot.kernelModules = [ "wireguard" ];

      environment.systemPackages = with pkgs; [
        wireguard-tools
      ];

      environment.shellAliases = {
        wg-up = "sudo wg-quick up";
        wg-down = "sudo wg-quick down";
      };
    };
}
