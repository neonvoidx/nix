# NixOS Flake — Agent Instructions

This file provides context for any AI agent working with this NixOS flake configuration.

> **⚠️ AGENT SAFETY RULE: NEVER run `nixos-rebuild switch`, `sudo nixos-rebuild`, `nix run .#<host>`, or any command that activates/bootstraps a system configuration.** Validate with `nix flake check`, read-only `nix eval`, or the nix-agent MCP tools (`check`, `build`, `diff`, `eval_config`). Never use `check` with `dry-activate`. Input updates and `write-flake` generation are separate maintenance operations; neither activates a host. Breaking this rule can unexpectedly modify the host system.

---

## Den Framework Reference

For anything related to the den framework, **always consult**:

- **<https://github.com/denful/den/blob/v0.19.0/AGENTS.md>** — framework agent guide. Read the guide, documentation, and CI examples at the exact revision recorded in `flake.lock` before generating Den configuration. The old `vic/den/AGENTS_EXAMPLE.md` URL no longer exists.
- **<https://github.com/denful/den>** — source repository for looking up option definitions, battery implementations, CI test examples (`tree/main/templates/ci/modules/features/`), and documentation (`tree/main/docs/src/content/docs/`).

### Diagnosing Den Issues After a Flake Update

When a `nix flake update` causes unexpected package removals, evaluation errors, or broken behaviour related to Den:

1. **Check release notes first** — fetch `https://github.com/denful/den/releases` to find breaking changes between the old and new version. Den uses semantic versioning; API changes can require configuration updates; compare the locked revisions and release notes.
2. **Read the docs** — fetch `https://github.com/denful/den/tree/main/docs/src/content/docs/` to understand the current API before touching any aspect definitions. Do not assume the API is the same as in your training data.
3. **Cross-reference CI tests** — the canonical source of truth for working patterns is `https://github.com/denful/den/tree/main/templates/ci/modules/features/`. If a pattern isn't reflected in a passing CI test, treat it as unreliable.
4. **Prefer CI test patterns over templates or docs examples** — templates (e.g. `igloo.nix`) may be illustrative rather than exhaustively tested. Prefer passing tests at the locked revision when checking whether a pattern is supported.
5. **Do not deep-dive internal Nix source files until the docs and CI tests are exhausted** — start with documentation and tests; resort to reading `nix/lib/` source only if those don't resolve the issue.

---

This is a NixOS flake configuration for two hosts (`void`, `voidframe`) using the **den** framework with `flake-parts` and `import-tree`.

---

## Core Architecture

### Auto-Discovery via `import-tree`

