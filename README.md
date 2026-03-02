# NixOS Configuration

My NixOS configuration using the [den](https://github.com/vic/den) framework with [flake-parts](https://flake.parts/) and [import-tree](https://github.com/vic/import-tree).

## Structure

```
├── flake.nix              # Single-line entry point — import-tree discovers everything
├── hosts/                 # Hardware-generated configs (nixos-generate-config)
│   ├── void/hardware-configuration.nix
│   └── voidframe/hardware-configuration.nix
├── modules/
│   ├── dendritic.nix      # Bootstraps den into flake-parts
│   ├── hosts.nix          # Declares hosts and their attributes
│   ├── home-manager.nix   # HM integration (sharedModules, useGlobalPkgs)
│   ├── state-versions.nix # NixOS + HM stateVersion
│   ├── system/            # OS-level aspects (boot, locale, networking, systemd)
│   ├── hardware/          # Hardware aspects (firmware, bluetooth, kernel, udev, streamcontroller)
│   ├── security/          # Security aspects (sops, pcscd, gnome-keyring, greetd)
│   ├── desktop/           # Desktop aspects (hyprland, stylix, noctalia, flatpak, fonts, …)
│   ├── shell/             # Shell aspects (zsh, bat, git, kitty, yazi, …)
│   ├── gaming/            # Gaming aspects (steam, mangohud, curseforge)
│   ├── media/             # Media aspects (mpv, obs, spicetify, ananicy, …)
│   ├── communication/     # Communication aspects (vesktop, email)
│   ├── ide/               # Editor aspects (nixcats)
│   ├── nix/               # Nix daemon settings and overlays
│   ├── hosts/             # Host aspect definitions (one file per host)
│   │   ├── void/default.nix       # void host aspect + system-only includes
│   │   └── voidframe/default.nix  # voidframe host aspect + system-only includes
│   └── users/
│       └── neonvoid/neonvoid.nix  # User aspect — all desktop/shell/app includes
└── secrets/               # SOPS age-encrypted secrets
```

## Hosts

| Host | Hardware | Role | Attributes |
|------|----------|------|------------|
| **void** | AMD Ryzen 9 9950X, RX 9070 XT | Desktop | `isGaming=true`, `isMultiMonitor=true` |
| **voidframe** | AMD Ryzen 7 7840U, Framework 16 | Laptop | `isLaptop=true` |

## Key Features

- **den Framework** — auto-generates `nixosConfigurations`, wires Home-Manager, provides `host`/`user` context
- **import-tree** — all `.nix` files under `modules/` are auto-discovered; no manual wiring needed
- **Aspect Pattern** — every feature is a self-contained file with optional `nixos` and `homeManager` sections
- **Host Context** — freeform attributes on hosts (`isGaming`, `isLaptop`, `xRes`, etc.) accessible in any aspect
- **User Context** — user attributes (`userName`, `homeDirectory`) accessible in any aspect
- **Hyprland** — Wayland compositor, fully configured in `desktop/hypr/hyprland.nix`
- **Stylix** — System-wide theming (NixOS + HM in one aspect file)
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

## Den Framework Pattern

Each feature is a self-contained **aspect** file. NixOS and Home-Manager config for the same program live together:

```nix
# modules/audio/pipewire.nix
{ den, ... }:
{
  den.aspects.pipewire = {
    nixos = { pkgs, ... }: {
      services.pipewire.enable = true;
    };

    homeManager = { ... }: {
      # user-level config if needed
    };
  };
}
```

To access **host or user context**, use the outer aspect lambda:

```nix
{ den, ... }:
{
  den.aspects.example =
    { host, user, ... }:
    {
      nixos = { pkgs, ... }: {
        # host.xRes, host.isGaming, host.isLaptop or false, etc.
        networking.hostName = host.hostName;
      };

      homeManager = { ... }: {
        # user.userName, user.homeDirectory, etc.
        home.file."example".text = "hello ${user.userName}";
      };
    };
}
```

> **Note:** `host` and `user` are only available in the **outer** aspect lambda, not inside `nixos`/`homeManager` module args. Capture them via Nix's lexical scoping (they are automatically in scope for inner lambdas).

> **Note:** Host attributes are freeform — use `host.isLaptop or false` when an attribute may not exist on all hosts.

## Adding a New Aspect

1. Create `modules/<category>/my-feature.nix` — import-tree picks it up automatically
2. Add `den.aspects.my-feature` to the user's includes in `modules/users/neonvoid/neonvoid.nix` (for user-facing features) or to the host's includes in `modules/hosts/<hostname>/default.nix` (for system-only features)
3. Rebuild

```nix
# modules/category/my-feature.nix
{ den, ... }:
{
  den.aspects.my-feature = {
    nixos = { pkgs, ... }: {
      services.myservice.enable = true;
    };

    homeManager = { pkgs, ... }: {
      programs.myservice.enable = true;
    };
  };
}
```

## Adding a New Host

1. Add the host to `modules/hosts.nix`:

```nix
den.hosts.x86_64-linux = {
  mynewhost = {
    xRes = "1920";
    yRes = "1080";
    isLaptop = true;          # freeform — any attributes you want
    users.neonvoid = {};
  };
};
```

1. Create `modules/hosts/mynewhost/default.nix`:

```nix
{ den, inputs, ... }:
{
  den.aspects.mynewhost = {
    includes = [
      # pick and choose aspects you want
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

    nixos = { lib, ... }: {
      imports = [ (inputs.self + "/hosts/mynewhost/hardware-configuration.nix") ];
      networking.hostName = "mynewhost";
      # boot, hardware, networking specifics...
    };
  };
}
```

1. Add `hosts/mynewhost/hardware-configuration.nix` (from `nixos-generate-config`).

That's it — den auto-generates the `nixosConfiguration` output from `hosts.nix`.

## Adding a New User

1. Create `modules/users/<username>/<username>.nix`:

```nix
{ den, ... }:
{
  den.aspects.<username> = {
    includes = [
      den.aspects.zsh
      den.aspects.git
      # ... all aspects this user should have, look at neonvoid for full list
    ];

    nixos = { pkgs, ... }: {
      users.users.<username> = {
        isNormalUser = true;
        shell = pkgs.zsh;
        extraGroups = [ "wheel" "audio" "video" "networkmanager" ];
      };
    };

    homeManager = { ... }: {
      home.stateVersion = "25.11";
    };
  };
}
```

1. Add the user to the host entry in `modules/hosts.nix`:

```nix
mynewhost = {
  users.<username> = {};
};
```

## SOPS Secrets

See [secrets/README.md](./secrets/README.md). Secrets are age-encrypted and decrypted to `/run/secrets/` at boot.
