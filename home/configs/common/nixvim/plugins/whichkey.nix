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
          icon = " ";
        }
        {
          __unkeyed-1 = "<leader>p";
          group = "Yanky";
          icon = " ";
        }
        {
          __unkeyed-1 = "<leader>a";
          group = "ai";
          icon = " ";
        }
        {
          __unkeyed-1 = "<leader>.";
          group = "scratch";
          icon = "";
        }
        {
          __unkeyed-1 = "<leader>S";
          group = "snippets";
          icon = "✀";
        }
        {
          __unkeyed-1 = "<leader>n";
          group = "notifications";
          icon = " ";
        }
        {
          __unkeyed-1 = "<leader>L";
          group = "LSP";
          icon = " ";
        }
        {
          __unkeyed-1 = "<leader>o";
          group = "Overseer";
          icon = "";
        }
        {
          __unkeyed-1 = "<leader>b";
          group = "Buffer";
          icon = "";
        }
      ];
    };
  };
}
