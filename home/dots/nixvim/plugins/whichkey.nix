{ ... }:
{
  programs.nixvim = {
    plugins = {
      which-key = {
        enable = true;
        settings = {
          preset = "helix";
          delay = 0;
          spec = [
            {
              __unkeyed-1 = "<leader>w";
              group = "+window";
              icon = " ";
            }
            {
              __unkeyed-1 = "<leader>p";
              group = "+Yanky";
              icon = " ";
            }
            {
              __unkeyed-1 = "<leader>a";
              group = "+ai";
              icon = " ";
            }
            {
              __unkeyed-1 = "<leader>.";
              group = "+scratch";
              icon = "";
            }
            {
              __unkeyed-1 = "<leader>S";
              group = "+snippets";
              icon = "✀";
            }
            {
              __unkeyed-1 = "<leader>n";
              group = "+notifications";
              icon = " ";
            }
            {
              __unkeyed-1 = "<leader>l";
              group = "+LSP";
              icon = " ";
            }
            {
              __unkeyed-1 = "<leader>o";
              group = "+Overseer";
              icon = "";
            }
            {
              __unkeyed-1 = "<leader>c";
              group = "+code";
              icon = " ";
            }
            {
              __unkeyed-1 = "<leader>x";
              group = "+trouble";
              icon = " ";
            }
            {
              __unkeyed-1 = "<leader>f";
              group = "+find";
              icon = "󰍉 ";
            }
            {
              __unkeyed-1 = "<leader>g";
              group = "+git";
              icon = " ";
            }
            {
              __unkeyed-1 = "<leader>s";
              group = "+snacks";
              icon = "󰆘 ";
            }
            {
              __unkeyed-1 = "<leader>u";
              group = "+ui";
              icon = "󰍹 ";
            }
            {
              __unkeyed-1 = "<leader>b";
              group = "Buffer";
              icon = "";
            }
          ];
        };
      };
    };
  };
}