All `.nix` files under `modules/` are automatically imported — **no manual import wiring is needed**. For Git-backed flake evaluation, stage new module files before evaluating; their aspects take effect when included by a host or user.

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
        # host.hostName, host.monitors, host.xRes, host.isMultiMonitor or false,
        # host.isLaptop or false, host.isGaming or false, host.gpuPciDev, etc.
        systemd.services.greetd = lib.mkIf (host.isMultiMonitor or false) {
          preStart = "${pkgs.fbset}/bin/fbset -xres ${host.xRes} -yres ${host.yRes}";
        };
      };

      homeManager = { ... }: {
        # user.userName; home paths come from config.home.homeDirectory
        home.file."hello".text = "hello ${user.userName}";
      };
    };
}
```

> Den v0.19 supports both outer aspect lambdas and flat class modules such as `nixos = { host, pkgs, ... }: { ... };`. Prefer a flat class module for a single class. Keep outer lambdas when controlling conditional includes or user fan-out; requesting `user` inside a host-scope class module is not a general substitute for aspect-level fan-out.
> Use `host.attr or false` / `host.attr or ""` for attributes that may not exist on all hosts.

### Conditional Includes via `lib.optionals`

User aspects can conditionally include other aspects based on host context:

```nix
{ den, lib, ... }:
{
  den.aspects.example =
    { host, ... }:
    {
      includes = [
        # always included
        den.aspects.steam
        den.aspects.mangohud
      ]
      ++ lib.optionals (host.isGaming or false) [
        # only on gaming hosts
        den.aspects.deadlock
        den.aspects.wow
      ];
    };
}
```

---

## Directory Structure

```
├── .codex/config.toml     # Project-local Codex MCP servers
├── .github/workflows/    # Build and cache CI
├── .githooks/pre-commit  # Runs treefmt; enable via core.hooksPath
├── .sops.yaml            # SOPS age recipient configuration
├── AGENTS.md             # Repository guidance for agents
├── README.md             # Repository overview and usage
├── flake.nix             # Generated by flake-file; edit modules/flake-inputs.nix
├── flake.lock            # Locked flake inputs
├── treefmt.toml          # Tree-wide formatter configuration
├── hosts/                # Hardware-generated NixOS configurations
│   ├── void/hardware-configuration.nix
│   └── voidframe/hardware-configuration.nix
├── modules/              # Auto-discovered Nix modules
│   ├── den.nix           # Den defaults and Home Manager integration
│   ├── flake-inputs.nix  # Source of truth for flake inputs
│   ├── hosts.nix         # Host attributes and user assignments
│   ├── nh.nix            # Den/nh host build helpers
│   ├── communication/   # Discord and email
│   ├── desktop/         # Umbriel, shell UI, theming, Firefox and desktop tools
│   ├── gaming/          # Gaming bundle, Steam, MangoHud, ScopeBuddy and games
│   ├── hardware/        # Bluetooth, kernel, printing, StreamController and USB
│   ├── home/            # Shared Home Manager settings, files and packages
│   ├── hosts/           # Host aspects and system-specific settings
│   │   ├── void/default.nix
│   │   └── voidframe/default.nix
│   ├── ide/             # Neovim
│   ├── media/           # Audio, media applications, wallpapers
│   ├── nix/             # Nix settings, overlays and multiverse
│   ├── security/        # Secrets, authentication, greeters, polkit and WireGuard
│   ├── shell/           # Zsh, Starship, tmux, devenv, direnv and CLI tools
│   ├── system/          # Boot, locale, networking, packages and systemd
│   └── users/
│       └── neonvoid/neonvoid.nix  # User account settings and aspect includes
├── assets/               # Dotfiles, scripts, themes and application data
│   ├── ai/               # Shared AI commands
│   ├── easyeffects/      # Mutable audio application settings
│   ├── fonts/            # Local NeonMono font files
│   ├── kitty/            # Terminal scrollback helpers
│   ├── mozilla/          # Firefox styles and extension settings
│   ├── nix/caches.json   # Cache configuration shared with CI
│   ├── scopebuddy/       # Global and per-game launch settings
│   ├── scripts/          # Shared desktop scripts
│   └── umbriel/          # Umbriel scripts and shaders
└── secrets/              # Encrypted secrets, setup script and documentation
```

---

## Host Definitions

**`modules/hosts.nix`** declares all hosts with structured `monitors`, `audio`,
and `network` attributes. The following example is abridged; the file is the
source of truth for full monitor and device settings:

```nix
{ den, ... }:
let
  neonvoid = {
    gitName = "neonvoidx";
    gitEmail = "me@neonvoid.dev";
    avatar = ../assets/.face;
    logo = ../assets/neonvoid.png;
    wallpaperRepository = "https://github.com/neonvoidx/pics";
    # Full Home Manager email account records; see modules/hosts.nix.
    emailAccounts = { /* thundermail and gmail */ };
  };
  timezone = "America/New_York";
