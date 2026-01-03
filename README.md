# The Void Hungers - Nix Configuration

A comprehensive, modular NixOS and Home Manager configuration with flakes, featuring cross-platform support (NixOS + macOS).

## 🚀 Quick Start

### NixOS System Rebuild

```bash
just rebuild  # or: sudo nixos-rebuild switch --flake . --impure
```

### Standalone Home Manager (macOS - jrreed user)

```bash
home-manager switch --flake .#jrreed
```

### Other Commands

```bash
just update   # Update flake inputs
just history  # List system generations
just clean    # Clean generations older than 7 days
just gc       # Garbage collect old derivations
just repl     # Start Nix REPL
```

## 📁 Repository Structure

### `/flake.nix` - Main Configuration

Orchestrates the entire configuration with the following inputs:

- **nixpkgs** - NixOS unstable channel
- **home-manager** - User environment management
- **noctalia** - Custom shell interface
- **spicetify-nix** - Spotify theming framework
- **nur** - Nix User Repository overlay
- **nix-search-tv** - Terminal UI for searching Nix packages
- **nixvim** - Neovim configuration framework
- **nix-colors** - Color scheme framework
- **sops-nix** - Secrets management
- **nix-index-database** - Pre-built nix-index database

Defines two NixOS configurations (`void`, `voidframe`) and standalone Home Manager for macOS (jrreed user).

### `/hosts/` - System Configurations

Host-specific NixOS configurations with hardware profiles:

- **`common.nix`** - Shared base configuration imported by all hosts
- **`void/`** - Primary workstation configuration
  - `default.nix` - Host-specific settings
  - `hardware-configuration.nix` - Hardware detection output
  - `pipewire.nix` - Audio configuration overrides
- **`voidframe/`** - Secondary system configuration
  - `default.nix` - Host-specific settings

### `/modules/` - System-Level Modules

Organized system configuration split by concern:

#### `/modules/system/` - Core System

- **`boot.nix`** - Bootloader (systemd-boot), Plymouth splash, kernel parameters
- **`nix.nix`** - Nix daemon, flakes, garbage collection, experimental features
- **`users.nix`** - User accounts and group memberships
- **`overlays.nix`** - Nixpkgs overlays (NUR, custom packages)
- **`systemd.nix`** - Systemd services and system activation scripts
- **`locale.nix`** - Locale, timezone, console keyboard layout
- **`networking.nix`** - NetworkManager, firewall, hostname

#### `/modules/hardware/` - Hardware Support

- **`default.nix`** - CPU microcode, Bluetooth, hardware acceleration

#### `/modules/desktop/` - Desktop Environment

- **`fonts.nix`** - System font packages and fontconfig
- **`environment.nix`** - System-wide environment variables
- **`xdg.nix`** - XDG portals for desktop integration
- **`programs.nix`** - Desktop programs (Hyprland, Steam, gamemode, etc.)

#### `/modules/services/` - System Services

- **`desktop.nix`** - Desktop services (udisks, flatpak, CUPS printing, etc.)
- **`xserver.nix`** - X server configuration
- **`udev.nix`** - Udev rules for hardware
- **`greetd.nix`** - Login manager (greetd + tuigreet)
- **`pipewire.nix`** - Audio server with PulseAudio/JACK compatibility
- **`network-drives.nix`** - Automounting network shares

#### `/modules/packages/` - Package Lists

- **`system.nix`** - System-wide package installations

#### `/modules/programs/` - Custom Program Builds

- **`noctalia.nix`** - Noctalia shell package derivation
- **`scopebuddy.nix`** - ScopeBuddy game launcher package
- **`hyprshutdown.nix`** - Graceful shutdown utility for Hyprland

#### `/modules/` - Secrets

- **`sops.nix`** - SOPS-nix secrets configuration (email passwords)

### `/home/` - Home Manager Configurations

User environment management split into platform-specific configs:

#### User Directories

- **`/home/common.nix`** - Base Home Manager setup shared by all users
- **`/home/packages.nix`** - Common user packages across all configurations
- **`/home/neonvoid/`** - Primary user configuration (Linux only)
  - `home.nix` - Linux configuration entry point
  - `nixos.nix` - NixOS module integration
  - `packages.nix` - User-specific packages
  - `git.nix` - Git user identity
  - `files.nix` - Home directory file symlinks
- **`/home/jrreed/`** - Secondary user (macOS work profile)
  - `home.nix` - macOS configuration for work account

#### `/home/configs/common/` - Cross-Platform Configurations

Shared configurations that work on both NixOS and macOS:

- **`default.nix`** - Imports all common modules
- **`colors.nix`** - Nix-colors theme configuration
- **`bat.nix`** - Syntax-highlighted cat replacement
- **`btop.nix`** - Resource monitor
- **`direnv.nix`** - Per-directory environment variables
- **`fastfetch.nix`** - System information display
- **`fzf.nix`** - Fuzzy finder
- **`git.nix`** - Git configuration (aliases, diff tools, etc.)
- **`jq.nix`** - JSON processor
- **`just.nix`** - Command runner configuration
- **`kitty.nix`** - GPU-accelerated terminal emulator
- **`lsd.nix`** - Modern ls replacement with icons
- **`payrespects.nix`** - Modern cd replacement
- **`tealdeer.nix`** - Fast tldr client
- **`tv.nix`** - Nix package search TUI
- **`yazi.nix`** - Terminal file manager
- **`zsh.nix`** - Shell configuration with plugins and themes

#### `/home/configs/common/nixvim/` - Neovim Configuration

Comprehensive Neovim setup using nixvim (30+ plugin configurations):

- **`default.nix`** - Main nixvim configuration entry point
- **`opts.nix`** - Neovim options (line numbers, tabs, etc.)
- **`keymaps.nix`** - Custom key mappings
- **`plugins/`** - Modular plugin configurations:
  - `default.nix` - Imports all plugin modules
  - `ai.nix` - AI-powered coding assistance
  - `alt-themes.nix` - Alternative color schemes
  - `blink.nix` - Completion engine
  - `bufferline.nix` - Buffer/tab line
  - `comments.nix` - Comment toggling
  - `diagnostics.nix` - LSP diagnostics UI
  - `diffview.nix` - Git diff viewer
  - `eldritch.nix` - Primary color theme
  - `flash.nix` - Fast navigation
  - `folds.nix` - Code folding
  - `format.nix` - Code formatting (conform.nvim)
  - `git.nix` - Git integration (gitsigns)
  - `guess-indent.nix` - Automatic indentation detection
  - `helpview.nix` - Better help pages
  - `highlight-colors.nix` - Color code highlighting
  - `hmts.nix` - Treesitter-based context
  - `inc-rename.nix` - LSP rename preview
  - `kitty.nix` - Kitty terminal integration
  - `lint.nix` - Linting (nvim-lint)
  - `lsp.nix` - Language Server Protocol setup
  - `lualine.nix` - Status line
  - `markdown.nix` - Markdown rendering
  - `mini.nix` - Mini.nvim modules collection
  - `noice.nix` - Enhanced UI (messages, cmdline, popupmenu)
  - `numb.nix` - Line number peek
  - `overseer.nix` - Task runner
  - `quickfix.nix` - Enhanced quickfix window
  - `session.nix` - Session management
  - `snacks.nix` - Snacks.nvim utilities
  - `snippets.nix` - Snippet engine
  - `treesitter.nix` - Syntax highlighting
  - `whichkey.nix` - Key binding help
  - `yanky.nix` - Yank history management
  - `yazi.nix` - File manager integration

#### `/home/configs/linux/` - Linux-Specific Configurations

NixOS-only configurations:

- **`default.nix`** - Imports all Linux modules
- **`cava.nix`** - Console audio visualizer
- **`easyeffects.nix`** - Audio effects pipeline
- **`email.nix`** - Email client setup (Thunderbird with SOPS secrets)
- **`firefox.nix`** - Firefox browser configuration
- **`flatpak.nix`** - Flatpak application overrides
- **`gnome-keyring.nix`** - Keyring daemon for secrets
- **`gtk.nix`** - GTK theme and icon theme
- **`hypridle.nix`** - Idle management for Hyprland
- **`hyprpolkitagent.nix`** - Polkit authentication agent
- **`mpv.nix`** - Video player configuration
- **`noctalia.nix`** - Noctalia shell user configuration
- **`pics.nix`** - Image viewer configuration
- **`spicetify.nix`** - Spotify theming with Spicetify

#### `/home/configs/linux/hyprland/` - Hyprland Configuration

Complete Wayland compositor setup:

- **`default.nix`** - Main configuration entry point
- **`environment.nix`** - Hyprland-specific environment variables
- **`monitors.nix`** - Monitor layout and workspace assignments
- **`keybindings.nix`** - Keyboard shortcuts and mouse bindings
- **`windowrules.nix`** - Window rules, layer rules, opacity rules
- **`settings.nix`** - General settings (animations, decorations, input, gestures)
- **`startup.nix`** - Autostart applications, exec-once commands

#### `/home/configs/mac/` - macOS-Specific Configurations

