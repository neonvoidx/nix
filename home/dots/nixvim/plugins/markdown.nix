{ pkgs, ... }: {
  programs.nixvim = {
    # Obsidian
    plugins.obsidian = {
      enable = false;
      settings = {
        workspaces = [
          {
            name = "vault";
            path = "~/vault";
          }
          {
            name = "blog";
            path = "~/homepage";
          }
        ];
      };
    };
    plugins.markdown-preview = { enable = true; };
    # Render Markdown
    plugins.render-markdown = {
      enable = true;
      settings = {
        file_types = [ "markdown" "codecompanion" ];
        anti_conceal = {
          enabled = true;
          ignore = {
            code_background = true;
            sign = true;
          };
        };
        completions = { blink = { enabled = true; }; };
        preset = "obsidian";
        bullet = { right_pad = 1; };
        checkbox = {
          enabled = true;
          unchecked = { icon = "▢ "; };
          checked = { icon = "✓ "; };
          custom = { todo = { rendered = "◯ "; }; };
          right_pad = 1;
        };
      };
    };
    keymaps = [
      # Markdown Preview
      {
        key = "<leader>cp";
        action = "<cmd>MarkdownPreview<cr>";
        options.desc = "Markdown preview";
      }
      # Obsidian keymaps
      {
        key = "<leader>oo";
        action = "<cmd>Obsidian open<CR>";
        options.desc = "Open on App";
      }
      {
        key = "<leader>sO";
        action = "<cmd>Obsidian search<CR>";
        options.desc = "Obsidian Grep";
      }
      {
        key = "<leader>on";
        action = "<cmd>Obsidian new<CR>";
        options.desc = "New Note";
      }
      {
        key = "<leader>o<space>";
        action = "<cmd>Obsidian quick_switch<CR>";
        options.desc = "Find Files";
      }
      {
        key = "<leader>ob";
        action = "<cmd>Obsidian backlinks<CR>";
        options.desc = "Backlinks";
      }
      {
        key = "<leader>ot";
        action = "<cmd>Obsidian tags<CR>";
        options.desc = "Tags";
      }
      {
        key = "<leader>oT";
        action = "<cmd>Obsidian template<CR>";
        options.desc = "Template";
      }
      {
        key = "<leader>ol";
        mode = "v";
        action = "<cmd>Obsidian link<CR>";
        options.desc = "Link";
      }
      {
        key = "<leader>oL";
        action = "<cmd>Obsidian links<CR>";
        options.desc = "Links";
      }
      {
        key = "<leader>oN";
        mode = "v";
        action = "<cmd>Obsidian link_new<CR>";
        options.desc = "New Link";
      }
      {
        key = "<leader>oe";
        mode = "v";
        action = "<cmd>Obsidian extract_note<CR>";
        options.desc = "Extract Note";
      }
      {
        key = "<leader>ow";
        action = "<cmd>Obsidian workspace<CR>";
        options.desc = "Workspace";
      }
      {
        key = "<leader>oR";
        action = "<cmd>Obsidian rename<CR>";
        options.desc = "Rename";
      }
      {
        key = "<leader>oi";
        action = "<cmd>Obsidian paste_image<CR>";
        options.desc = "Paste Image";
      }
      {
        key = "<leader>od";
        action = "<cmd>Obsidian dailies<CR>";
        options.desc = "Daily Notes";
      }
    ];
  };
}