in
{
  den.hosts.x86_64-linux = {
    void = {
      users.neonvoid = neonvoid;

      monitors = {
        main = { name = "DP-2"; mode = "3440x1440@360.10"; scale = 1.0; primary = true; position = "4880x1440"; };
        secondary = { name = "DP-3"; mode = "3440x1440@143.92"; position = "4880x0"; };
        portrait = { name = "HDMI-A-1"; mode = "2560x1440@59.95"; transform = 1; position = "3440x727"; };
      };

      isMultiMonitor = true;
      xRes = "3440";
      yRes = "1440";
      gpuPciDev = "0000:03:00.0";
      gpuPciAudioDev = "0000:03:00.1";
      gpuVendorDeviceId = "1002:7550";

      audio = {
        disabledNodes = [ ]; # Omitted here; see modules/hosts.nix.
        defaultMic = "alsa_input.usb-...";
        defaultSpeaker = "alsa_output.usb-...";
        bluetoothCard = "bluez_card...";
      };

      network = {
        dns = [ "192.168.86.7" "192.168.86.8" ];
        interface = "eth0";
        mac = "9c:6b:00:98:96:96";
        ip = "192.168.86.20";
        prefixLength = 24;
        gateway = "192.168.86.1";
      };

      gamesLocation = "/games";
      gaming.environment = { /* host-specific Proton/GPU settings */ };
      printer = {
        name = "HP_Color_LaserJet_MFP_M182nw";
        location = "Home";
        deviceUri = "ipps://192.168.86.186/ipp/print";
        model = "everywhere";
        drivers = [ "hplipWithPlugin" "cups-filters" ];
        ppdOptions = { PageSize = "Letter"; ColorModel = "RGB"; };
      };
      greeting = "The Void";
      timezone = timezone;
      isGaming = true;
    };

    voidframe = {
      users.neonvoid = neonvoid;

      monitors.builtin = {
        name = "eDP-1"; mode = "2880x1920@120";
        scale = 1.33333; primary = true; position = "0x0";
      };

      isLaptop = true;
      xRes = "2880";
      yRes = "1920";
      network.wireless = true;
      greeting = "Void Frame";
      timezone = timezone;
      isGaming = false;
    };
  };
}
```

**`modules/hosts/<name>/default.nix`** — host aspect with shared system and host-specific bundle includes and hardware config:

```nix
{ den, inputs, ... }:
{
  den.aspects.void = {
    includes = [
      den.aspects.base-system
      den.aspects.wireguard
      den.aspects.gaming
    ];

    nixos = { lib, pkgs, config, ... }: {
      imports = [ (inputs.self + "/hosts/void/hardware-configuration.nix") ];
      # boot (limine with secure boot, amdgpu kernel modules, zen kernel, kernel params)
      # hardware.amdgpu, hardware.steam-hardware, static IP networking
    };
  };
}
```

`modules/system/base-system.nix` groups the system aspects shared by both hosts. Each host explicitly includes `den.aspects.base-system`; `void` adds WireGuard and gaming. Hardware and host-specific settings remain in each host module. The `void` host reads its static network settings from `host.network` in `modules/hosts.nix`, keeping DNS, IP, prefix length, gateway, interface, and MAC address in one place.

Den auto-generates `nixosConfigurations.void` from `hosts.nix` — no `flake-parts.nix` needed.

> **`provides.to-users`**: A host aspect can push additional includes or config to all of its users via `provides.to-users`. This is useful for host-specific features (e.g., gaming titles only relevant on the desktop) without polluting the shared user aspect. The provided value is an aspect, either an attrset or a context lambda.

**Hosts:**

- **`void`** — Desktop (AMD Ryzen 9 9950X, RX 9070 XT, 3x monitors: 2×3440×1440 + 2560×1440 portrait)
- **`voidframe`** — Framework laptop (AMD Ryzen 7 7840U, 2880×1920)

---

## User Definitions

**`modules/users/neonvoid/neonvoid.nix`** — user aspect with shared desktop, shell, and application includes. Gaming is selected by the desktop host:

```nix
{ den, ... }:
{
  den.aspects.neonvoid = {
    includes = [
      # Shell tools
      den.aspects.bat
      den.aspects.btop
      den.aspects.direnv
      den.aspects.devenv
      den.aspects.delta
      den.aspects.fastfetch
      den.aspects.fzf
      den.aspects.git
      den.aspects.kitty
      den.aspects.just
      den.aspects.lazygit
      den.aspects.lsd
      den.aspects.mcp
      den.aspects.nh
      den.aspects.nix-index
      den.aspects.nvim
      den.aspects.opencode
      den.aspects.pay-respects
      den.aspects.starship
      den.aspects.tealdeer
      den.aspects.tmux
      den.aspects.yazi
      den.aspects.zoxide
      den.aspects.zsh

      # Desktop
      den.aspects.desktop-environment
      den.aspects.fonts
      den.aspects.xdg
      den.aspects.stylix
      den.aspects.noctalia
      den.aspects.flatpak
      den.aspects.clipboard
      den.aspects.cursor
      den.aspects.firefox
      den.aspects.gtk
      den.aspects.umbriel
      den.aspects.thunar
      den.aspects.xembsni

      # Services (user-level)
      den.aspects.gnome-keyring
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
      den.aspects.obs-studio
      # Wallpaper repository comes from user.wallpaperRepository
      den.aspects.pics
      # den.aspects.spicetify
      den.aspects.youtube-music

      # Communication
      den.aspects.discord
      den.aspects.email
    ];

    nixos = {
      users.users.neonvoid = {
        description = "neonvoid";
        extraGroups = [
          "networkmanager"
          "audio"
          "video"
          "input"
          "libvirtd"
          "dialout"
        ];
      };
    };
  };
}
```

> **Critical:** Den automatically applies the user aspect — do NOT add `den.aspects.neonvoid` to host includes.

> Shared user-facing features belong in the user aspect. Host-specific bundles such as gaming may live in host includes: `den._.host-aspects` explicitly projects their Home Manager configuration to users. The `nixos` sections of user-included aspects still apply to the system.

> **Note:** `isNormalUser`, shell, and wheel group are handled automatically by `den._.define-user`, `den._.user-shell`, and `den._.primary-user` in `modules/den.nix`. The user `nixos` section only needs extra groups or overrides.

---

## den.nix — Defaults & HM Integration

`modules/den.nix` centralises shared configuration applied to every host:

- `den.default.nixos.system.stateVersion` and `den.default.homeManager.home.stateVersion` — set to `"26.11"`
- `den.default.nixos.home-manager` — `useGlobalPkgs`, `useUserPackages`, `backupFileExtension`, `backupCommand` (removes old backup before backing up), feature imports live in their owning aspects
- `den.default.includes` — `den._.define-user`, `den._.primary-user`, `den._.user-shell "zsh"`, `den._.host-aspects`, `den._.inputs'`, `den._.self'`, `den._.hostname`
- Imports `dendritic` from both `flake-file` and `den` for the den schema
- `den.schema.user.classes = [ "homeManager" ]` — activates the Home Manager integration automatically

---

## Key Inputs

> **flake.nix is auto-generated** by `flake-file`. Never edit it directly. To add or change an input, edit `modules/flake-inputs.nix` then run `nix run .#write-flake` on `x86_64-linux`. To update locked versions, run `nix flake update` as normal.

