# NixOS Flake – Copilot Instructions

This is a NixOS flake configuration for two hosts (`void`, `voidframe`) using the **den** framework with `flake-parts` and `import-tree`.

---

## Core Architecture

### Auto-Discovery via `import-tree`
All `.nix` files under `modules/` are automatically imported — **no manual import wiring is needed**. Adding a new file to any subdirectory of `modules/` makes it available immediately after rebuild.

```nix
# flake.nix
inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules)
```

### Den Framework
Configuration is split into independent **aspect modules** using the `den` framework. Each module defines `den.aspects.<name>` with optional `nixos` and `homeManager` sections:

```nix
# modules/category/example.nix
{ den, ... }:
{
  den.aspects.example = {
    nixos = { pkgs, ... }: {
      services.example.enable = true;
    };

    homeManager = { pkgs, ... }: {
      programs.example.enable = true;
    };
  };
}
```

The outer `{ den, inputs, ... }:` lambda is a **flake-parts module**.
The `nixos`/`homeManager` values are standard **NixOS/HM modules**.

### Host & User Context
Aspects can receive `host` and `user` context via the outer aspect lambda:

```nix
{ den, ... }:
{
  den.aspects.example =
    { host, user, ... }:
    {
      nixos = { pkgs, lib, ... }: {
        # host.hostName, host.xRes, host.isGaming or false, host.isLaptop or false
        systemd.services.greetd = lib.mkIf (host.isMultiMonitor or false) {
          preStart = "${pkgs.fbset}/bin/fbset -xres ${host.xRes} -yres ${host.yRes}";
        };
      };

      homeManager = { ... }: {
        # user.userName, user.homeDirectory
        home.file."hello".text = "hello ${user.userName}";
      };
    };
}
```

> **Critical:** `host` and `user` are only available in the **outer aspect lambda**, NOT inside `nixos`/`homeManager` module args. They are captured via Nix lexical scoping.
> Use `host.attr or false` / `host.attr or ""` for attributes that may not exist on all hosts.

---

## Directory Structure

```
modules/
├── dendritic.nix          # Bootstraps den into flake-parts
├── hosts.nix              # Declares den.hosts with host attributes and users
├── home-manager.nix       # HM integration (useGlobalPkgs, sharedModules)
├── state-versions.nix     # NixOS + HM stateVersion = "25.11"
├── system/                # OS-level aspects (boot, locale, networking, systemd)
├── hardware/              # Hardware aspects (firmware, bluetooth, kernel, udev, streamcontroller)
├── security/              # Security aspects (sops, pcscd, gnome-keyring, greetd)
├── desktop/               # Desktop aspects (hyprland, stylix, noctalia, flatpak, fonts, gtk, xdg, …)
│   └── hypr/_data/        # Hyprland sub-configs (excluded from import-tree via _prefix)
├── shell/                 # Shell aspects (zsh, bat, git, kitty, yazi, …)
├── gaming/                # Gaming aspects (steam, mangohud, curseforge)
├── media/                 # Media aspects (mpv, obs, spicetify, ananicy, …)
├── communication/         # Communication aspects (vesktop, email)
├── ide/                   # Editor aspects (nixcats)
├── nix/                   # Nix daemon settings and overlays
├── hosts/
│   ├── void/default.nix       # void host aspect: system-only includes + hardware config
│   └── voidframe/default.nix  # voidframe host aspect: same pattern
└── users/
    └── neonvoid/neonvoid.nix  # User aspect: all desktop/shell/app includes

hosts/                         # Hardware-generated configs only
├── void/hardware-configuration.nix
└── voidframe/hardware-configuration.nix
assets/                        # Static dotfiles, scripts, theme assets
secrets/                       # SOPS-encrypted secrets
```

---

## Host Definitions

**`modules/hosts.nix`** — declares all hosts with freeform attributes:
```nix
{ den, ... }:
{
  den.hosts.x86_64-linux = {
    void = {
      xRes = "3440";
      yRes = "1440";
      isGaming = true;
      isMultiMonitor = true;
      users.neonvoid = {};
    };
    voidframe = {
      xRes = "2880";
      yRes = "1920";
      isLaptop = true;
      users.neonvoid = {};
    };
  };
}
```

