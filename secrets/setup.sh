#!/usr/bin/env bash
set -e

echo "=== sops-nix Machine Setup ==="
echo ""

MACHINE_NAME="${1:-$(hostname)}"

# Step 1: Generate standalone age key
echo "Step 1: Generating standalone age key for '$MACHINE_NAME'..."
sudo mkdir -p /etc/sops/age
nix-shell -p age --run 'age-keygen -o /tmp/age-key.txt'
sudo mv /tmp/age-key.txt /etc/sops/age/key.txt
sudo chmod 600 /etc/sops/age/key.txt
echo "✓ Key generated at /etc/sops/age/key.txt"
echo ""

# Step 2: Print the public key
PUBKEY=$(sudo cat /etc/sops/age/key.txt | grep "^# public key:" | sed 's/.*public key: //')
echo "Public key for this machine: $PUBKEY"
echo ""
echo "Step 2: Add this key to .sops.yaml:"
echo ""
echo "  keys:"
echo "    - &${MACHINE_NAME}_boot $PUBKEY"
echo ""
echo "  creation_rules:"
echo "    - path_regex: secrets/secrets\.yaml$"
echo "      key_groups:"
echo "        - age:"
echo "            - *admin_neonvoid"
echo "            - *${MACHINE_NAME}_boot"
echo ""
echo "Then re-encrypt secrets:"
echo "  nix-shell -p sops --run 'sops updatekeys secrets/secrets.yaml'"
echo ""

# Step 3: User age key (for CLI editing via SSH)
echo "Step 3 (optional): Set up your user age key for CLI editing..."
echo "If you have an SSH key you want to use for sops CLI:"
echo ""
echo "  mkdir -p ~/.config/sops/age"
echo "  nix-shell -p ssh-to-age --run 'ssh-to-age -private-key -i ~/.ssh/id_ed25519 > ~/.config/sops/age/keys.txt'"
echo "  chmod 600 ~/.config/sops/age/keys.txt"
echo ""

echo "=== Setup Complete ==="
echo ""
echo "Next steps:"
echo "  1. Add the public key to .sops.yaml (see above)"
echo "  2. Re-encrypt secrets: sops updatekeys secrets/secrets.yaml"
echo "  3. Rebuild: sudo nixos-rebuild switch --flake .#$MACHINE_NAME"
