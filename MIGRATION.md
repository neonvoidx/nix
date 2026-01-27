# Migration to Dendritic Pattern

This document explains the migration from the traditional flake structure to the dendritic pattern.

## What Changed

### Before (Traditional Structure)
- Manual imports in `flake.nix`
- Separate `hosts/common.nix` for shared configuration
- Values passed via `specialArgs` and `extraSpecialArgs`
- Mix of direct NixOS modules and flake outputs

### After (Dendritic Pattern)
- Automatic imports via `import-tree`
- All files in `./parts/` are flake-parts modules
- Values accessible through top-level `config`
- Lower-level configs stored as deferred modules
- Feature-based file organization

## New Directory Structure

```
nix/
├── flake.nix              # Flake-parts entry point
├── flake.nix.old          # Backup of old configuration
├── parts/                 # ⭐ NEW: Auto-imported flake-parts modules
│   ├── flake-parts.nix    # Enable flake-parts.modules
│   ├── systems.nix        # Supported architectures
│   ├── meta.nix           # Top-level options (usernames)
│   ├── nixos.nix          # NixOS configuration infrastructure
│   ├── home-manager.nix   # Home-manager configuration infrastructure
│   ├── host-*.nix         # Individual host configurations
│   ├── home-*.nix         # Home-manager configurations
│   └── *.nix              # Feature modules (system, desktop, services, etc.)
├── hosts/                 # Host-specific files
│   ├── void/              # Hardware configs only now
│   └── voidframe/         # Hardware configs only now
├── modules/               # Legacy modules (still used, imported by parts/)
├── home/                  # Home-manager configurations
└── ...
```

## Key Concepts

### 1. Flake-Parts Modules

Every file in `./parts/` is a flake-parts module:

```nix
# parts/my-feature.nix
{ config, ... }:
{
  # Can define options
  options.myOption = lib.mkOption { ... };
  
  # Can store reusable modules
  flake.modules.nixos.my-feature = { pkgs, ... }: {
    # NixOS module content
  };
  
  # Can declare configurations
  configurations.nixos.myhost = {
    hostname = "myhost";
    module = { ... };
  };
}
```

### 2. Deferred Modules

Lower-level configurations (NixOS, home-manager) are stored as `deferredModule` types:

```nix
flake.modules.nixos.my-module = { pkgs, ... }: {
  # This gets evaluated later when building the NixOS system
};
```

### 3. Top-Level Config

Instead of passing values through `specialArgs`, define them at the top level:

```nix
# parts/meta.nix
{ lib, ... }:
{
  options.username = lib.mkOption {
    type = lib.types.str;
    default = "neonvoid";
  };
}

# parts/some-feature.nix
{ config, ... }:
{
  # Access via config.username
  flake.modules.nixos.some-feature = {
    users.users.${config.username} = { ... };
  };
}
```

### 4. Automatic Imports

No more manual `imports = [ ... ]` lists! Files are automatically imported:

```nix
# flake.nix
outputs = inputs:
  inputs.flake-parts.lib.mkFlake { inherit inputs; }
    (inputs.import-tree ./parts);
```

## Adding New Features

### Old Way (Traditional)
1. Create module file
2. Add to `imports` list in relevant host
3. Pass needed values via `specialArgs`
4. Hope you didn't miss anything

### New Way (Dendritic)
1. Create file in `./parts/`
2. Done! (It's automatically imported)

Example:

```nix
# parts/docker.nix
{ config, ... }:
{
  flake.modules.nixos.docker = { pkgs, ... }: {
    virtualisation.docker = {
      enable = true;
      enableOnBoot = true;
    };
    users.users.${config.username}.extraGroups = [ "docker" ];
  };
}
```

Then use it in a host:

```nix
# parts/host-void.nix
{ config, ... }:
let
  inherit (config.flake.modules) nixos;
in
{
  configurations.nixos.void.module = {
    imports = [
      nixos.docker  # Just reference it!
    ];
  };
}
```

## Benefits Achieved

✅ **Less boilerplate** - No manual imports  
✅ **Better organization** - Files named by feature  
✅ **Easier refactoring** - Move/rename files freely  
✅ **Type safety** - All files are the same type  
✅ **Simpler sharing** - Values via top-level config  
✅ **Automatic discovery** - New files auto-imported  

## Migration Checklist

- [x] Install flake-parts and import-tree
- [x] Create `./parts/` directory structure
- [x] Convert hosts to deferred modules
- [x] Convert home-manager configs to deferred modules
- [x] Remove `specialArgs` usage
- [x] Remove manual imports where possible
- [x] Test configurations build
- [x] Update documentation

## Rollback

If needed, restore the old configuration:

```bash
cd /path/to/nix
mv flake.nix flake.nix.dendritic
mv flake.nix.old flake.nix
git restore hosts/common.nix home/packages.nix
```

## Resources

- [Dendritic Pattern](https://github.com/mightyiam/dendritic)
- [Dendritic Example](https://github.com/mightyiam/dendritic/tree/master/example)
- [flake-parts](https://flake.parts)
- [import-tree](https://github.com/vic/import-tree)
- [Nixpkgs Module System](https://nix.dev/tutorials/module-system/)
