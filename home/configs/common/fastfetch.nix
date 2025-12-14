{ pkgs, ... }:
{
  programs.fastfetch = {
    enable = true;
    settings = {
      "$schema" = "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json";
      logo =
        if pkgs.stdenv.isLinux then
          {
            type = "kitty-direct";
            source = "~/nix/assets/neonvoid.png";
            width = 25;
            padding = {
              top = 1;
              right = 10;
            };
          }
        else if pkgs.stdenv.isDarwin then
          {
            type = "kitty-direct";
            source = "~/nix/assets/darwin.png";
            width = 25;
            padding = {
              top = 1;
              right = 10;
            };
          }
        else
          {
            type = "builtin";
            source = "nixos";
          };
      display = {
        separator = "  ";
      };
      modules = [
        {
          key = "╭───────────╮";
          type = "custom";
        }
        {
          key = "│  user    {#keys}│";
          type = "title";
          format = "{user-name}";
        }
        {
          key = "│ 󰇅 hname  {#keys}│";
          type = "title";
          format = "{host-name}";
        }
        {
          key = "│ 󰅐 uptime {#keys}│";
          type = "uptime";
        }
        {
          key = "│  distro {#keys}│";
          type = "os";
        }
        {
          key = "│  kernel  {#keys}│";
          type = "kernel";
        }
        {
          key = "│ 󰇄 desktop{#keys}│";
          type = "de";
        }
        {
          key = "│ 󰖲 wm     {#keys}│";
          type = "wm";
        }
        {
          key = "│  term    {#keys}│";
          type = "terminal";
        }
        {
          key = "│ 󱆃 shell   {#keys}│";
          type = "shell";
        }
        {
          key = "│ 󰍛 cpu    {#keys}│";
          type = "cpu";
          showPeCoreCount = true;
        }
        {
          key = "│ {#34}󰉉 disk   {#keys}│";
          type = "disk";
          folders = "/";
        }
        {
          key = "│ {#35} memory  {#keys}│";
          type = "memory";
        }
        {
          key = "│ {#36}󰩟 network{#keys}│";
          type = "localip";
          format = "{ipv4} ({ifname})";
        }
        {
          key = "├───────────┤";
          type = "custom";
        }
        {
          key = "│ {#39} colors  {#keys}│";
          type = "colors";
          symbol = "circle";
        }
        {
          key = "╰───────────╯";
          type = "custom";
        }
      ];
    };
  };
}
