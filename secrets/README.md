# Secrets Management with sops-nix

## Initial Setup

1. **Generate your age key from your user SSH key:**

   ```bash
   # Generate public age key
   nix-shell -p ssh-to-age --run 'ssh-to-age < ~/.ssh/id_ed25519.pub'
   
   # Generate and save private age key
   mkdir -p ~/.config/sops/age
   nix-shell -p ssh-to-age --run 'ssh-to-age -private-key -i ~/.ssh/id_ed25519 > ~/.config/sops/age/keys.txt'
   chmod 600 ~/.config/sops/age/keys.txt
   ```

2. **Update `.sops.yaml` with your age public key:**
   - Replace `age1xxxxxx...` in `.sops.yaml` with the output from step 1

3. **Get your email passwords:**

   **For Gmail:**
   - Go to <https://myaccount.google.com/apppasswords>
   - Create an app password for Thunderbird
   - Copy the generated password

4. **Edit the secrets file:**

   ```bash
   # First time: edit the unencrypted template
   nano secrets/secrets.yaml
   # Add your passwords
   
   # Then encrypt it
   nix-shell -p sops --run 'sops -e -i secrets/secrets.yaml'
   ```

5. **Update the system:**

   ```bash
   sudo nixos-rebuild switch --flake .#void
   # or
   sudo nixos-rebuild switch --flake .#voidframe
   ```

## Editing Secrets Later

```bash
# Decrypt, edit, and re-encrypt
nix-shell -p sops --run 'sops secrets/secrets.yaml'
```

## Notes

- The secrets file will be encrypted with your age key
- Only systems with the corresponding SSH private key can decrypt it
- Secrets are decrypted at boot time to `/run/secrets/`
- Never commit unencrypted secrets to git!

## Backing Up Your Age Key

**IMPORTANT:** Your age private key (`~/.config/sops/age/keys.txt`) is derived from your SSH private key (`~/.ssh/id_ed25519`).

### Recovery Options

**Option 1: Keep your SSH key safe (recommended)**
Since the age key is generated from your SSH key, as long as you have `~/.ssh/id_ed25519`, you can always regenerate the age key:

```bash
mkdir -p ~/.config/sops/age
nix-shell -p ssh-to-age --run 'ssh-to-age -private-key -i ~/.ssh/id_ed25519 > ~/.config/sops/age/keys.txt'
chmod 600 ~/.config/sops/age/keys.txt
```

**Option 2: Back up the age key separately**

```bash
# Encrypt and back up to a secure location
gpg -c ~/.config/sops/age/keys.txt
# Copy keys.txt.gpg to a secure backup location (USB drive, password manager, etc.)
```

**Option 3: Store in a password manager**
Copy the contents of `~/.config/sops/age/keys.txt` to your password manager (like Bitwarden, 1Password, etc.)

### For New Machines

1. Copy your SSH key to the new machine: `~/.ssh/id_ed25519`
2. Regenerate the age key using the command from Option 1 above
3. The new machine can now decrypt your secrets!

### Multiple Machines

If you want multiple machines to decrypt your secrets, you have two options:

1. **Use the same SSH key** on all machines (copy `~/.ssh/id_ed25519`)
2. **Add multiple age keys** to `.sops.yaml` - each machine can have its own SSH/age key
