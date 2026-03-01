# NixOS Configuration

My NixOS configuration using the [dendritic pattern](https://github.com/mightyiam/dendritic) with [flake-parts](https://flake.parts/) and [import-tree](https://github.com/vic/import-tree).

## Structure

```
├── flake.nix              # Flake entry point (one-liner outputs)
├── modules/
│   ├── lib.nix            # Helper: systems list + mkNixos
│   ├── system/            # NixOS-only: boot, networking, locale, sops, stylix, etc.
│   ├── services/          # NixOS-only: pipewire, greetd, printing, udev, etc.
│   ├── desktop/           # NixOS-only: fonts, xdg portals, programs, env vars
│   ├── hardware/          # NixOS-only: GPU, firmware, bluetooth
│   ├── programs/          # NixOS-only: system packages, noctalia
│   ├── nix/               # NixOS-only: nix daemon settings, overlays
│   ├── home/              # Home-Manager modules (user-space config)
│   │   ├── common.nix     # Base HM config (dirs, SSH, services)
│   │   ├── packages.nix   # User packages
│   │   ├── git.nix        # Git + delta + gh
│   │   ├── files.nix      # Dotfiles and secrets activation
│   │   ├── zsh.nix        # Shell (NixOS: enable globally; HM: full config)
│   │   ├── hyprland/      # Compositor (NixOS: enable; HM: full config + data/)
│   │   ├── thunar.nix     # File manager (NixOS: programs.thunar; HM: mime types)
│   │   └── *.nix          # Per-program HM configs (bat, btop, kitty, etc.)
│   ├── hosts/             # Host collector modules
│   │   ├── void/          # Desktop: aspect list + flake-parts.nix
│   │   └── voidframe/     # Laptop: aspect list + flake-parts.nix
│   └── users/             # User definitions
│       └── neonvoid/      # System account + HM collector
└── secrets/               # SOPS encrypted secrets
```

### modules/home/ — The Key Distinction

`modules/home/` contains **two kinds** of files:

| Kind | Example | What it defines |
|------|---------|-----------------|
| **Pure HM** | `bat.nix`, `btop.nix`, `kitty.nix` | Only `flake.modules.homeManager.<name>` |
| **True aspects** | `zsh.nix`, `hyprland/`, `thunar.nix` | Both `flake.modules.nixos.<name>` AND `flake.modules.homeManager.<name>` |

True aspects are cross-cutting concerns: they need a NixOS system module (e.g. enable the program/service globally) AND a Home Manager module (configure it per-user). Pure HM modules are user-space only and only define `flake.modules.homeManager.<name>`.

All other `modules/` subdirectories (`system/`, `services/`, `desktop/`, `hardware/`, `programs/`, `nix/`) contain **NixOS-only** modules — they only define `flake.modules.nixos.<name>`.

## Hosts

- **void** — Main desktop (AMD Ryzen 9 9950X, RX 9070 XT, 3440×1440)
- **voidframe** — Framework laptop (AMD Ryzen 7 7840U)

## Key Features

- **Dendritic Pattern** — Modular, per-feature files auto-discovered by `import-tree`
- **Home-Manager** — Full user environment via NixOS integration (`home-manager.nixosModules`)
- **Hyprland** — Wayland compositor with full per-host config
- **Stylix** — System-wide theming (base16 palette, GTK, Qt, fonts)
- **SOPS** — Age-encrypted secrets, decrypted to `/run/secrets/` at boot
- **Noctalia Shell** — Quickshell bar, launcher, lock screen

## Usage

### Build

```bash
nix build .#nixosConfigurations.void.config.system.build.toplevel
nix build .#nixosConfigurations.voidframe.config.system.build.toplevel
```

### Deploy

```bash
sudo nixos-rebuild switch --flake .#void
sudo nixos-rebuild switch --flake .#voidframe
```

## Dendritic Pattern

All `.nix` files under `modules/` are **auto-discovered** by `import-tree` — no manual wiring required.

Each file is a **flake-parts module** (outer lambda) wrapping a **NixOS or HM module** (inner lambda):

```nix
# modules/system/my-feature.nix  (NixOS-only)
{ ... }:
{
  flake.modules.nixos.my-feature = { pkgs, ... }: {
    services.myservice.enable = true;
  };
}
```

```nix
# modules/home/my-program.nix  (HM-only)
{ ... }:
{
  flake.modules.homeManager.my-program = { pkgs, ... }: {
    programs.myprogram.enable = true;
  };
}
```

```nix
# modules/home/my-aspect.nix  (true aspect: NixOS + HM)
{ ... }:
{
  flake.modules.nixos.my-aspect = {
    services.my-aspect.enable = true;  # system-wide
  };

  flake.modules.homeManager.my-aspect = { pkgs, ... }: {
    programs.my-aspect = { enable = true; /* user config */ };
  };
}
```

**Host collectors** (`modules/hosts/<name>/default.nix`) import the aspects they need:

```nix
let m = inputs.self.modules.nixos; in
{
  imports = [
    m.boot m.networking m.pipewire
    m.zsh m.hyprland  # true aspects
    m.home-manager m.sops m.stylix
  ];
}
```

## Adding New Modules

### NixOS-only

1. Create `modules/<category>/my-feature.nix`
2. Add `m.my-feature` to host `imports` in `modules/hosts/<host>/default.nix`

### Home Manager only

1. Create `modules/home/my-program.nix`
2. Add `self.modules.homeManager.my-program` to user collector in `modules/users/neonvoid/default.nix`

### True aspect (NixOS + HM)

1. Create `modules/home/my-aspect.nix` defining both `flake.modules.nixos.my-aspect` and `flake.modules.homeManager.my-aspect`
2. Add `m.my-aspect` to host `imports` (NixOS side)
3. Add `self.modules.homeManager.my-aspect` to user collector (HM side)

`import-tree` handles auto-discovery — no other wiring needed.

## SOPS Secrets

See [secrets/README.md](./secrets/README.md) for setup instructions.

Secrets are encrypted with age keys derived from SSH keys and decrypted to `/run/secrets/` at boot.

