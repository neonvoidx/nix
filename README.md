# The Void Hungers - Nix Configuration

A modular NixOS and Home Manager configuration using the **[Dendritic Pattern](https://github.com/mightyiam/dendritic)**, featuring cross-platform support (NixOS + macOS), secrets management via sops-nix, and Stylix theming.

## 🌳 Dendritic Pattern

This configuration follows the dendritic pattern where:

- **Every `.nix` file** under `./parts/` is a [flake-parts](https://flake.parts) module
- Files implement **single features** across all configurations
- Lower-level configs (NixOS, home-manager) are stored as **deferred modules**
- All modules are **automatically imported** using [import-tree](https://github.com/vic/import-tree)
- Values are shared through **top-level config** (not `specialArgs`)

### Benefits

✅ **Type consistency** - All files are flake-parts modules  
✅ **Automatic importing** - No manual module imports needed  
✅ **Feature-based organization** - Path names describe features, not file types  
✅ **Easy refactoring** - Files can be freely renamed, moved, or split  
✅ **Better sharing** - Values accessible through top-level config

## 🚀 Quick Start

### NixOS (System Configuration)

```bash
# Rebuild current system
sudo nixos-rebuild switch --flake .

# Rebuild specific host
sudo nixos-rebuild switch --flake .#void
sudo nixos-rebuild switch --flake .#voidframe

# Using justfile
just rebuild
```

### Home Manager on macOS

```bash
# Switch configuration for jrreed user
home-manager switch --flake .#jrreed

# Build without activating
home-manager build --flake .#jrreed
```

### Utility Commands

```bash
just update   # Update flake inputs
just history  # List system generations
just clean    # Clean generations older than 7 days
just gc       # Garbage collect old derivations
just repl     # Start Nix REPL
```

## 📁 Repository Structure

### `/flake.nix`

Main entry point using flake-parts. Declares inputs and automatically imports all modules from `./parts/`.

### `/parts/` ⭐ **Dendritic Modules**

Feature-based flake-parts modules (automatically imported):

- **`flake-parts.nix`** - Enables flake-parts.modules for deferredModule support
- **`systems.nix`** - Supported system architectures
- **`meta.nix`** - Top-level configuration options (usernames, etc.)
- **`nixos.nix`** - Infrastructure for NixOS configurations
- **`home-manager.nix`** - Infrastructure for standalone home-manager configs
- **`host-*.nix`** - Individual host configurations (void, voidframe)
- **`home-*.nix`** - Home manager configurations per user
- **Feature modules**:
  - `nixpkgs-config.nix` - Common nixpkgs settings
  - `nix-settings.nix` - Nix daemon configuration
  - `system.nix` - Core system modules
  - `hardware.nix` - Hardware configuration
  - `desktop.nix` - Desktop environment
  - `services.nix` - System services

### `/hosts/`

Host-specific hardware and configurations:

### `/hosts/`

Host-specific hardware and configurations:

- **`void/`** - Primary workstation (hardware-configuration.nix, pipewire.nix)
- **`voidframe/`** - Secondary system/laptop (hardware-configuration.nix)
- ~~**`common.nix`**~~ - ⚠️ **Deprecated** (functionality moved to parts/)

### `/modules/`

⚠️ **Legacy modules** (imported by parts/, will be migrated):

- **`desktop/`** - Desktop environment configurations
- **`hardware/`** - Hardware-specific settings
- **`packages/`** - System packages
- **`programs/`** - Custom program derivations (scopebuddy, hyprshutdown, noctalia)
- **`services/`** - System services
- **`system/`** - Core system settings
- **`sops.nix`**, **`stylix.nix`** - Secrets and theming

### `/home/`

Home Manager user configurations:

- **`neonvoid/`** - Linux user configuration
  - `home.nix` - Main entry point
  - `packages.nix` - User packages (consolidated with common packages)
  - `git.nix` - Git & GitHub CLI config
  - `files.nix` - File management & SSH keys
- **`jrreed/`** - macOS user configuration
- **`common.nix`** - Shared cross-platform settings
- **`configs/`** - Application dotfiles & configs
  - `common/` - Platform-independent configs (~60 files: nvim, kitty, zsh, etc.)
  - `linux/` - Linux-only configs (~35 files: Hyprland, audio, gaming)
  - `mac/` - macOS configs

### `/secrets/`

SOPS-encrypted secrets with age encryption:

- **`secrets.yaml`** - Encrypted secrets file
- **`README.md`** - Detailed setup instructions
- **`.sops.yaml`** - SOPS configuration (in repo root)

### `/assets/`

Static files and resources referenced by configurations

## 🏗️ Architecture

### Configuration Flow

```
flake.nix (flake-parts entry point)
    ↓
./parts/* (auto-imported via import-tree)
    ↓
Flake outputs: nixosConfigurations.{void,voidframe}
               homeConfigurations.{jrreed}
```

### How It Works

1. **flake.nix** uses flake-parts to set up the top-level configuration
2. **import-tree** automatically imports all `.nix` files from `./parts/`
3. Each part declares:
   - Options (via `options.*`)
   - Module storage (via `flake.modules.nixos.*` or `flake.modules.home.*`)
   - Configurations (via `configurations.nixos.*` or `configurations.home.*`)
4. Infrastructure modules (`nixos.nix`, `home-manager.nix`) convert configurations to flake outputs

### Adding a New Feature

Simply create a new `.nix` file in `./parts/` - it will be automatically imported!

```nix
# parts/new-feature.nix
{ config, ... }:
{
  flake.modules.nixos.my-feature = { pkgs, ... }: {
    # Your NixOS module here
  };
}
```

Then reference it in host configurations:

```nix
# parts/host-void.nix
imports = [ nixos.my-feature ];
```

## 📚 Additional Files

### Initial Setup

1. **Generate age key from your SSH key:**

```bash
# Generate age public key
nix-shell -p ssh-to-age --run 'ssh-to-age < ~/.ssh/id_ed25519.pub'

# Generate private age key
mkdir -p ~/.config/sops/age
nix-shell -p ssh-to-age --run 'ssh-to-age -private-key -i ~/.ssh/id_ed25519 > ~/.config/sops/age/keys.txt'
chmod 600 ~/.config/sops/age/keys.txt
```

2. **Update `.sops.yaml` with your age public key** (replace the existing key)

3. **Create/edit secrets file:**

```bash
# Edit encrypted secrets
nix-shell -p sops --run 'sops secrets/secrets.yaml'
```

4. **Rebuild system to apply secrets**

### Managing Secrets

```bash
# Edit existing secrets
nix-shell -p sops --run 'sops secrets/secrets.yaml'

# Secrets are automatically decrypted to /run/secrets/ at boot
```

**Note**: Secrets are encrypted with your age key derived from your SSH key. Keep `~/.ssh/id_ed25519` backed up! See `secrets/README.md` for recovery options.

## 📚 Additional Files

- **`.justfile`** - Task runner with common commands
- **`TODO.md`** - Planned improvements
- **`flake.lock`** - Locked dependency versions
- **`flake.nix.old`** - Previous non-dendritic configuration (backup)

## 🔐 SOPS Secrets Management
