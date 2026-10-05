# NixOS Configuration

[![Build and Cache](https://github.com/neonvoidx/nix/actions/workflows/build-and-cache.yml/badge.svg?branch=master)](https://github.com/neonvoidx/nix/actions/workflows/build-and-cache.yml)

My NixOS configuration using [Den](https://github.com/denful/den),
[flake-parts](https://flake.parts/), and [import-tree](https://github.com/denful/import-tree).

## Structure

| Path | Purpose |
| --- | --- |
| `modules/hosts.nix` | Host attributes and user assignments |
| `modules/hosts/<host>/default.nix` | Host aspects and hardware-specific settings |
| `modules/users/<user>/<user>.nix` | User aspects and included features |
| `modules/<category>/` | Reusable aspects, one file per aspect |
| `hosts/<host>/hardware-configuration.nix` | Generated hardware configuration |
| `assets/` | Images, scripts, shaders, and editable application settings |
| `secrets/` | SOPS-encrypted secrets and setup instructions |
| `modules/flake-inputs.nix` | Flake inputs; `flake.nix` is generated |

All `.nix` files under `modules/` are discovered automatically. An aspect becomes
active when included by a host, user, or bundle. Host-specific values belong in
host attributes; personal values belong in user attributes in `modules/hosts.nix`.

## Hosts and included aspects

| Host | Hardware | Host includes |
| --- | --- | --- |
| `void` | Ryzen 9 9950X, RX 9070 XT, three monitors | `base-system`, `wireguard`, `gaming` |
| `voidframe` | Framework laptop, Ryzen 7 7840U | `base-system` |

Both hosts use the `neonvoid` user aspect. Den applies the user aspect automatically;
do not also include it in the host aspect. Host bundles project their Home Manager
settings to users through `den._.host-aspects`.

**System bundles**

| Bundle | Included aspects |
| --- | --- |
| `base-system` — core | `boot`, `locale`, `networking`, `systemd`, `overlays`, `nix-settings`, `multiverse` |
| `base-system` — hardware | `bluetooth`, `kernel`, `print`, `udev` |
| `base-system` — security | `sops`, `pcscd`, `sudo`, `noctalia-greeter`, `polkit` |
| `base-system` — services/packages | `ananicy`, `system-packages` |
| `gaming` — desktop only | `steam`, `mangohud`, `deadlock`, `wow`, `scopebuddy` |

**User includes** — defined in [neonvoid.nix](modules/users/neonvoid/neonvoid.nix).

| Category | Included aspects |
| --- | --- |
| Shell tools | `bat`, `btop`, `direnv`, `devenv`, `delta`, `fastfetch`, `fzf`, `git`, `kitty`, `just`, `lazygit`, `lsd`, `mcp`, `nh`, `nix-index`, `nvim`, `opencode`, `pay-respects`, `starship`, `tealdeer`, `tmux`, `yazi`, `zoxide`, `zsh` |
| Desktop | `desktop-environment`, `fonts`, `xdg`, `stylix`, `noctalia`, `flatpak`, `clipboard`, `cursor`, `firefox`, `gtk`, `umbriel`, `thunar`, `xembsni` |
| Services | `gnome-keyring`, `pipewire`, `streamcontroller`, `usb` |
| Home | `common`, `files`, `packages` |
| Media | `cava`, `easyeffects`, `mpv`, `obs-studio`, `pics`, `youtube-music` |
| Communication | `discord`, `email` |

## Adding a host

1. Add a host entry under `den.hosts.x86_64-linux` in `modules/hosts.nix`.
   Reuse the existing `neonvoid` attrset or assign another user:

```nix
myhost = {
  users.neonvoid = neonvoid;
  timezone = "America/New_York";
  greeting = "My Host";
  xRes = "1920";
  yRes = "1080";
  monitors.main = {
    name = "DP-1";
    mode = "1920x1080@60";
    scale = 1.0;
    position = "0x0";
    primary = true;
  };
};
```

2. Create `modules/hosts/myhost/default.nix`:

```nix
{ den, inputs, ... }:
{
  den.aspects.myhost = {
    includes = [ den.aspects.base-system ];
    nixos = {
      imports = [ (inputs.self + "/hosts/myhost/hardware-configuration.nix") ];
      # Add this machine's boot, hardware, and networking settings here.
    };
  };
}
```

3. Add `hosts/myhost/hardware-configuration.nix` from `nixos-generate-config`.
4. Prepare the machine's secrets using [secrets/README.md](secrets/README.md),
   stage new files, and validate with `nix flake check`.

Den creates `nixosConfigurations.myhost` automatically. For additional host
attributes such as `audio`, `network`, `printer`, `gamesLocation`, and
`gaming.environment`, use the existing entries in `modules/hosts.nix` as examples.

## Adding a user

1. Create `modules/users/myuser/myuser.nix` and select the aspects they need:

```nix
{ den, ... }:
{
  den.aspects.myuser = {
    includes = [
      den.aspects.common
      den.aspects.files
      den.aspects.zsh
      den.aspects.git
    ];
    nixos.users.users.myuser.extraGroups = [ "audio" "video" ];
  };
}
```

2. Assign the user in the relevant host entry in `modules/hosts.nix`:

```nix
users.myuser = {
  gitName = "My Name";
  gitEmail = "me@example.com";
};
```

3. Stage new files and validate with `nix flake check`.

Optional user attributes include `avatar`, `logo`, `wallpaperRepository`, and
`emailAccounts`. Email accounts can use plain `address`/`userName` values or
SOPS-backed `addressSecret`/`userNameSecret` references; see the
[secret setup guide](secrets/README.md#email-identity-secrets).

## Adding an aspect

Create `modules/<category>/<name>.nix` defining `den.aspects.<name>`, then add it
to a user, host, or bundle's `includes`. Keep NixOS and Home Manager configuration
for the same feature in that file. Update this README when changing the structure
or included aspects.

## Commands

Run on `x86_64-linux`, or use a compatible builder for Linux checks and builds:

```sh
nix flake check             # Validate
nh os build                # Build without activating
nh os switch               # Deploy manually
nix flake update           # Update locked inputs
treefmt                    # Format Nix files
```

After editing `modules/flake-inputs.nix`, regenerate `flake.nix` on Linux with
`j write-flake`. To run from a checkout before the global justfile is updated:

```sh
just --justfile assets/justfile write-flake
```

If the checkout lives outside `~/nix`, set the Home Manager option
`dotfiles.checkoutPath`. It controls build helpers and editable asset symlinks;
the global justfile also accepts a `DOTFILES_CHECKOUT_PATH` override.

Enable the formatting pre-commit hook once per clone:

```sh
git config --local core.hooksPath .githooks
```

See [AGENTS.md](AGENTS.md) for detailed agent guidance, framework patterns, and
MCP setup. See [secrets/README.md](secrets/README.md) for key provisioning and SOPS.
