{ den, inputs, ... }:
{
  den.aspects.ly =
    { host, ... }:
    {
      nixos =
        {
          pkgs,
          lib,
          ...
        }:
        {
          environment.etc."ly/blackhole.dur".source = inputs.self + "/assets/ly/blackhole.dur";

          services.displayManager.ly = {
            enable = true;
            settings = {
              animation = "dur_file";
              dur_file_path = "/etc/ly/blackhole.dur";
              asterisk = "0x2022";
              bigclock = "en";
              bigclock_seconds = true;
              box_title = host.greeting;
              clear_password = true;
              # Ly supports 24-bit true color with styling, which means each color is a 32-bit value.
              # The format is 0xSSRRGGBB, where SS is the styling, RR is red, GG is green, and BB is blue.
              # Here are the possible styling options:
              # TB_BOLD      0x01000000
              # TB_UNDERLINE 0x02000000
              # TB_REVERSE   0x04000000
              # TB_ITALIC    0x08000000
              # TB_BLINK     0x10000000
              # TB_HI_BLACK  0x20000000
              # TB_BRIGHT    0x40000000
              # TB_DIM       0x80000000
              # Programmatically, you'd apply them using the bitwise OR operator (|), but because Ly's
              # configuration doesn't support using it, you have to manually compute the color value.
              # Note that, if you want to use the default color value of the terminal, you can use the
              # special value 0x00000000. This means that, if you want to use black, you *must* use
              # the styling option TB_HI_BLACK (the RGB values are ignored when using this option).
              # Background color id
              bg = "0x00212337";
              # Border foreground color id (eldritch purple)
              border_fg = "0x00a48cf2";
              # Error background color id
              error_bg = "0x00212337";
              # Error foreground color id (red, bold)
              error_fg = "0x01f16c75";
              # Foreground color id (eldritch blue)
              fg = "0x0039ddfd";
              # CMatrix animation foreground color id (eldritch green)
              cmatrix_fg = "0x0037f499";
              gameoflife_fg = "0x0037f499";
              # CMatrix animation character string head color id (bright white, bold)
              cmatrix_head_col = "0x01ffffff";
              default_input = "password";

            };
          };

          # Unlock gnome-keyring via ly's PAM session
          security.pam.services.ly.enableGnomeKeyring = true;

          # If multimonitor we add a pre exec to run fbset with our primary display resolution
          # this is so the main monitor TTY ly isn't cropped
          systemd.services.display-manager = lib.mkIf (host.isMultiMonitor or false) {
            preStart = ''
              ${pkgs.fbset}/bin/fbset -xres ${host.xRes} -yres ${host.yRes}
            '';
          };
        };
    };
}
