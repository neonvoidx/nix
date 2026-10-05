# Secrets Management with sops-nix

Secrets are encrypted with [sops](https://github.com/getsops/sops) using age keys.
Each machine has its own boot-time decryption key at `/etc/sops/age/key.txt`,
and the user's SSH-derived key is kept for manual editing.

## Architecture

- **`secrets/secrets.yaml`** — encrypted with all machine keys + the user admin key
- **`/run/secrets/`** — decrypted at boot via `sops-install-secrets.service`
- **`/etc/sops/age/key.txt`** — per-machine standalone age key (NOT derived from SSH)
- **`~/.config/sops/age/keys.txt`** — user's SSH-derived age key (for CLI editing)

## Initial Machine Setup

Before rebuilding or activating this configuration, retrieve your SSH private
and public keys manually and store them locally at `~/.ssh/id_ed25519` and
`~/.ssh/id_ed25519.pub`. Use permissions `0700` for `~/.ssh` and `0600` for the
private key. SSH keys must be provisioned manually.

For manual SOPS editing, prepare `~/.config/sops/age/keys.txt` from your local SSH
key (or restore that age key from backup):

```bash
mkdir -p ~/.config/sops/age
nix-shell -p ssh-to-age --run 'ssh-to-age -private-key -i ~/.ssh/id_ed25519 > ~/.config/sops/age/keys.txt'
chmod 600 ~/.config/sops/age/keys.txt
```

Boot-time decryption uses the separate machine key below. Provision that key and
add its public recipient to the encrypted secrets before activating SOPS.

Every new machine needs its own boot-time age key:

```bash
# 1. Generate a standalone age key
sudo mkdir -p /etc/sops/age
nix-shell -p age --run 'age-keygen -o /tmp/age-key.txt'
sudo mv /tmp/age-key.txt /etc/sops/age/key.txt
sudo chmod 600 /etc/sops/age/key.txt

# 2. Get the public key
sudo cat /etc/sops/age/key.txt | grep "^# public key:"
# → age1abc...
```

### Add the new machine to the keychain

1. Add the new public key to `.sops.yaml`:
   ```yaml
   keys:
     - &admin_neonvoid age1p7jngse0vtfer554m7kq6dxkakfr5hpkl4sel4hfz3elpm0mmuxqcjcj6r
     - &machinename_boot age1abc...  # new machine key

   creation_rules:
     - path_regex: secrets/secrets\.yaml$
       key_groups:
         - age:
             - *admin_neonvoid
             - *machinename_boot
   ```

2. Re-encrypt secrets with the new key:
   ```bash
   nix-shell -p sops --run 'sops updatekeys secrets/secrets.yaml'
   ```

3. Rebuild:
   ```bash
   sudo nixos-rebuild switch --flake .#machinename
   ```

## Editing Secrets

```bash
# Decrypt, edit, and re-encrypt in place
nix-shell -p sops --run 'sops secrets/secrets.yaml'
```

This uses your SSH-derived key at `~/.config/sops/age/keys.txt`.

## Email Identity Secrets

SOPS is optional for each email account. Ordinary `address` and `userName`
attributes still work, and accounts using plaintext and secret references can
share a Thunderbird profile. `neonvoid` uses `addressSecret` and `userNameSecret`
references in `modules/hosts.nix` for both configured accounts.

The encrypted keys are `email/neonvoid/<account>/address-json` and
`email/neonvoid/<account>/user-name-json`. Their values must be **JSON string
literals**, including double quotes. In the decrypted SOPS editor, for example:

```yaml
email:
  neonvoid:
    gmail:
      address-json: '"me@example.com"'
      user-name-json: '"me@example.com"'
```

JSON escaping is required for quotes, backslashes, and control characters.
SOPS substitutes these literals into the generated Thunderbird template at
runtime; the plaintext is not evaluated by Nix. The rendered `user.js` is owned
by the user with mode `0400`, and Home Manager links it into the default profile.
The template itself is not encrypted: it contains placeholders instead of the
private identities. Restart Thunderbird after changing the secrets.

Never commit decrypted values. This does not remove previous values from Git
history or older Nix store paths, and display names/Git identities are unchanged.

## Key Locations

| Key | Purpose | Location |
|-----|---------|----------|
| **Admin (SSH-derived)** | CLI editing via `sops` | `~/.config/sops/age/keys.txt` |
| **Per-machine (standalone)** | Boot-time decryption | `/etc/sops/age/key.txt` |

## Adding a Machine

1. SSH into the new machine
2. Generate its age key (see Initial Machine Setup above)
3. Get the public key
4. Add it to `.sops.yaml` and re-encrypt
5. Commit and push the updated `.sops.yaml` and `secrets/secrets.yaml`
6. Rebuild the new machine

## Key Backup

The per-machine key at `/etc/sops/age/key.txt` is unique to each machine.
If you lose it, that machine can't decrypt secrets anymore.

Backup strategy:

```bash
# Save a copy to a secure location
sudo cat /etc/sops/age/key.txt | gpg -c > ~/backup-machine-key.txt.gpg
```

## Notes

- Never commit unencrypted secrets to git!
- Re-encrypt after adding/removing keys: `sops updatekeys secrets/secrets.yaml`