**`modules/hosts/<name>/default.nix`** — host aspect with system-only includes and hardware config:
```nix
{ den, inputs, ... }:
{
  den.aspects.void = {
    includes = [
      den.aspects.boot
      den.aspects.locale
      den.aspects.networking
      den.aspects.systemd
      den.aspects."user-accounts"
      den.aspects.overlays
      den.aspects."nix-settings"
      den.aspects.firmware
      den.aspects.bluetooth
      den.aspects.kernel
      den.aspects.sops
      den.aspects.greetd
      den.aspects."system-packages"
    ];

    nixos = { lib, pkgs, ... }: {
      imports = [ (inputs.self + "/hosts/void/hardware-configuration.nix") ];
      networking.hostName = "void";
      # boot, hardware, networking specifics...
    };
  };
}
```

Den auto-generates `nixosConfigurations.void` from `hosts.nix` — no `flake-parts.nix` needed.

**Hosts:**
- **`void`** — Desktop (AMD Ryzen 9 9950X, RX 9070 XT, 3440×1440 ultrawide)
- **`voidframe`** — Framework laptop (AMD Ryzen 7 7840U)

---

## User Definitions

**`modules/users/neonvoid/neonvoid.nix`** — user aspect with all desktop/app includes:
```nix
{ den, ... }:
{
  den.aspects.neonvoid = {
    includes = [
      den.aspects.zsh
      den.aspects.stylix
      den.aspects.hyprland
      # ... all user-facing aspects
    ];

    nixos = { pkgs, ... }: {
      users.users.neonvoid = {
        isNormalUser = true;
        shell = pkgs.zsh;
        extraGroups = [ "wheel" "audio" "video" ];
      };
    };

    homeManager = { ... }: {
      home.stateVersion = "25.11";
    };
  };
}
```

> **Critical:** Den automatically applies the user aspect — do NOT add `den.aspects.neonvoid` to host includes. Adding it to both causes double application of all homeManager configs.

> **Rule:** Host includes = system-only aspects. User includes = all user-facing/desktop aspects. The `nixos` sections of user-included aspects still apply to the system.

---

## Home-Manager Integration

Configured in `modules/home-manager.nix` via `den.ctx.hm-host.nixos.home-manager`:
- `useGlobalPkgs = true`
- `sharedModules` — external HM modules (spicetify, nix-index-database, noctalia)

---

## Key Inputs

| Input | Purpose |
|-------|---------|
| `den` | Den framework — auto-generates nixosConfigurations, wires HM, provides context |
| `flake-parts` | Modular flake framework |
| `flake-file` | Required by den's dendritic module |
| `flake-aspects` | Required by den's dendritic module |
| `import-tree` | Auto-discovers all `.nix` files in `modules/` |
| `home-manager` | User environment management |
| `stylix` | System-wide theming (base16, GTK, Qt, fonts) |
| `sops-nix` | Secrets management (age encryption) |
| `noctalia` | Quickshell bar/launcher/lockscreen |
| `spicetify-nix` | Spotify theming |
| `nixCats` | Neovim configuration |
| `nix-cachyos-kernel` | CachyOS optimized kernels |
| `nix-index-database` | Fast `nix-locate` lookups |
| `NUR` | Nix User Repository (overlays) |

---

## Conventions

- **Module file names**: kebab-case (`desktop-environment.nix`, `system-packages.nix`)
- **Aspect names**: match the file name (`den.aspects."desktop-environment"`)
- **Host names**: lowercase (`void`, `voidframe`)
- **User**: `neonvoid`
- **`_data/` directories**: hold split-out data excluded from import-tree (e.g., `hyprland/_data/keybindings.nix`)
- **Host-specific conditionals**: use `host.attr or false` in the outer lambda, or `config.networking.hostName == "void"` inside nixos modules
- **Styling/colors**: base16 palette via stylix
- **Secrets**: SOPS age-encrypted in `secrets/`, decrypted to `/run/secrets/` at boot
- **Git tracking**: new files must be `git add`-ed before rebuilding (Nix only evaluates git-tracked files)

---

## Adding New Aspects

1. Create `modules/<category>/<name>.nix` — import-tree picks it up automatically
2. Add `den.aspects.<name>` to the user's includes (`modules/users/neonvoid/neonvoid.nix`) for user-facing features, or to the host's includes (`modules/hosts/<hostname>/default.nix`) for system-only features
3. Rebuild: `sudo nixos-rebuild switch --flake /home/neonvoid/nix#<hostname>`

## Adding a New Host

1. Add to `modules/hosts.nix` under `den.hosts.x86_64-linux`
2. Create `modules/hosts/<hostname>/default.nix` with `den.aspects.<hostname>`
3. Add `hosts/<hostname>/hardware-configuration.nix`

## Adding a New User

1. Create `modules/users/<username>/<username>.nix` with `den.aspects.<username>`
2. Add `users.<username> = {}` to the relevant host entry in `modules/hosts.nix`
