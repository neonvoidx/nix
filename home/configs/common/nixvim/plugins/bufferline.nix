{ ... }:
{
  plugins.bufferline = {
    enable = true;
    settings = {
      options = {
        themable = true;
        mode = "buffers";
        indicator = {
          style = "none";
        };
        color_icons = true;
        separator_style = "thin";
        show_tab_indicators = false;
        show_buffer_icons = true;
        show_duplicate_prefix = false;
        max_name_length = 16;
        max_prefix_length = 10;
        tab_size = 25;
        truncate_names = true;
        hover = {
          enabled = true;
          delay = 100;
          reveal = [ "close" ];
        };
        diagnostics = "nvim_lsp";
        always_show_bufferline = true;
        diagnostics_update_on_event = true;
        groups = {
          options = {
            toggle_hidden_on_enter = true;
          };
        };
      };
    };
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>bp";
      action = "<Cmd>BufferLineTogglePin<CR>";
      options.desc = "Toggle pin";
    }
    {
      mode = "n";
      key = "<leader>bP";
      action = "<Cmd>BufferLineGroupClose ungrouped<CR>";
      options.desc = "Delete non-pinned buffers";
    }
    {
      mode = "n";
      key = "<leader>bo";
      action = "<Cmd>BufferLineCloseOthers<CR>";
      options.desc = "Delete other buffers";
    }
    {
      mode = "n";
      key = "<leader>br";
      action = "<Cmd>BufferLineCloseRight<CR>";
      options.desc = "Delete buffers to the right";
    }
    {
      mode = "n";
      key = "<leader>bl";
      action = "<Cmd>BufferLineCloseLeft<CR>";
      options.desc = "Delete buffers to the left";
    }
    {
      mode = "n";
      key = "<S-h>";
      action = "<cmd>BufferLineCyclePrev<cr>";
      options.desc = "Prev buffer";
    }
    {
      mode = "n";
      key = "<S-l>";
      action = "<cmd>BufferLineCycleNext<cr>";
      options.desc = "Next buffer";
    }
    {
      mode = "n";
      key = "<S-Right>";
      action = "<cmd>BufferLineMoveNext<cr>";
      options.desc = "Move buffer right";
    }
    {
      mode = "n";
      key = "<S-Left>";
      action = "<cmd>BufferLineMovePrev<cr>";
      options.desc = "Move buffer left";
    }
    {
      mode = "n";
      key = "[b";
      action = "<cmd>bprevious<cr>";
      options.desc = "Prev buffer";
    }
    {
      mode = "n";
      key = "]b";
      action = "<cmd>bnext<cr>";
      options.desc = "Next buffer";
    }
  ];
}
