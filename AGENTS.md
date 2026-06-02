# NixOS Flake — Agent Instructions

This file provides context for any AI agent working with this NixOS flake configuration.

---

## Den Framework Reference

For anything related to the den framework, **always consult**:

- **<https://github.com/vic/den/blob/main/AGENTS_EXAMPLE.md>** — comprehensive AI agent guide covering aspects, context pipeline, batteries, parametric dispatch, schema, and all den APIs. Read this before generating any den configuration.
- **<https://github.com/denful/den>** — source repository for looking up option definitions, battery implementations, CI test examples (`tree/main/templates/ci/modules/features/`), and documentation (`tree/main/docs/src/content/docs/`).

### Diagnosing Den Issues After a Flake Update

When a `nix flake update` causes unexpected package removals, evaluation errors, or broken behaviour related to Den:

1. **Check release notes first** — fetch `https://github.com/denful/den/releases` to find breaking changes between the old and new version. Den uses semantic versioning; minor bumps can include breaking API changes.
2. **Read the docs** — fetch `https://github.com/denful/den/tree/main/docs/src/content/docs/` to understand the current API before touching any aspect definitions. Do not assume the API is the same as in your training data.
3. **Cross-reference CI tests** — the canonical source of truth for working patterns is `https://github.com/denful/den/tree/main/templates/ci/modules/features/`. If a pattern isn't reflected in a passing CI test, treat it as unreliable.
4. **Prefer CI test patterns over templates or docs examples** — templates (e.g. `igloo.nix`) may be illustrative rather than exhaustively tested. A pattern that appears in a `denTest` block and is in the CI test suite is guaranteed to work for that version.
5. **Do not deep-dive internal Nix source files until the docs and CI tests are exhausted** — start with documentation and tests; resort to reading `nix/lib/` source only if those don't resolve the issue.

---

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
├── flake-inputs.nix       # Flake input declarations — edit here, then run `nix run .#write-flake`
├── den.nix                # Bootstraps den + flake-file, den defaults: stateVersion, HM config, sharedModules, user shell
├── hosts.nix              # Declares den.hosts with host attributes and users
├── nh.nix                 # Nix home manager tool
├── system/                # OS-level aspects (boot, locale, networking, systemd, packages, users)
├── hardware/              # Hardware aspects (bluetooth, kernel, udev, print, streamcontroller, usb)
├── security/              # Security aspects (sops, pcscd, gnome-keyring, ly)
├── desktop/               # Desktop aspects (hyprland, stylix, noctalia, flatpak, fonts, gtk, xdg, clipboard, cursor, environment, firefox, thunar, …)
│   └── hypr/              # Hyprland sub-aspects (hyprland, hypridle,  satty)
├── shell/                 # Shell aspects (zsh, bat, btop, direnv, fastfetch, fzf, ghostty, git, jq, just, kitty, lazygit, lsd, nh, payrespects, tealdeer, yazi, zoxide)
├── gaming/                # Gaming aspects (steam, mangohud, deadlock, wow)
├── media/                 # Media aspects (mpv, obs-studio, spicetify, ananicy, cava, easyeffects, noisetorch, pics, pipewire, network-drives)
├── communication/         # Communication aspects (vesktop, email)
├── home/                  # Home-manager aspects (common, files, packages)
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
let
  neonvoid = {
    gitName = "neonvoidx";
    gitEmail = "me@neonvoid.dev";
  };
  timezone = "America/New_York";
