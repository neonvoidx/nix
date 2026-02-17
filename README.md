# NixOS Configuration

My NixOS configuration using the [dendritic pattern](https://github.com/mightyiam/dendritic) with [flake-parts](https://flake.parts/).

## Structure

```
├── flake.nix              # Flake entry point
├── modules/
│   ├── lib.nix            # Helper functions (mkNixos)
│   ├── system/            # System aspects (boot, networking, locale, etc.)
│   ├── services/          # Service aspects (pipewire, greetd, etc.)
│   ├── desktop/           # Desktop aspects (fonts, xdg, programs)
│   ├── hardware/          # Hardware configuration aspects
│   ├── programs/          # Program aspects (system packages)
│   ├── nix/               # Nix settings and overlays
│   ├── home/              # Home-Manager aspects
│   │   ├── common.nix     # Base HM config
│   │   ├── packages.nix   # User packages
│   │   ├── git.nix        # Git config
│   │   ├── files.nix      # Dotfiles and secrets
│   │   └── configs/       # Program configs (45 files)
│   ├── hosts/             # Host collector aspects
│   │   ├── void/          # Desktop configuration
│   │   └── voidframe/     # Laptop configuration
│   └── users/             # User aspects
│       └── neonvoid/      # User definition (system + HM)
└── secrets/               # SOPS encrypted secrets
```

## Hosts

- **void** - Main desktop (AMD Ryzen 9 9950X, RX 9070 XT)
- **voidframe** - Framework laptop (AMD Ryzen 7 7840U)

## Key Features

- **Dendritic Pattern** - Modular aspect-based configuration
- **Home-Manager** - Full user environment management
- **Hyprland** - Wayland compositor with custom configuration
- **Stylix** - System-wide theming
- **SOPS** - Encrypted secrets management
- **Noctalia Shell** - Quickshell bar, launcher, lock screen

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

### Update

```bash
nix flake update
```

### Utility Commands

```bash
just # short for just rebuild, rebuilds system
just update   # Update flake inputs
just clean    # Clean old generations
just search # search for nixpkgs
just run args... # runs a package with the args
just shell pkg # drops you into a shell with that pkg available
just history
just check
just boot # rebuilds with reboot
```

## Dendritic Pattern

Each feature is defined as an **aspect** in its own file:

```nix
{ ... }:
{
  flake.modules.nixos.feature-name = { pkgs, ... }: {
    # NixOS configuration
  };
}
```

**Host collectors** import aspects they need:

```nix
imports = with inputs.self.modules.nixos; [
  boot networking pipewire fonts # etc
];
```

**Benefits:**

- Modular and reusable
- No relative path imports
- Clear dependency structure
- Easy to enable/disable features

## SOPS Secrets

See [secrets/README.md](./secrets/README.md) for setup instructions.

Secrets are encrypted with age keys derived from SSH keys and decrypted to `/run/secrets/` at boot.

## Adding New Modules

### System Module

1. Create `modules/category/my-feature.nix`:
```nix
{ ... }:
{
  flake.modules.nixos.my-feature = { pkgs, ... }: {
    services.myservice.enable = true;
    environment.systemPackages = [ pkgs.mypackage ];
  };
}
```

2. Add to host in `modules/hosts/yourhost/default.nix`:
```nix
imports = [
  m.my-feature  # Just add the module name
];
```

### Home-Manager Module

1. Create `modules/home/configs/my-program.nix`:
```nix
{ ... }:
{
  flake.modules.homeManager.my-program = { pkgs, ... }: {
    programs.myprogram = {
      enable = true;
      # configuration here
    };
  };
}
```

2. Add to user in `modules/users/username/default.nix`:
```nix
flake.modules.homeManager.username = {
  imports = [
    self.modules.homeManager.my-program
  ];
};
```

The dendritic pattern auto-discovers modules via `import-tree`.
