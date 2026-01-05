{ ... }:
{
  plugins.which-key = {
    enable = true;
    settings = {
      preset = "helix";
      delay = 0;
      spec = [
        {
          __unkeyed-1 = "<leader>w";
          group = "window";
          icon = "󱂬";
        }
        {
          __unkeyed-1 = "<leader>p";
          group = "Yanky";
          icon = "󰅇";
        }
        {
          __unkeyed-1 = "<leader>a";
          group = "ai";
          icon = "󰧑";
        }
        {
          __unkeyed-1 = "<leader>.";
          group = "scratch";
          icon = "󱓡";
        }
        {
          __unkeyed-1 = "<leader>S";
          group = "snippets";
          icon = "󰩫";
        }
        {
          __unkeyed-1 = "<leader>n";
          group = "notifications";
          icon = "󰂚";
        }
        {
          __unkeyed-1 = "<leader>l";
          group = "LSP";
          icon = "󰒋";
        }
        {
          __unkeyed-1 = "<leader>o";
          group = "Overseer";
          icon = "󰜎";
        }
        {
          __unkeyed-1 = "<leader>b";
          group = "Buffer";
          icon = "󰓩";
        }
        {
          __unkeyed-1 = "<leader>c";
          group = "code";
          icon = "󰨞";
        }
        {
          __unkeyed-1 = "<leader>f";
          group = "find";
          icon = "󰍉";
        }
        {
          __unkeyed-1 = "<leader>g";
          group = "git";
          icon = "󰊢";
        }
        {
          __unkeyed-1 = "<leader>s";
          group = "search";
          icon = "󰱼";
        }
        {
          __unkeyed-1 = "<leader>u";
          group = "ui";
          icon = "󰙵";
        }
        {
          __unkeyed-1 = "<leader>z";
          group = "zen";
          icon = "󰰶";
        }
        {
          __unkeyed-1 = "<leader>r";
          group = "restart";
          icon = "󰑓";
        }
        {
          __unkeyed-1 = "<leader>e";
          group = "explorer";
          icon = "󰙅";
        }
        {
          __unkeyed-1 = "<leader>x";
          group = "trouble";
          icon = "";
        }
        {
          __unkeyed-1 = "<leader>N";
          icon = "";
        }
        {
          __unkeyed-1 = "<leader>E";
          icon = "";
        }
        {
          __unkeyed-1 = "<leader>/";
          icon = "";
        }
        {
          __unkeyed-1 = "<leader>:";
          icon = "";
        }
      ];
    };
  };
}
