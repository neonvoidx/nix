{ ... }:
{
  plugins = {
    obsidian = {
      enable = true;
      settings = {
        attachments = {
          image_text_func = ''
            function(path)
              local name = vim.fs.basename(tostring(path))
              local encoded_name = require("obsidian.util").urlencode(name)
              return string.format("![%s](%s)", name, encoded_name)
            end
          '';
          img_folder = "./";
        };
        legacy_commands = false;
        checkbox = {
          order = [
            " "
            "x"
            "!"
            ">"
            "~"
          ];
        };
        ui = {
          enable = false;
          external = {
            enable = true;
          };
        };
        workspaces = [
          {
            name = "vault";
            path = "~/vault";
          }
        ];
        daily_notes = {
          folder = "Daily Notes";
          date_format = "%d %b %Y";
          template = "~/vault/templates/daily-note.md";
        };
        completion = {
          nvim_cmp = false;
          blink = true;
        };
        preferred_link_style = "markdown";
        disable_frontmatter = false;
        templates = {
          folder = "templates";
          date_format = "%d %b %Y";
        };
        follow_url_func = ''
          function(url)
            vim.ui.open(url)
          end
        '';
        picker = {
          name = "snacks.pick";
          new = "<C-x>";
          insert_link = "<C-l>";
        };
        tag_mappings = {
          tag_note = "<C-x>";
          insert_tag = "<C-l>";
        };
      };
    };

    # markdown-preview.nvim for live preview
    markdown-preview = {
      enable = true;
      settings = {
        browser = "default";
        theme = "dark";
      };
    };

    # render-markdown.nvim for enhanced rendering
    render-markdown = {
      enable = true;
      settings = {
        file_types = [
          "markdown"
          "codecompanion"
        ];
        anti_conceal = {
          enabled = true;
          ignore = {
            code_background = true;
            sign = true;
          };
        };
        preset = "obsidian";
        bullet = {
          right_pad = 1;
        };
        checkbox = {
          enabled = true;
          unchecked = {
            icon = "▢ ";
          };
          checked = {
            icon = "✓ ";
          };
          custom = {
            todo = {
              rendered = "◯ ";
            };
          };
          right_pad = 1;
        };
      };
    };
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>cp";
      action = "<cmd>MarkdownPreview<cr>";
      options.desc = "Markdown preview";
    }
    # Obsidian keymaps
    {
      mode = "n";
      key = "<leader>oo";
      action = "<cmd>ObsidianOpen<cr>";
      options.desc = "Open on App";
    }
    {
      mode = "n";
      key = "<leader>sO";
      action = "<cmd>ObsidianSearch<cr>";
      options.desc = "Obsidian Grep";
    }
    {
      mode = "n";
      key = "<leader>on";
      action = "<cmd>ObsidianNew<cr>";
      options.desc = "New Note";
    }
    {
      mode = "n";
      key = "<leader>o<space>";
      action = "<cmd>ObsidianQuickSwitch<cr>";
      options.desc = "Find Files";
    }
    {
      mode = "n";
      key = "<leader>ob";
      action = "<cmd>ObsidianBacklinks<cr>";
      options.desc = "Backlinks";
    }
    {
      mode = "n";
      key = "<leader>ot";
      action = "<cmd>ObsidianTags<cr>";
      options.desc = "Tags";
    }
    {
      mode = "n";
      key = "<leader>oT";
      action = "<cmd>ObsidianTemplate<cr>";
      options.desc = "Template";
    }
    {
      mode = "v";
      key = "<leader>ol";
      action = "<cmd>ObsidianLink<cr>";
      options.desc = "Link";
    }
    {
      mode = "n";
      key = "<leader>oL";
      action = "<cmd>ObsidianLinks<cr>";
      options.desc = "Links";
    }
    {
      mode = "v";
      key = "<leader>oN";
      action = "<cmd>ObsidianLinkNew<cr>";
      options.desc = "New Link";
    }
    {
      mode = "v";
      key = "<leader>oe";
      action = "<cmd>ObsidianExtractNote<cr>";
      options.desc = "Extract Note";
    }
    {
      mode = "n";
      key = "<leader>ow";
      action = "<cmd>ObsidianWorkspace<cr>";
      options.desc = "Workspace";
    }
    {
      mode = "n";
      key = "<leader>or";
      action = "<cmd>ObsidianRename<cr>";
      options.desc = "Rename";
    }
    {
      mode = "n";
      key = "<leader>oi";
      action = "<cmd>ObsidianPasteImg<cr>";
      options.desc = "Paste Image";
    }
    {
      mode = "n";
      key = "<leader>od";
      action = "<cmd>ObsidianDailies<cr>";
      options.desc = "Daily Notes";
    }
  ];
}
