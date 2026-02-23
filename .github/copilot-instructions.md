# NixOS Flake – Copilot Instructions

This is a NixOS flake configuration for two hosts (`void`, `voidframe`) using the **dendritic pattern** with `flake-parts` and `import-tree`.

---

## Core Architecture

### Auto-Discovery via `import-tree`
All `.nix` files under `modules/` are automatically imported — **no manual import wiring is needed**. Adding a new file to any subdirectory of `modules/` makes it available immediately after rebuild.

```nix
# flake.nix
imports = [
  ./modules/flake-modules-option.nix
  ./modules/lib.nix
  (inputs.import-tree ./modules)  # auto-discovers everything
];
```

### The Dendritic Pattern
Configuration is split into independent **aspect modules**, each defining one feature. Every module sets an attribute under `flake.modules.nixos.*` (NixOS) or `flake.modules.homeManager.*` (Home-Manager):

```nix
# modules/services/example.nix
{ ... }: {
  flake.modules.nixos.example =
    { pkgs, ... }:
    {
      services.example.enable = true;
    };
}
```

The outer lambda is a **flake-parts module** (receives `inputs`, `lib`, etc.).
The inner lambda is the actual **NixOS/HM module** (receives `pkgs`, `config`, `lib`, etc.).

### `flake.modules` Option
Defined in `modules/flake-modules-option.nix`. Uses `freeformType` so any key is valid:
- `flake.modules.nixos.<name>` — NixOS system modules
- `flake.modules.homeManager.<name>` — Home-Manager modules

---

## Directory Structure

```
modules/
├── flake-modules-option.nix  # Defines flake.modules option
├── lib.nix                   # mkNixos helper
├── system/                   # OS-level config (boot, networking, locale, sops, stylix, systemd)
├── services/                 # System services (pipewire, greetd, printing, avahi, udev, etc.)
├── desktop/                  # Desktop layer (environment, fonts, programs, xdg)
├── hardware/                 # Hardware config (GPU, firmware)
├── programs/                 # System packages, noctalia
├── nix/                      # Nix daemon settings, overlays
├── home/
│   ├── common.nix            # Base HM config (home dirs, SSH)
│   ├── packages.nix          # User packages
│   ├── files.nix             # Dotfile/asset management
│   └── configs/              # Per-program HM configs (45+ files)
│       └── hyprland/
│           └── _data/        # Hyprland sub-configs (monitors, keybindings, etc.)
├── hosts/
│   ├── void/                 # Desktop host collector
│   │   ├── default.nix       # Defines flake.modules.nixos.void (imports all aspects)
│   │   └── flake-parts.nix   # Calls lib.mkNixos to build nixosConfiguration
│   └── voidframe/            # Laptop host collector (same pattern)
└── users/
    └── neonvoid/             # User definition (collects all HM aspects)

hosts/                        # Hardware-generated configs only
├── void/hardware-configuration.nix
└── voidframe/hardware-configuration.nix

assets/                       # Static dotfiles, scripts, theme assets
secrets/                      # SOPS-encrypted secrets
```

---

## Host Definitions

Each host uses a **two-file pattern**:

**`modules/hosts/<name>/default.nix`** — selects which aspects to enable:
```nix
{ inputs, ... }: {
  flake.modules.nixos.void =
    { pkgs, lib, config, ... }:
    let
      m = inputs.self.modules.nixos;
    in
    {
      imports = [
        m.neonvoid          # user account
        m.boot m.networking m.locale m.systemd
        m.hardware-common m.pipewire m.print
        m.desktop-environment m.xdg m.stylix
        (inputs.self + "/hosts/void/hardware-configuration.nix")
      ];
      networking.hostName = "void";
      # host-specific options...
    };
}
```

**`modules/hosts/<name>/flake-parts.nix`** — creates the nixosConfiguration output:
```nix
{ inputs, ... }: {
  flake.nixosConfigurations = inputs.self.lib.mkNixos "x86_64-linux" "void";
}
```

**Hosts:**
- **`void`** — Desktop (AMD Ryzen 9 9950X, RX 9070 XT, 3440×1440 ultrawide)
- **`voidframe`** — Framework laptop (AMD Ryzen 7 7840U)

---

## Home-Manager Integration

Home-Manager is integrated at the NixOS level via `home-manager.nixosModules.home-manager`. The `mkNixos` helper in `modules/lib.nix` wires it up and passes shared args via `_module.args`:

- `inputs` — all flake inputs
- `username` — `"neonvoid"`
- `hostname` — host name (`"void"` or `"voidframe"`)

External HM modules (spicetify, nix-index-database, noctalia) are added via `home-manager.sharedModules` to avoid circular dependencies.

HM module naming: `flake.modules.homeManager.<name>` (e.g., `homeManager.zsh`, `homeManager.git`).

---

## Key Inputs

| Input | Purpose |
|-------|---------|
| `flake-parts` | Modular flake framework |
| `import-tree` | Auto-discovers dendritic modules |
| `home-manager` | User environment management |
| `stylix` | System-wide theming (base16, GTK, Qt, fonts) |
| `sops-nix` | Secrets management (age encryption) |
| `noctalia` | Quickshell bar/launcher/lockscreen |
| `spicetify-nix` | Spotify theming |
| `nixvim` / `nixCats` | Neovim configuration |
| `nix-cachyos-kernel` | CachyOS optimized kernels |
| `nix-index-database` | Fast `nix-locate` lookups |
| `NUR` | Nix User Repository (overlays) |

---

## Conventions

- **Module file names**: kebab-case (`desktop-environment.nix`, `system-packages.nix`)
- **Module attribute names**: match the file name (`flake.modules.nixos.desktop-environment`)
- **Host names**: lowercase (`void`, `voidframe`)
- **User**: `neonvoid`
- **`_data/` directories**: hold split-out data for complex configs (e.g., `hyprland/_data/keybindings.nix`)
- **Host-specific conditionals**: use `lib.mkIf (config.networking.hostName == "void") { ... }`
- **Styling/colors**: base16 palette via stylix (`c.base0B`, etc.)
- **Secrets**: SOPS age-encrypted in `secrets/`, decrypted to `/run/secrets/` at boot

---

## Adding New Modules

1. Create `modules/<category>/<name>.nix`
2. Define `flake.modules.nixos.<name>` or `flake.modules.homeManager.<name>` inside
3. Add `m.<name>` to the relevant host's `imports` list in `modules/hosts/<hostname>/default.nix`
4. Rebuild: `sudo nixos-rebuild switch --flake /home/neonvoid/nix#<hostname>`

No imports need to be updated anywhere else — `import-tree` handles discovery automatically.
