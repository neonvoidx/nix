{ ... }:
{
  plugins = {
    web-devicons.enable = true;
    tiny-inline-diagnostic = {
      enable = true;
      settings = {
        show_source = {
          enabled = true;
        };
        multilines = {
          enabled = true;
        };
        add_messages = {
          display_count = true;
        };
      };
      luaConfig.post = "vim.diagnostic.config({ virtual_text = false }) -- Disable Neovim's default virtual text diagnostics";
    };
    trouble = {
      enable = true;
      settings = {
        modes = {
          diagnostics_buffer = {
            mode = "diagnostics";
            preview = {
              type = "float";
              relative = "editor";
              border = "rounded";
              title = "Preview";
              title_pos = "center";
              position = [
                0
                (-2)
              ];
              size = {
                width = 0.4;
                height = 0.4;
              };
              zindex = 200;
            };
            filter = {
              buf = 0;
            };
          };
        };
      };
    };
    lint = {
      enable = true;
      lintersByFt = {
        typescript = [ "eslint_d" ];
      };
    };
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>xX";
      action = "<cmd>Trouble diagnostics toggle<cr>";
      options.desc = "Diagnostics (Trouble)";
    }
    {
      mode = "n";
      key = "<leader>xx";
      action = "<cmd>Trouble diagnostics toggle filter.buf=0<cr>";
      options.desc = "Buffer Diagnostics (Trouble)";
    }
    {
      mode = "n";
      key = "<leader>cs";
      action = "<cmd>Trouble symbols toggle focus=false<cr>";
      options.desc = "Symbols (Trouble)";
    }
    {
      mode = "n";
      key = "<leader>cl";
      action = "<cmd>Trouble lsp toggle focus=false win.position=right<cr>";
      options.desc = "LSP Definitions / references / ... (Trouble)";
    }
    {
      mode = "n";
      key = "<leader>xl";
      action = "<cmd>Trouble loclist toggle<cr>";
      options.desc = "Location List (Trouble)";
    }
    {
      mode = "n";
      key = "<leader>xq";
      action = "<cmd>Trouble qflist toggle<cr>";
      options.desc = "Quickfix List (Trouble)";
    }
  ];
}
