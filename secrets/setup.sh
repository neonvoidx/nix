#!/usr/bin/env bash
set -e

echo "=== sops-nix Email Secrets Setup ==="
echo ""

# Step 1: Generate age key from user SSH key
echo "Step 1: Generating age key from your SSH key..."
AGE_KEY=$(nix-shell -p ssh-to-age --run "ssh-to-age < $HOME/.ssh/id_ed25519.pub")
echo "Your age public key: $AGE_KEY"
echo ""

# Step 1b: Generate age private key and save it
echo "Step 1b: Generating age private key..."
mkdir -p "$HOME/.config/sops/age"
nix-shell -p ssh-to-age --run "ssh-to-age -private-key -i $HOME/.ssh/id_ed25519 > $HOME/.config/sops/age/keys.txt"
chmod 600 "$HOME/.config/sops/age/keys.txt"
echo "✓ Age key saved to $HOME/.config/sops/age/keys.txt"
echo ""

# Step 2: Update .sops.yaml
echo "Step 2: Updating .sops.yaml with your age key..."
cd "$(dirname "$0")/.."
sed -i "s/age1xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx/$AGE_KEY/" .sops.yaml
echo "✓ .sops.yaml updated"
echo ""

# Step 3: Instructions for passwords
echo "Step 3: You need to get your email passwords:"
echo ""
echo "For Proton Mail Bridge:"
echo "  1. Start bridge: systemctl --user start protonmail-bridge"
echo "  2. Run: protonmail-bridge --cli (or protonmail-bridge for GUI)"
echo "  3. Log in and copy the Bridge password"
echo ""
echo "For Gmail:"
echo "  1. Go to: https://myaccount.google.com/apppasswords"
echo "  2. Create an app password for Thunderbird"
echo "  3. Copy the generated password"
echo ""

# Step 4: Edit secrets
read -p "Press Enter when you have your passwords ready..."
echo ""
echo "Opening secrets file for editing..."
echo "Replace YOUR_PROTON_BRIDGE_PASSWORD_HERE and YOUR_GMAIL_APP_PASSWORD_HERE"
read -p "Press Enter to continue..."
${EDITOR:-nano} secrets/secrets.yaml

# Step 5: Encrypt
echo ""
echo "Step 5: Encrypting secrets file..."
nix-shell -p sops --run 'sops -e -i secrets/secrets.yaml'
echo "✓ Secrets encrypted!"
echo ""

echo "=== Setup Complete ==="
echo ""
echo "Next steps:"
echo "  1. Review your changes: git status"
echo "  2. Rebuild your system: sudo nixos-rebuild switch --flake .#void"
echo "  3. Start Proton Mail Bridge: systemctl --user start protonmail-bridge"
echo "  4. Open Thunderbird and your accounts should be configured!"
