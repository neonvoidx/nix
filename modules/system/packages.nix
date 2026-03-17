{ den, inputs, ... }:
{
  den.aspects.systempackages.nixos =
    { pkgs, ... }:
    {
      # System wide packages
      environment.systemPackages = with pkgs; [
        ananicy-cpp
        ananicy-rules-cachyos
        bc
        bind
        bluetui
        bluez
        brightnessctl
        choose
        cron
        dig
        dust
        fbset
        fd
        file
        gnupg
        gzip
        hydra-check
        killall
        libnotify
        libappindicator-gtk3
        lsof
        mediainfo
        mtr
        nix-converter
        nurl
        pciutils
        playerctl
        procps
        ripgrep
        rtkit
        sd
        swappy
        traceroute
        tree
        tree-sitter
        udiskie
        unzip
        usbutils
        wget
        whois
        xrandr
        xwayland
        yubico-pam
        yubioath-flutter
        zip
      ];
    };
}