| Input | Purpose |
| ------- | --------- |
| `den` | Den framework (v0.19.0) — auto-generates nixosConfigurations, wires HM, provides context |
| `nixpkgs` | NixOS unstable |
| `multiverse` | Exact-version package pins exposed through the system overlay |
| `curseforge` | CurseForge AppImage package for the desktop gaming bundle |
| `home-manager` | User environment management |
| `betterfox` | Betterfox-nix Home Manager module; Firefox preferences pinned to preset `154.0` |
| `umbriel` | Scrolling Wayland compositor (github:noctalia-dev/umbriel) |
| `stylix` | System-wide theming (base16, GTK, Qt, fonts) |
| `sops-nix` | Secrets management (age encryption) |
| `nixcord` | Declarative Discord client config (Discord + Equicord + OpenASAR) |
| `noctalia` | Desktop shell bar/launcher/lockscreen |
| `pear-desktop` | Pear Desktop / YouTube Music |
| `spicetify-nix` | Optional Spotify theming; input and user include currently commented out |
| `nix-index-database` | Fast `nix-locate` lookups |
| `nix-versions` | Version tracking for nix commands |
| `nvim-config` | Neovim config (neonvoidx/nvim) |
| `scopebuddy` | ScopeBuddy driver |
| `eldritch-cursors` | Eldritch theme cursors |
| `flake-file` | Regenerates flake.nix from flake-inputs.nix |
| `flake-parts` / `import-tree` | Flake module composition and automatic module discovery |

NeonMono is a local package defined in `modules/nix/overlays.nix`, sourced from
`assets/fonts/neonmono`; it is not a flake input.

---

## Conventions

`modules/desktop/xembsni.nix` owns the XEmbed-to-StatusNotifierItem tray bridge
package and its Umbriel-session user service. The shared user aspect includes
it on both hosts; it is independent of WoW and the gaming bundle. Its package
definition remains in `modules/nix/overlays.nix`.

