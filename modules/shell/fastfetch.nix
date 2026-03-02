{ den, ... }:
{
  den.aspects.fastfetch.homeManager =
    { pkgs, config, ... }:
    let
      c = config.lib.stylix.colors;
    in
    {
      programs.fastfetch = {
        enable = true;
        settings = {
          "$schema" = "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json";
          logo = {
            type = "kitty-direct";
            source = "~/nix/assets/neonvoid.png";
            width = 25;
            padding = {
              top = 1;
              right = 10;
            };
          };
          display = {
            separator = "  ";
            color = {
              keys = "#${c.base0D}";
              title = "#${c.base0C}";
            };
          };
          modules = [
            {
              key = "╭───────────╮";
              type = "custom";
            }
            {
              key = "│ {#31} user    {#keys}│";
              type = "title";
              format = "{user-name}";
            }
            {
              key = "│ {#32}󰇅 hname   {#keys}│";
              type = "title";
              format = "{host-name}";
            }
            {
              key = "│ {#33}󰅐 uptime  {#keys}│";
              type = "uptime";
            }
            {
              key = "│ {#34}{icon} distro  {#keys}│";
              type = "os";
            }
            {
              key = "│ {#35} kernel  {#keys}│";
              type = "kernel";
            }
            {
              key = "│ {#36}󰇄 desktop {#keys}│";
              type = "de";
            }
            {
              key = "│ {#37}󰖲 wm      {#keys}│";
              type = "wm";
            }
            {
              key = "│ {#31} term    {#keys}│";
              type = "terminal";
            }
            {
              key = "│ {#32} shell   {#keys}│";
              type = "shell";
            }
            {
              key = "│ {#33}󰍛 cpu     {#keys}│";
              type = "cpu";
            }
            {
              key = "│ {#34}󰉉 disk    {#keys}│";
              type = "disk";
              folders = "/";
            }
            {
              key = "│ {#35} memory  {#keys}│";
              type = "memory";
            }
            {
              key = "│ {#36}󰩟 network {#keys}│";
              type = "localip";
              format = "{ipv4} ({ifname})";
            }
            {
              key = "╰───────────╯";
              type = "custom";
            }
          ];
        };
      };
    };
}
