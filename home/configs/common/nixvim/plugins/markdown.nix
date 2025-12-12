{ ... }:
{
  plugins = {
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
        file_types = [ "markdown" "codecompanion" ];
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
  ];
}