- **Module file names**: kebab-case (`desktop-environment.nix`, `system-packages.nix`)
- **Aspect names**: match the file name (`den.aspects."desktop-environment"`). Use explicit kebab-case identifiers such as `desktop-environment`, `gnome-keyring`, and `nix-settings`.
- **Host names**: lowercase (`void`, `voidframe`)
- **User**: `neonvoid` (lowercase in description)
- **One file per aspect**: keep configuration and small local helpers together. Umbriel and Noctalia remain Nix attrsets because they derive settings from host data and package paths; do not split their payloads into `_data/` files.
- **Package-only tools**: put tools such as `jq` in `modules/home/packages.nix` when no extra configuration is needed. Keep feature dependencies with their owning aspect (for example, `wl-clipboard` in `clipboard.nix`).
- **Host-specific conditionals**: use `host.attr or false` in the outer lambda, `lib.optionals` for conditional includes, `osConfig.fileSystems ? "/games"` for filesystem checks in HM modules, or `config.networking.hostName == "void"` inside nixos modules
- **Styling/colors**: base16 palette via Stylix. Cursor consumers read `config.stylix.cursor`; aspects with complete custom themes disable the corresponding Stylix target instead of forcing every setting.
- **Email secrets are optional**: accounts accept plain `address`/`userName` or `addressSecret`/`userNameSecret` SOPS-key references, including mixed accounts. Only secret-backed users get email secrets, a runtime template, and SOPS service ordering. Keep the whole aspect in `modules/communication/email.nix`.
- **Thunderbird runtime rendering**: Home Manager's generated `user.js` text contains markers; SOPS renders it at runtime and Home Manager links the rendered file through `mkOutOfStoreSymlink`. Address markers must contain `@` for HM validation and that dummy suffix must be removed from the template. Secret values are JSON string literals (including quotes); replace the whole quoted marker with the SOPS placeholder to preserve JavaScript escaping. Never decrypt identities during Nix evaluation or put them in derivations.
- **User data**: `modules/hosts.nix` user records hold optional `emailAccounts` (Home Manager account definitions), `avatar` (`.face`), `logo` (Noctalia/Fastfetch), and `wallpaperRepository` (the URL cloned by `pics`). Keep personal identities and asset sources out of reusable aspects.
- **Host data**: `gamesLocation`, `gaming.environment`, and `printer` hold gaming paths, Steam environment overrides, and printer settings. `printer.drivers` contains nixpkgs attribute names; the other printer fields map to `hardware.printers.ensurePrinters`. Device-specific udev rules belong in the host aspect.
- **Mutable ScopeBuddy configs**: use session variables `SCB_GAMES_LOCATION`, `SCB_GPU_DEVICE_ID`, and `SCB_TIMEZONE`; append each game's Steam compatibility-data suffix in the shell config. These files remain external symlinks. Environment changes require new application/session environments.
- **Checkout helpers**: use `config.dotfiles.checkoutPath` and its exported `DOTFILES_CHECKOUT_PATH`, including global just recipes and Lazygit. The installed justfile must embed the configured path as a fallback and export the resolved value to recipes, so missing session variables cannot prevent bootstrapping. Direct use of the asset falls back to the invocation directory. Store-managed images must not depend on a checkout path.
- **Assets**: versioned scripts, shaders, themes, and images use repository `.source` paths. Pear's Eldritch CSS is fetched from a pinned upstream commit with a content hash and consumed directly from the Nix store. Only EasyEffects UI configuration and editable ScopeBuddy settings use external symlinks, based on `config.dotfiles.checkoutPath` (default `${config.home.homeDirectory}/nix`).
- **Caches**: `assets/nix/caches.json` is shared by the Nix settings aspect and CI. Do not parse Nix source using regex.
- **Package pins**: declare Multiverse pins in the NixOS aspect. `overlays.nix` exposes them through `pkgs`, shared with Home Manager via `useGlobalPkgs = true`; no separate Home Manager Multiverse module is needed.
- **Secrets**: SOPS age-encrypted in `secrets/`, decrypted to `/run/secrets/` at boot
- **Secret ownership**: `sops.nix` captures `user` in its outer aspect lambda and sets the Cachix/GitHub secret owners from `user.userName`.
- **Key provisioning**: users must retrieve SSH keys into local files before rebuilding or activating SOPS. No aspect mounts NAS shares or retrieves keys. Manual SOPS editing uses a locally prepared user age key; boot-time decryption requires `/etc/sops/age/key.txt` and a matching encrypted recipient. See `secrets/README.md`; do not perform activation or key retrieval automatically.
- **Git tracking**: new files must be `git add`-ed before rebuilding (Git-backed flakes only include git-tracked files)
- **README scope**: keep `README.md` concise: repository overview/structure, hosts, included aspects, adding a host/user/aspect, and essential commands. Update it only when a change affects one of those topics, such as changing aspect includes, documented paths, or setup/build instructions. Ordinary configuration changes, keybindings, theme adjustments, tuning, bug fixes, and internal implementation details do not require README edits unless they change those documented topics. Do not add feature changelogs or detailed per-program explanations. Put durable agent guidance in `AGENTS.md` and detailed SOPS instructions in `secrets/README.md`; update those only when relevant. When a README update is needed, correct the existing section in the same change and preserve its concise scope.

