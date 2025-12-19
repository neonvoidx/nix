{ ... }:
{
  plugins.yazi = {
    enable = true;
    settings = {
      open_for_directors = true;
      pick_window_implementation = "snacks.picker";
      integrations = {
        grep_in_directory = "snacks.picker";
      };
      keymaps = {
        show_help = "<f1>";
      };
    };
    # luaConfig.pre = ''
    #   function()
    #     vim.g.loaded_netrwPlugin = 1
    #   end
    # '';
  };
  keymaps = [
    {
      key = "<leader>e";
      options = {
        silent = true;
        desc = "Yazi (current loc)";
      };
      mode = [
        "n"
        "v"
      ];
      action = "<cmd>Yazi<cr>";
    }
    {
      key = "<leader>E";
      options = {
        silent = true;
        desc = "Yazi (cwd)";
      };
      mode = [
        "n"
        "v"
      ];
      action = "<cmd>Yazi cwd<cr>";
    }
  ];
}
