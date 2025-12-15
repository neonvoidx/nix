# Nix Configuration Structure

This repository contains a modular NixOS and Home Manager configuration with flakes.

## Directory Structure

### `/flake.nix`

The main flake configuration that defines:

- Input sources (nixpkgs, home-manager, etc.)
- NixOS configurations for hosts
- Standalone Home Manager configurations

### `/hosts/`

Host-specific NixOS configurations:

- `common.nix` - Shared configuration imported by all hosts
- `void/` - Configuration for the "void" host
- `voidframe/` - Configuration for the "voidframe" host

### `/modules/`

System-level modules organized by category:

#### `/modules/system/`

Core system configuration:

- `boot.nix` - Boot loader and Plymouth configuration
- `nix.nix` - Nix daemon settings, garbage collection, and flakes
- `users.nix` - User account configuration
- `overlays.nix` - Nixpkgs overlays (NUR, etc.)
- `systemd.nix` - Systemd services and activation scripts
- `locale.nix` - Internationalization, console, and timezone
- `networking.nix` - Network settings

#### `/modules/hardware/`

- `default.nix` - Hardware configuration (CPU, Bluetooth, etc.)

#### `/modules/desktop/`

Desktop environment configuration:

- `fonts.nix` - System fonts
- `environment.nix` - Environment variables
- `xdg.nix` - XDG portal configuration
- `programs.nix` - Desktop programs (Hyprland, Steam, etc.)

#### `/modules/services/`

System services:

- `desktop.nix` - Desktop-related services (udisks, flatpak, printing, etc.)
- `xserver-udev.nix` - X server and udev rules
- `greetd.nix` - Login manager configuration
- `pipewire.nix` - Audio server configuration
- `network-drives.nix` - Network drive mounting

#### `/modules/packages/`

- `system.nix` - System-wide packages

#### `/modules/programs/`

Custom program packages:

- `noctalia.nix` - Noctalia shell package
- `scopebuddy.nix` - ScopeBuddy game launcher

### `/home/`

Home Manager configurations:

#### `/home/common.nix`

Base Home Manager configuration shared across all users

#### `/home/packages.nix`

Common user packages

#### `/home/neonvoid/`

User-specific configuration:

- `home.nix` - Main user configuration file (imports other modules)
- `packages.nix` - User-specific packages
- `git-config.nix` - Git user configuration
- `files.nix` - Home directory file symlinks

#### `/home/configs/common/`

Cross-platform Home Manager configurations:

- `default.nix` - Imports all common configs
- `bat.nix` - Bat (cat replacement) configuration
- `btop.nix` - Btop (system monitor) configuration
- `fastfetch.nix` - Fastfetch (system info) configuration
- `git.nix` - Git configuration
- `gtk.nix` - GTK theme configuration
- `kitty.nix` - Kitty terminal configuration
- `lsd.nix` - Lsd (ls replacement) configuration
- `nixcats/` - Neovim configuration via nixCats
- `yazi.nix` - Yazi (file manager) configuration
- `zsh.nix` - Zsh shell configuration

#### `/home/configs/linux/`

Linux-specific Home Manager configurations:

- `default.nix` - Imports all Linux configs
- `cava.nix` - Audio visualizer
- `easyeffects.nix` - Audio effects processor
- `email.nix` - Email client configuration
- `firefox.nix` - Firefox browser configuration
- `flatpak.nix` - Flatpak application overrides
- `gnome-keyring.nix` - GNOME Keyring configuration
- `hypridle.nix` - Hyprland idle daemon
- `hyprpolkitagent.nix` - Polkit authentication agent
- `mpv.nix` - MPV media player
- `noctalia.nix` - Noctalia shell configuration
- `pics.nix` - Image viewer configuration
- `spicetify.nix` - Spotify theming

#### `/home/configs/linux/hyprland/`

Modular Hyprland window manager configuration:

- `default.nix` - Main file that imports all Hyprland modules
- `environment.nix` - Environment variables
- `monitors.nix` - Monitor and workspace configuration
- `keybindings.nix` - Keyboard shortcuts and bindings
- `window-rules.nix` - Window and layer rules
- `settings.nix` - General settings (animations, layouts, decorations, etc.)
- `startup.nix` - Autostart applications and submaps

## Key Features

### Modular Design

- Each file focuses on a single purpose
- Easy to find and modify specific configurations
- Minimal interdependencies

### Clear Organization

- Folder names indicate content (system, desktop, services, etc.)
- File names are descriptive and self-documenting
- Logical grouping by functionality

### Separation of Concerns

- System configuration (NixOS) separate from user configuration (Home Manager)
- Common configuration separate from host-specific
- Platform-specific configs clearly separated (linux vs darwin)

## Usage

### Building a NixOS Configuration

```bash
sudo nixos-rebuild switch --flake .#void
```

### Building Standalone Home Manager Configuration

```bash
home-manager switch --flake .#neonvoid
```

# Just commands

- just commands for ease of use are in `.justfile`, i.e. rebuilding, wiping history, repl, flake update