---

## Umbriel Scrolling Layout & Startup

`modules/desktop/umbriel.nix` uses the scrolling layout and dynamic workspaces on every output. The strip is perpendicular to `workspace_axis`: rotated portrait outputs use `"horizontal"`, making a top-to-bottom strip; landscape outputs use `"vertical"`, making a left-to-right strip. New columns use 90% of the viewport, with 50/90/100% size presets. Game rules retain fullscreen behavior but no longer place applications on static workspaces.

All workspaces are dynamic and output-local. When a `host.monitors.portrait` output exists, a global window rule routes applications to the main output; only Discord and Pear override it to portrait dynamic workspace 1 in distinct named scrolling lanes with 75%/25% opening extents, while Discord popouts target secondary. `wait-for-discord-and-move.sh` is a session-long window listener that arranges a new Discord/Pear pair once, preventing its own focus/geometry IPC events from causing a feedback loop; it takes focus only to correct an out-of-order pair. Underfull-strip centering is disabled globally. Focus centering uses `"on_overflow"` globally, with a workspace-specific `"never"` override on portrait workspace 1 to keep Discord/Pear flush with the top edge. Umbriel uses dynamic workspaces; `focus-app.sh` provides application focus bindings, and `assets/scripts/toggle-monitor.sh` calls the Umbriel screen-toggle helper, using `UMBRIEL_PRIMARY_OUT` for its output toggle.

Keybinds: Mod+1–0 select local positions 1–10 and Mod+Shift+1–0 send the window there. Mod+S/T toggle the Steam/Thunderbird scratchpads; Mod+G/D focus an open game/Discord window. Mod+H/J/K/L and the matching arrows use `window-focus-or-output-*`. Mod+Shift+H/L and matching left/right arrows use `window-move-or-output-*`; Mod+Shift+J/K and matching up/down arrows use `window-move-or-workspace-*`, sending a window to the next/previous dynamic workspace at the vertical edge. Mod+Home/End and Mod+Shift+Home/End walk dynamic workspaces and send windows there; Mod+Grave focuses the last workspace. Mod+=/- resize primary extent by 5%, Mod+R cycles 50/90/100%, Mod+C centers the focused scrolling column, and Mod+Shift+Space toggles floating. Mod+wheel switches workspaces. Toggles, launches, screenshots, close/quit/lock, direct workspace selection and sending, centering, Alt+Tab, size cycling, and track changes run once per press via the local `norepeat` helper (`repeat = false`); directional focus/movement, incremental resizing, volume, brightness, and normal typing retain repeat.

On portrait dynamic workspace 1, each application occupies a separate full-width scrolling lane: Discord above Pear. Do not consume them into one lane: that would put them side by side on a vertical strip. Use primary extent for their heights. Umbriel's `general.autostart` runs only at session startup, so the listener requires a session restart or a manual launch once after installing the config.

---

Firefox Picture-in-Picture windows are floating and pinned, with both initial
focus and activation focus disabled (`default_focused = false`,
`focus_on_activate = false`).

