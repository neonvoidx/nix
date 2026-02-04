{ pkgs, lib, ... }:
{
  services.gnome-keyring = {
    enable = true;
    components = [
      "pkcs11"
      "secrets"
      "ssh"
    ];
  };

  # Create activation script to set empty keyring password
  home.activation.setupPasswordlessKeyring = lib.hm.dag.entryAfter ["writeBoundary"] ''
    # Ensure keyring directory exists
    mkdir -p $HOME/.local/share/keyrings
    
    # Create a default keyring without password if it doesn't exist
    if [ ! -f $HOME/.local/share/keyrings/default.keyring ]; then
      cat > $HOME/.local/share/keyrings/default.keyring << 'EOF'
[keyring]
display-name=Default keyring
ctime=1234567890
mtime=1234567890
lock-on-idle=false
lock-after=false
EOF
    fi
  '';
}
