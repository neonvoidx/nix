{
  # UI plugins configuration

  plugins = {
    # Status line
    lualine = {
      enable = true;
      settings = {
        options = {
          theme = "auto";
          component_separators = {
            left = "";
            right = "";
          };
          section_separators = {
            left = "";
            right = "";
          };
          globalstatus = true;
        };
      };
    };

    # Buffer tabs
    bufferline = {
      enable = true;
      settings = {
        options = {
          mode = "buffers";
          separator_style = "thin";
          always_show_bufferline = true;
          show_buffer_close_icons = true;
          show_close_icon = false;
          color_icons = true;
          diagnostics = "nvim_lsp";
        };
      };
    };

    # Enhanced UI for messages, cmdline and popups
    noice = {
      enable = true;
      settings = {
        lsp = {
          override = {
            "vim.lsp.util.convert_input_to_markdown_lines" = true;
            "vim.lsp.util.stylize_markdown" = true;
            "cmp.entry.get_documentation" = true;
          };
        };
        presets = {
          bottom_search = true;
          command_palette = true;
          long_message_to_split = true;
          inc_rename = false;
          lsp_doc_border = true;
        };
      };
    };

    # Keybinding hints
    which-key = {
      enable = true;
      settings = {
        delay = 300;
        preset = "modern";
        spec = [
          {
            __unkeyed-1 = "<leader>b";
            group = "+buffers";
            icon = { icon = " "; };
          }
          {
            __unkeyed-1 = "<leader>f";
            group = "+find";
            icon = { icon = " "; };
          }
          {
            __unkeyed-1 = "<leader>g";
            group = "+git";
            icon = { icon = " "; };
          }
          {
            __unkeyed-1 = "<leader>l";
            group = "+lsp";
            icon = { icon = " "; };
          }
          {
            __unkeyed-1 = "<leader>s";
            group = "+search";
            icon = { icon = " "; };
          }
          {
            __unkeyed-1 = "<leader>t";
            group = "+toggle";
            icon = { icon = " "; };
          }
          {
            __unkeyed-1 = "<leader>u";
            group = "+ui";
            icon = { icon = " "; };
          }
          {
            __unkeyed-1 = "<leader>w";
            group = "+windows";
            icon = { icon = " "; };
          }
        ];
      };
    };

    # Web devicons - file icons
    web-devicons = { enable = true; };

    # Color highlighter
    nvim-colorizer = {
      enable = true;
      userDefaultOptions = {
        RGB = true;
        RRGGBB = true;
        names = true;
        RRGGBBAA = true;
        rgb_fn = true;
        hsl_fn = true;
        css = true;
        css_fn = true;
        mode = "background";
      };
    };

    # Todo comments
    todo-comments = {
      enable = true;
      settings = {
        signs = true;
        keywords = {
          FIX = {
            icon = " ";
            color = "error";
            alt = [ "FIXME" "BUG" "FIXIT" "ISSUE" ];
          };
          TODO = {
            icon = " ";
            color = "info";
          };
          HACK = {
            icon = " ";
            color = "warning";
          };
          WARN = {
            icon = " ";
            color = "warning";
            alt = [ "WARNING" "XXX" ];
          };
          PERF = {
            icon = " ";
            alt = [ "OPTIM" "PERFORMANCE" "OPTIMIZE" ];
          };
          NOTE = {
            icon = " ";
            color = "hint";
            alt = [ "INFO" ];
          };
        };
      };
    };

    # Enhanced help viewer
    helpview = { enable = true; };
  };

  # Additional UI configuration
  extraConfigLua = # lua
    ''
      -- Lazy keymap for plugin manager
      vim.keymap.set("n", "<leader>L", "<cmd>Lazy<cr>", { silent = true, desc = "Lazy" })
    '';
}
