# NixOS Configuration

My NixOS configuration using the [dendritic pattern](https://github.com/Doc-Steve/dendritic-design-with-flake-parts/wiki) with [flake-parts](https://flake.parts/) and [import-tree](https://github.com/vic/import-tree).

## Structure

```
├── flake.nix              # Single-line entry point — import-tree discovers everything
├── hosts/                 # Hardware-generated configs (nixos-generate-config)
│   ├── void/hardware-configuration.nix
│   └── voidframe/hardware-configuration.nix
├── modules/
│   ├── common/            # Shared profiles (base — aggregates all leaf aspects)
│   ├── factory/           # Factory functions (user account creation)
│   ├── system/            # OS-level aspects (boot, locale, networking, systemd)
│   ├── hardware/          # Hardware aspects (firmware, bluetooth, kernel, udev)
│   ├── security/          # Security aspects (sops, pcscd, gnome-keyring, greetd)
│   ├── audio/             # Audio aspects (pipewire)
│   ├── desktop/           # Desktop aspects (hyprland, stylix, noctalia, flatpak, fonts, …)
│   ├── shell/             # Shell aspects (zsh, bat, git, kitty, yazi, …)
│   ├── gaming/            # Gaming aspects (steam, mangohud, curseforge)
│   ├── media/             # Media aspects (mpv, obs, spicetify, ananicy, …)
│   ├── communication/     # Communication aspects (vesktop, email)
│   ├── ide/               # Editor aspects (nixcats)
│   ├── nix/               # Nix daemon settings and overlays
│   ├── home/              # Home-Manager base (common, packages, files)
│   ├── hosts/             # Host definitions (multi-file per host)
│   │   ├── void/          # configuration.nix, hardware.nix, network.nix, flake-parts.nix
│   │   └── voidframe/     # same pattern
│   └── users/
│       └── neonvoid/      # User definition (factory + all HM imports)
└── secrets/               # SOPS age-encrypted secrets
```

## Hosts

| Host | Hardware | Role |
|------|----------|------|
| **void** | AMD Ryzen 9 9950X, RX 9070 XT, 3440×1440 | Desktop |
| **voidframe** | AMD Ryzen 7 7840U, Framework 16 | Laptop |

## Key Features

- **Dendritic Pattern** — every feature is a self-contained aspect file; no manual import wiring
- **import-tree** — all `.nix` files under `modules/` are auto-discovered
- **Factory Pattern** — user accounts created with a single function call
- **Merged Aspects** — NixOS + Home-Manager config for the same program live in one file
- **Multi-file Hosts** — host config split across `configuration.nix`, `hardware.nix`, `network.nix`
- **Hyprland** — Wayland compositor, fully configured in a single `desktop/hypr/hyprland.nix`
- **Stylix** — System-wide theming (NixOS + HM merged in one aspect)
- **SOPS** — Encrypted secrets, decrypted to `/run/secrets/` at boot
- **Noctalia Shell** — Quickshell bar, launcher, lock screen

## Usage

```bash
# Build (dry run)
nixos-rebuild dry-build --flake .#void

# Deploy
sudo nixos-rebuild switch --flake .#void
sudo nixos-rebuild switch --flake .#voidframe
```

## Dendritic Pattern

Each feature is a self-contained **aspect** file. NixOS and Home-Manager config for the same program live together:

```nix
# modules/audio/pipewire.nix
{ ... }:
{
  flake.modules.nixos.pipewire = { pkgs, ... }: {
    services.pipewire.enable = true;
    # ...
  };

  flake.modules.homeManager.pipewire = { ... }: {
    # user-level config if needed
  };
}
```

The `common/base.nix` profile aggregates all shared leaf aspects so host files stay short:

```nix
# modules/hosts/void/configuration.nix
{ inputs, ... }:
{
  flake.modules.nixos.void = {
    imports = with inputs.self.modules.nixos; [
      base          # all shared aspects in one import
      neonvoid      # user account + home-manager wiring
      network-drives # void-specific extras
    ];
    system.stateVersion = "25.11";
  };
}
```

## Adding a New Module

1. Create `modules/<category>/my-feature.nix`:

```nix
{ ... }:
{
  flake.modules.nixos.my-feature = { pkgs, ... }: {
    services.myservice.enable = true;
  };

  # optional — HM config lives alongside NixOS config
  flake.modules.homeManager.my-feature = { pkgs, ... }: {
    programs.myservice.enable = true;
  };
}
```

2. Add to `modules/common/base.nix` (shared across all hosts) or directly to a specific host's `configuration.nix`. That's it — import-tree discovers the file automatically.

## Adding a New Host

1. Create `modules/hosts/<hostname>/`:

```
configuration.nix   # imports base + user + host-specific extras
hardware.nix        # GPU, kernel, boot params; imports hardware-configuration.nix
network.nix         # static IP / wifi / hostname
flake-parts.nix     # registers the nixosConfiguration output
```

```nix
# configuration.nix
{ inputs, ... }:
{
  flake.modules.nixos.<hostname> = {
    imports = with inputs.self.modules.nixos; [ base neonvoid ];
    system.stateVersion = "25.11";
  };
}
```

```nix
# flake-parts.nix
{ inputs, ... }:
{
  flake.nixosConfigurations = inputs.self.lib.mkNixos "x86_64-linux" "<hostname>";
}
```

2. Add `hosts/<hostname>/hardware-configuration.nix` (from `nixos-generate-config`).

Done — import-tree picks up all files automatically.

## Adding a New User

The factory pattern handles system account creation and Home-Manager wiring in one call.

1. Create `modules/users/<username>/<username>.nix`:

```nix
{ self, lib, ... }:
{
  flake.modules = lib.mkMerge [
    (self.factory.user "<username>" true)  # true = wheel/admin
    {
      nixos.<username> = { ... }: {
        users.users.<username> = {
          description = "Display Name";
          extraGroups = [ "networkmanager" "audio" "video" ];
        };
      };

      homeManager.<username> = { ... }: {
        # auto-import all HM aspects, or list them selectively:
        imports = builtins.attrValues (builtins.removeAttrs self.modules.homeManager [ "<username>" ]);
      };
    }
  ];
}
```

2. Add `m.<username>` to the host's `configuration.nix` imports. The factory automatically wires `home-manager.users.<username>` — nothing else needed.

## SOPS Secrets

See [secrets/README.md](./secrets/README.md). Secrets are age-encrypted and decrypted to `/run/secrets/` at boot.

