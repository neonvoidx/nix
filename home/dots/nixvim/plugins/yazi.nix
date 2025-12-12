{ pkgs, ... }:
{
  programs.nixvim = {
    extraPlugins = with pkgs.vimPlugins; [
      {
        plugin = pkgs.vimUtils.buildVimPlugin {
          name = "yazi-nvim";
          src = pkgs.fetchFromGitHub {
            owner = "mikavilpas";
            repo = "yazi.nvim";
            rev = "7c2ba07f5e4a52ee6a6f8e6010e4f60b892bcd93";
            hash = "sha256-FocLi4vEilGCNXy/h8eLQHN5OGxpVgZvAa1kBvMIBaE=";
          };
        };
        config = ''
          lua << EOF
          require("yazi").setup({
            open_for_directories = true,
            pick_window_implementation = "snacks.picker",
            integrations = {
              grep_in_directory = "snacks.picker",
            },
            keymaps = {
              show_help = "<f1>",
            },
          })
          vim.g.loaded_netrwPlugin = 1
          EOF
        '';
      }
      plenary-nvim
    ];

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
