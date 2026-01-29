# The Void Hungers - Nix Configuration

A modular NixOS and Home Manager flake configuration featuring secrets management via sops-nix and Stylix theming.

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

Main entry point defining:

- **NixOS Hosts**: `void`, `voidframe`
- **Flake Inputs**: nixpkgs, home-manager, sops-nix, stylix, nixvim, spicetify-nix, noctalia, and more

### `/hosts/`

NixOS system configurations:

- **`common.nix`** - Shared base configuration for all hosts
- **`void/`** - Primary workstation
- **`voidframe/`** - Secondary system

### `/modules/`

System-level NixOS modules organized by category:

- **`desktop/`** - Desktop environment & window manager configs
- **`hardware/`** - Hardware-specific configurations
- **`packages/`** - Package management & overlays
- **`programs/`** - System-wide program configurations
- **`services/`** - System services
- **`system/`** - Core system settings

### `/home/`

Home Manager user configurations:

- **`neonvoid/`** - User configuration
- **`common.nix`** - Base Home Manager settings
- **`configs/`** - Application dotfiles & configs

### `/secrets/`

SOPS-encrypted secrets with age encryption:

- **`secrets.yaml`** - Encrypted secrets file
- **`README.md`** - Detailed setup instructions
- **`.sops.yaml`** - SOPS configuration (in repo root)

### `/assets/`

Static files and resources referenced by configurations

## 🔐 SOPS Secrets Management

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