in
{
  den.hosts.x86_64-linux = {
    void = {
      users.neonvoid = neonvoid;
      xRes = "3440";
      yRes = "1440";
      isMultiMonitor = true;
      gpuPciDev = "0000:03:00.0"; # AMD RX 9070 XT
      greeting = "The Void";
      timezone = timezone;
    };
    voidframe = {
      users.neonvoid = neonvoid;
      xRes = "2880";
      yRes = "1920";
      isLaptop = true;
      greeting = "Void Frame";
      timezone = timezone;
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
      # Core system
      den.aspects.boot
      den.aspects.locale
      den.aspects.networking
      den.aspects.systemd
      den.aspects.users
      den.aspects.overlays
      den.aspects.nixsettings

      # Hardware
      den.aspects.bluetooth
      den.aspects.kernel
      den.aspects.print
      den.aspects.udev

      # Security
      den.aspects.sops
      den.aspects.pcscd
      den.aspects.ly

      # Services
      den.aspects.ananicy
      den.aspects.networkdrives

      # System packages
      den.aspects.systempackages
    ];

    # Push host-specific aspects to all users of this host via mutual-provider
    provides.to-users = { ... }: {
      includes = [
        # Gaming — void desktop only
        den.aspects.deadlock
        den.aspects.wow
        den.aspects.noisetorch
      ];
    };

    nixos = { lib, pkgs, ... }: {
      imports = [ (inputs.self + "/hosts/void/hardware-configuration.nix") ];
      # boot, hardware, networking specifics...
    };
  };
}
```

Den auto-generates `nixosConfigurations.void` from `hosts.nix` — no `flake-parts.nix` needed.

> **`provides.to-users`**: A host aspect can push additional includes or config to all of its users via `provides.to-users`. This is useful for host-specific features (e.g., gaming titles only relevant on the desktop) without polluting the shared user aspect. The inner value is a standard aspect lambda.

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
      # Shell tools
      den.aspects.zsh
      den.aspects.bat
      den.aspects.btop
      den.aspects.direnv
      den.aspects.fastfetch
      den.aspects.fzf
      den.aspects.ghostty
      den.aspects.git
      den.aspects.jq
      den.aspects.just
      den.aspects.kitty
      den.aspects.lazygit
      den.aspects.lsd
      den.aspects.nh
      den.aspects.payrespects
      den.aspects.tealdeer
      den.aspects.yazi
      den.aspects.zoxide

      # Desktop
      den.aspects."desktop-environment"
      den.aspects.fonts
      den.aspects.xdg
      den.aspects.stylix
      den.aspects.noctalia
      den.aspects.flatpak
      den.aspects.clipboard
      den.aspects.cursor
      den.aspects.firefox
      den.aspects.gtk
      den.aspects.hyprland
      den.aspects.hypridle
      den.aspects.satty
      den.aspects.thunar

      # Services (user-level)
      den.aspects.gnomekeyring
      den.aspects.pipewire
      den.aspects.streamcontroller
      den.aspects.usb

      # Home
      den.aspects.common
      den.aspects.files
      den.aspects.packages

      # Media
      den.aspects.cava
      den.aspects.easyeffects
      den.aspects.mpv
      den.aspects.obsstudio
      den.aspects.pics
      den.aspects.spicetify
      # noisetorch pushed to void users via provides.to-users

      # Gaming (host-specific games pushed via void's provides.to-users)
      den.aspects.steam
      den.aspects.mangohud

      # Communication
      den.aspects.email
      den.aspects.vesktop

      # IDE
      den.aspects.nixcats
    ];

    nixos = { ... }: {
      users.users.neonvoid = {
        description = "NeonVoid";
        extraGroups = [ "networkmanager" "audio" "video" "input" "libvirtd" ];
      };
    };
  };
}
```

> **Critical:** Den automatically applies the user aspect — do NOT add `den.aspects.neonvoid` to host includes. Adding it to both causes double application of all homeManager configs.

> **Rule:** Host includes = system-only aspects. User includes = all user-facing/desktop aspects. The `nixos` sections of user-included aspects still apply to the system.

> **Note:** `isNormalUser`, shell, and wheel group are handled automatically by `den._.define-user`, `den._.user-shell`, and `den._.primary-user` in `modules/den.nix`. The user `nixos` section only needs extra groups or overrides.

---

## den.nix — Defaults & HM Integration

`modules/den.nix` centralises shared configuration applied to every host:

- `den.default.nixos.system.stateVersion` and `den.default.homeManager.home.stateVersion` — set to `"26.11"`
- `den.ctx.hm-host.nixos.home-manager` — `useGlobalPkgs`, `useUserPackages`, `backupFileExtension`, `backupCommand`, and `sharedModules` (spicetify-nix, nix-index-database, noctalia)
- `den.default.includes` — `den._.home-manager`, `den._.define-user`, `den._.primary-user`, `den._.user-shell "zsh"`, `den._.inputs'`, `den._.self'`, `den._.hostname`

---

## Key Inputs

> **flake.nix is auto-generated** by `flake-file`. Never edit it directly. To add or change an input, edit `modules/flake-inputs.nix` then run `nix run .#write-flake`. To update locked versions, run `nix flake update` as normal.

| Input | Purpose |
|-------|---------|
| `den` | Den framework (v0.16.0) — auto-generates nixosConfigurations, wires HM, provides context |
| `nixpkgs` | NixOS unstable |
| `home-manager` | User environment management |
| `hyprland` | Wayland compositor |
| `stylix` | System-wide theming (base16, GTK, Qt, fonts) |
| `sops-nix` | Secrets management (age encryption) |
| `noctalia` | Quickshell bar/launcher/lockscreen |
| `spicetify-nix` | Spotify theming |
| `nix-index-database` | Fast `nix-locate` lookups |
| `nix-versions` | Version tracking for nix commands |
| `nvim-config` | Neovim config (neonvoidx/nvim) |
| `scopebuddy` | ScopeBuddy driver |

---

## Conventions

- **Module file names**: kebab-case (`desktop-environment.nix`, `system-packages.nix`)
- **Aspect names**: match the file name (`den.aspects."desktop-environment"`)
- **Host names**: lowercase (`void`, `voidframe`)
- **User**: `neonvoid`
- **`_data/` directories**: hold split-out data excluded from import-tree (e.g., `hyprland/_data/keybindings.nix`)
- **Host-specific conditionals**: use `host.attr or false` in the outer lambda, `osConfig.fileSystems ? "/games"` for filesystem checks in HM modules, or `config.networking.hostName == "void"` inside nixos modules
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

---

## Useful Commands

```bash
# Rebuild a host
sudo nixos-rebuild switch --flake .#void

# Update flake inputs
nix flake update

# Regenerate flake.nix after changing flake-inputs.nix
nix run .#write-flake

# Check which packages are available
nix search nixpkgs <package>

# Enter a dev shell with all inputs
nix develop
```
