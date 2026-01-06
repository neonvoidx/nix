{ pkgs, ... }:
{
  services.gnome-keyring = {
    enable = true;
    components = [
      "pkcs11"
      "secrets"
      "ssh"
    ];
  };

  systemd.user.services.populate-keyring = {
    Unit = {
      Description = "Populate gnome-keyring with email passwords";
      After = [ "gnome-keyring.service" ];
      PartOf = [ "gnome-keyring.service" ];
    };
    Service = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = pkgs.writeShellScript "populate-keyring" ''
        # Wait for keyring to be ready
        sleep 2

        # Clear existing entries to prevent duplicates
        ${pkgs.libsecret}/bin/secret-tool clear protocol imap server 127.0.0.1 port 1143 user me@neonvoid.dev 2>/dev/null || true
        ${pkgs.libsecret}/bin/secret-tool clear protocol imap server imap.gmail.com port 993 user jacob.russell.reed@gmail.com 2>/dev/null || true

        # Protonmail Bridge password
        ${pkgs.libsecret}/bin/secret-tool store --label='Protonmail Bridge' \
          protocol imap \
          server 127.0.0.1 \
          port 1143 \
          user me@neonvoid.dev < /run/secrets/proton-bridge-password

        # Gmail app password
        ${pkgs.libsecret}/bin/secret-tool store --label='Gmail' \
          protocol imap \
          server imap.gmail.com \
          port 993 \
          user jacob.russell.reed@gmail.com < /run/secrets/gmail-app-password
      '';
    };
    Install = {
      WantedBy = [ "gnome-keyring.service" ];
    };
  };
}