- **`default.nix`** - Placeholder for future macOS-specific configs

### `/assets/` - Static Configuration Files

Binary and text assets symlinked into home directories:

#### `/assets/common/` - Cross-Platform Assets

- **`nvim/snippets/`** - Custom code snippets for Neovim
- **`kitty/`** - Additional Kitty terminal assets

#### `/assets/linux/` - Linux-Only Assets

- **`.face`** - User avatar for display managers
- **`neonvoid.png`** - User profile image
- **`scripts/`** - Shell scripts
  - `toggle-monitor.sh` - Monitor switching script
- **`hypr/`** - Hyprland-related files
  - `hyprlock.conf` - Screen locker configuration (not used atm)
  - `xdph.conf` - XDG desktop portal Hyprland config
  - `scripts/` - Hyprland automation scripts
    - `wait-for-vesktop-and-move.sh` - Workspace automation
    - `screen-toggle.sh` - Display switching
    - `gamescreen-toggle.sh` - Gaming display profile
  - `hyprland/monitors/` - Monitor profile configurations
    - `monitors.conf` - Default monitor layout
    - `monitors-notouch.conf` - Layout without touchscreen
    - `monitors-work.conf` - Work monitor setup
    - `monitors-work-notouch.conf` - Work setup without touchscreen
  - `hyprlock/` - Lock screen assets
    - `avatar.png` - Lock screen user image
    - `spotify.sh` - Display current Spotify track on lock screen
- **`easyeffects/autoload/`** - Audio effect presets
  - `equalizerrc` - EQ settings
  - `easyeffectsrc` - Main effects configuration
  - `speexrc` - Speex processor settings
  - `microphone.json` - Microphone effects chain
- **`scopebuddy/`** - Game launcher configurations
  - `scb.conf` - Main ScopeBuddy config
  - `noscope.conf` - Alternative configuration
  - `AppID/` - Per-game configurations
    - Various `.conf` files for different games (Dota 2, Heroes of the Storm, Warframe, etc.)

#### `/assets/mac/` - macOS Assets

- **`darwin.png`** - macOS user profile image

### `/secrets/` - Secrets Management

Encrypted secrets using SOPS:

- **`README.md`** - Complete guide for setting up and managing secrets
- **`secrets.yaml`** - Encrypted secrets file (email passwords)
- **`setup.sh`** - Helper script for initial secrets setup
- **`.sops.yaml`** - SOPS configuration (age keys) in repository root

## 🔑 Key Features

### 🧩 Modular Architecture

- Single-purpose files for easy modification
- Clear separation of concerns
- Minimal coupling between modules
- Easy to add/remove features

### 📂 Organized Structure

- Intuitive folder hierarchy
- Self-documenting file names
- Logical grouping by function and platform

### 🔒 Secrets Management

- SOPS-nix integration for encrypted secrets
- Age encryption based on SSH keys
- Automatic decryption at boot/activation
- Secure email password storage

### 🖥️ Multi-Platform Support

- **NixOS**: Full system configuration with Home Manager integration
- **macOS**: Standalone Home Manager configuration
- Shared configs for cross-platform tools
- Platform-specific overrides where needed

### 🎨 Desktop Environment

- Hyprland Wayland compositor with complete configuration
- Multiple monitor profile support
- Comprehensive keybindings and window rules
- Gaming optimizations (Steam, MangoHud, gamemode)

### 📝 Development Environment

- Fully-configured Neovim with 30+ plugins
- LSP support for multiple languages
- Git integration with visual diff tools
- Modern CLI tools (bat, lsd, yazi, fzf, etc.)

## 🛠️ Usage Examples

### Building Specific Hosts

```bash
# Build and activate void configuration
sudo nixos-rebuild switch --flake .#void

# Build and activate voidframe configuration
sudo nixos-rebuild switch --flake .#voidframe
```

### Managing Secrets

```bash
# Edit encrypted secrets
nix-shell -p sops --run 'sops secrets/secrets.yaml'

# Initial setup (see secrets/README.md for full guide)
nix-shell -p ssh-to-age --run 'ssh-to-age < ~/.ssh/id_ed25519.pub'
```

### Home Manager Standalone (macOS - jrreed)

```bash
# Switch to new configuration
home-manager switch --flake .#jrreed

# Build without activation
home-manager build --flake .#jrreed
```

## 📚 Additional Resources

- **`.justfile`** - Task runner with common commands
- **`TODO.md`** - Planned features and improvements
- **`flake.lock`** - Locked flake input versions
- **`.gitignore`** - Git exclusions
