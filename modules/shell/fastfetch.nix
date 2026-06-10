{ den, ... }:
{
  den.aspects.fastfetch.homeManager =
    { pkgs, config, ... }:
    let
      esc = builtins.fromJSON ''"\u001b"'';
    in
    {
      programs.fastfetch = {
        enable = true;
        settings = {
          "$schema" = "https://github.com/fastfetch-cli/fastfetch/raw/master/doc/json_schema.json";
          display = {
            key.width = 10;
            separator = "";
          };
          logo = {
            type = "kitty-direct";
            # NOTE: Change this if you want a different fastfetch image
            source = "~/nix/assets/neonvoid.png";
            width = 25;
            padding = {
              top = 1;
              right = 10;
            };
          };
          modules = [
            "break"
            {
              type = "command";
              key = "󰀄 USER";
              keyColor = "#a48cf2";
              text = "whoami";
            }
            {
              type = "os";
              key = "󰣇 OS";
              keyColor = "#04d1f9";
              format = "{name} {version-id}";
            }
            {
              type = "command";
              key = "󰌽 KER";
              keyColor = "#37f499";
              text = "echo $(uname -r | cut -d- -f1) $(uname -m)";
            }
            {
              type = "packages";
              key = "󰏗 PKG";
              keyColor = "#f1fc79";
              format = "{all}";
            }
            {
              type = "cpu";
              key = "󰻠 CPU";
              keyColor = "#fbbf24";
              format = "{name}  ({cores-physical}P/{cores-logical}L)  {freq-max}";
            }
            {
              type = "gpu";
              key = "󰍹 GPU";
              keyColor = "#d946ef";
              detectionMethod = "vulkan";
              hideType = "integrated";
              format = "{name}  ({dedicated-total})";
            }
            {
              type = "terminal";
              key = "󰆍 TERM";
              keyColor = "#f7c67f";
              format = "{pretty-name}";
            }
            {
              type = "shell";
              key = "󰞷 SH";
              keyColor = "#f265b5";
              format = "{pretty-name}";
            }
            {
              type = "wm";
              key = "󰖲 WM";
              keyColor = "#59d1c6";
              format = "{pretty-name} {version}";
            }
            {
              type = "custom";
              key = "󰛖 FONT";
              format = "NeonMono";
            }
            {
              type = "localip";
              key = "󰩠 IP";
              keyColor = "#2dd4bf";
              format = "{ipv4}";
            }
            {
              type = "uptime";
              key = "󰥔 UP";
              keyColor = "#7081d0";
            }
            {
              type = "memory";
              key = "󰍛 RAM";
              keyColor = "#f16c75";
              format = "{used} / {total} ({percentage})";
            }
            {
              type = "disk";
              folders = "/";
              key = "󰋊 SSD";
              keyColor = "#ebfafa";
              format = "{size-used} / {size-total} ({size-percentage})";
            }
            "break"
            {
              type = "custom";
              format = "${esc}[44m  ${esc}[46m  ${esc}[42m  ${esc}[43m  ${esc}[41m  ${esc}[45m  ${esc}[105m  ${esc}[101m  ${esc}[103m  ${esc}[102m  ${esc}[106m  ${esc}[104m  ${esc}[0m";
            }
            "break"
          ];
        };
      };
    };
}
