return {
  "akinsho/bufferline.nvim",
  version = "*",
  dependencies = { "nvim-tree/nvim-web-devicons", "folke/which-key.nvim" },
  event = { "BufReadPost", "BufAdd", "BufNewFile" },
  opts = {
    options = {
      themable = true,
      mode = "buffers",
      indicator = {
        style = "none",
      },
      color_icons = true,
      separator_style = "thin",
      show_tab_indicators = false,
      show_buffer_icons = true,
      show_duplicate_prefix = false,
      max_name_length = 16,
      max_prefix_length = 10,
      tab_size = 25,
      name_formatter = function(buf)
        local name = buf.name or ""
        return name:gsub("intent%.[%w_]+%.", "🛈")
      end,
      truncate_names = true,
      hover = {
        enabled = true,
        delay = 100,
        reveal = { "close" },
      },
      diagnostics = "nvim_lsp",
      always_show_bufferline = true,
      diagnostics_update_on_event = true, -- use nvim's diagnostic handler
      groups = {
        options = {
          toggle_hidden_on_enter = true,
        },
      },
    },
  },
  keys = function()
    local wk = require("which-key")
    wk.add({ { "<leader>b", group = "Buffer", icon = "" } })
    return {
      { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle pin" },
      { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete non-pinned buffers" },
      { "<leader>bo", "<Cmd>BufferLineCloseOthers<CR>", desc = "Delete other buffers" },
      { "<leader>br", "<Cmd>BufferLineCloseRight<CR>", desc = "Delete buffers to the right" },
      { "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>", desc = "Delete buffers to the left" },
      { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev buffer" },
      { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer" },
      { "<S-Right>", "<cmd>BufferLineMoveNext<cr>", desc = "Move buffer right" },
      { "<S-Left>", "<cmd>BufferLineMovePrev<cr>", desc = "Move buffer left" },
      { "[b", "<cmd>bprevious<cr>", desc = "Prev buffer" },
      { "]b", "<cmd>bnext<cr>", desc = "Next buffer" },
    }
  end,
}