## Tmux & Sesh Pickers

Umbriel calls `~/.local/bin/tmux-refresh-desktop-environment` at startup to refresh desktop variables in tmux's global environment and every existing session. Tmux refreshes the same allowlist on attachment, and a Zsh `precmd` hook imports it into existing pane shells without evaluating values as shell code. This is designed for local desktop attachments. Existing applications retain their own environment until restarted; existing shells need the new hook loaded once after deployment.

`modules/shell/tmux.nix` owns tmux config, the sesh picker scripts, and two systemd user units. Key mechanics for anyone touching this:

- **One picker script, three entry points.** `~/.local/bin/sesh-fast` (a `home.file` symlink to a `writeShellScript`) is the single picker used by the shell-start prompt (`s`, outside tmux only), the `s` alias inside a real pane, and the prefix+o binding. `sesh list --icons` (all sources) is the default; the ctrl-a/t/g/x/f/d rebinds switch views.
- **tmux needs a real tty.** `run-shell` has no tty and no `$TMUX_PANE`, so fzf dies. prefix+o is `bind o display-popup -E -d '#{pane_current_path}' -w 80% -h 70% 'SESH_IN_POPUP=1 ~/.local/bin/sesh-fast'` — the popup provides its own pty. `SESH_IN_POPUP=1` makes the script use plain fzf instead of spawning a nested `fzf-tmux` popup. Both picker popups start in the current pane directory. The session picker shares its fzf options in a Bash array, preserving the pane-only Tab navigation binding.
- **A display-popup has no `$TMUX`** (only `TMUX_PANE`), so inside a popup the script runs `sesh connect --switch` (sesh's "triggered outside the terminal" mode). With `$TMUX` set it relies on sesh's built-in client switch; from a bare terminal it attaches.
- **Phantom `0` sessions.** `programs.tmux.newSession` is `false` so tmux never spawns `new-session -A -s 0`; a stale resurrect save had previously re-created a junk `0` session plus stale windows on every server start. The running sesh cache also goes stale, so `session-created` / `session-closed` hooks run `sesh cache refresh` (store path).
- **Resurrection saves run from systemd, not continuum.** The custom `status-right` replaces Continuum's autosave trigger. Continuum's save interval is explicitly `0`, while automatic restore remains enabled. `tmux-resurrect-save.service` + `timer` (every 10 min) run Resurrect's `scripts/save.sh` against the default socket using `tmux run-shell` without `-d` (which requires a numeric delay). To force a save: `systemctl --user start tmux-resurrect-save`.
- **Resize mode** is client-local: prefix+r enters it, hjkl/arrows resize repeatedly, and q/Escape/Enter exit. Each resize binding reselects the resize table with `switch-client -T resize`; other keys are ignored until exit. The status line shows `RESIZE` only for that client. Never change the global `key-table` to enter this mode.
- **Session bootstrap** is `tmux-default-sessions.service` (creates `home` + `nix`, kills an unattached leftover `0`). Validate changes with `nix flake check` or the nix-agent MCP `check` tool.

---

## Noctalia TOML → Nix Conversion

When updating `modules/desktop/noctalia.nix` from a noctalia TOML config export, follow these rules:

### Source of truth

- Read `/home/neonvoid/.local/state/noctalia/settings.toml` — the TOML config exported from noctalia's UI.
- Compare the export with the current Nix settings to identify intentional changes. If the export is in a Git checkout, use its uncommitted diff as additional evidence; the runtime state path is not necessarily Git-tracked.
- Port intentional configuration changes, not runtime state.

### What to convert

- All `[section]` and `[section.subsection]` map to nested nix attrsets
- TOML arrays become nix lists
- TOML inline tables become nix attrsets
- Use `host.monitors` variables (`mainName`, `secondaryName`, `portraitName`, `builtinName`) instead of hardcoded monitor names
- Use `${homeDir}` instead of `/home/neonvoid`

### What to ignore

- **Wallpaper sections** — `wallpaper.default`, `wallpaper.last`, `wallpaper.monitors.*` (runtime state, not config)
- **`dock`** — not used in nix config
- **Shell paths** — keep nix-style paths (`${homeDir}/.nix-profile/bin/...`) rather than TOML's `/etc/profiles/per-user/...`
- Any TOML key that is purely runtime state (e.g. last wallpaper path, active state)

### What to check for differences

- **New plugins** — compare `plugins.enabled` lists
- **New plugin_settings** — compare `plugin_settings` sections
- **New widgets** — compare `widget.*` sections
- **Bar layout changes** — compare `bar.main.start`, `bar.main.center`, `bar.main.end` widget lists. Preserve the deliberate host layouts: `battery` and `power_profile` are laptop-only, `display_mode` and `audio_visualizer` are desktop-only, and the laptop puts `active_window` and a tray in the start section instead of using the desktop center section.
- **OSD settings** — compare `osd.*` (e.g. `kinds.media`)
- **Widget property additions** — compare individual widget settings (e.g. `input_devices` on `widget.cat`)

---

## Adding New Aspects

1. Create `modules/<category>/<name>.nix` — import-tree picks it up automatically
2. Add `den.aspects.<name>` to the user's includes (`modules/users/neonvoid/neonvoid.nix`) for user-facing features, or to the host's includes (`modules/hosts/<hostname>/default.nix`) for system-only features
3. Validate: `nix flake check` or the nix-agent MCP `check` tool with `level = "dry-build"`

## Adding a New Host

1. Add to `modules/hosts.nix` under `den.hosts.x86_64-linux`
2. Create `modules/hosts/<hostname>/default.nix` with `den.aspects.<hostname>`
3. Add `hosts/<hostname>/hardware-configuration.nix`

## Adding a New User

1. Create `modules/users/<username>/<username>.nix` with `den.aspects.<username>`
2. Add `users.<username> = {}` to the relevant host entry in `modules/hosts.nix`

---

## Useful Commands

The versioned `.githooks/pre-commit` hook runs `treefmt --fail-on-change`.
Enable it per clone with `git config --local core.hooksPath .githooks`.
It uses `treefmt` and `nixfmt` on PATH, or falls back to a one-shot `nix-shell`
with both packages from the flake's locked nixpkgs input. The fallback requires
`nix` and `nix-shell` on PATH. Review and stage formatting changes before retrying
a commit that the hook stops. The hook never stages files automatically.

### Project-local Codex MCPs

`.codex/config.toml` configures pinned `mcp-nixos` and `nix-agent` servers via
`uvx`, separately from Home Manager's `modules/shell/mcp.nix`. Use mcp-nixos for
package/option discovery. nix-agent exposes only `build`, `diff`, `eval_config`,
`locate_option`, and `check`; `switch` and `generations` are excluded. Only use
`check` levels `lint` and `dry-build`, never `dry-activate`. Select hosts explicitly
with `flake_uri` ending in `#void` or `#voidframe`; the local Mac hostname is not a
configured NixOS host. Lint requires `statix` and `deadnix` on PATH, and Linux
closure builds require a compatible builder. MCP startup requires `uvx` and Nix
on PATH. Trust the project and reopen the session after configuration changes;
adjust `.codex/config.toml`'s `NIX_AGENT_FLAKE` for other checkout locations.

```bash
# Validate on x86_64-linux or with a compatible Linux builder
nix flake check

# Evaluate checks without building their derivations
nix flake check --no-build

# Update flake inputs
nix flake update

# Regenerate flake.nix on x86_64-linux after changing flake-inputs.nix
nix run .#write-flake

# Check which packages are available
nix search nixpkgs <package>

# Enter the development shell on x86_64-linux
nix develop
```

The `nix-agent` names above refer to MCP tools, not shell executables. Pass
`flake_uri` ending in `#void` or `#voidframe` to `check`, `build`, `diff`, and
`eval_config`; `check` supports the permitted levels `lint` and `dry-build`.

Only `x86_64-linux` helper packages and development shells are exported. The
`write-flake` package is unavailable on `aarch64-darwin`. A full evaluation can
still require a Linux builder even with `--no-build`: xembsni reads its fetched
`Cargo.lock` during evaluation. Use focused `eval_config` calls when inspecting
unaffected options from the Mac.

## Screenshots

Umbriel uses Noctalia screenshot shortcuts: Print selects a region, Shift+Print opens screenshot annotation, and Ctrl+Print captures all outputs.
