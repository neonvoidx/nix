{ pkgs, ... }: {
  programs.nixvim = {
    plugins.yazi = {
      enable = true;
      settings = {
        open_for_directories = true;
        pick_window_implementation = "snacks.picker";
        integrations = { grep_in_directory = "snacks.picker"; };
        keymaps = { show_help = "<f1>"; };
      };
    };

    keymaps = [
      {
        key = "<leader>e";
        mode = [ "n" "v" ];
        action = "<cmd>Yazi<cr>";
        options.desc = "Yazi (current location)";
      }
      {
        key = "<leader>E";
        action = "<cmd>Yazi cwd<cr>";
        options.desc = "Yazi (cwd)";
      }
    ];
  };
}
