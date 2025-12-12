{ pkgs, ... }:
{
  programs.nixvim = {
    extraPlugins = with pkgs.vimPlugins; [
      # Markdown Preview
      {
        plugin = pkgs.vimUtils.buildVimPlugin {
          name = "markdown-preview";
          src = pkgs.fetchFromGitHub {
            owner = "iamcco";
            repo = "markdown-preview.nvim";
            rev = "a923f5fc5ba36a3b17e289dc35dc17f66d0548ee";
            hash = "sha256-5NnVxO3ybMW1d+sAvL2d8OgzVvZt9Im7d52156dLHqo=";
          };
        };
        config = ''
          vim.g.mkdp_filetypes = { "markdown" }
        '';
      }
      # Render Markdown
      {
        plugin = pkgs.vimUtils.buildVimPlugin {
          name = "render-markdown";
          src = pkgs.fetchFromGitHub {
            owner = "MeanderingProgrammer";
            repo = "render-markdown.nvim";
            rev = "e6fb84a9e63e3e5f5f78fa15df16e8d13f94dbb7";
            hash = "sha256-JD22Rvp+Vd/gIqkRWJpR9hf4tXxO9NyWXHr5SMxVe1w=";
          };
        };
        config = ''
          lua << EOF
          require("render-markdown").setup({
            file_types = { "markdown", "codecompanion" },
            anti_conceal = {
              enabled = true,
              ignore = {
                code_background = true,
                sign = true,
              },
            },
            completions = { blink = { enabled = true } },
            preset = "obsidian",
            bullet = {
              right_pad = 1,
            },
            checkbox = {
              enabled = true,
              unchecked = { icon = "▢ " },
              checked = { icon = "✓ " },
              custom = { todo = { rendered = "◯ " } },
              right_pad = 1,
            },
          })
          EOF
        '';
      }
      # Obsidian
      {
        plugin = pkgs.vimUtils.buildVimPlugin {
          name = "obsidian-nvim";
          src = pkgs.fetchFromGitHub {
            owner = "epwalsh";
            repo = "obsidian.nvim";
            rev = "e6c35abce8d77f5a1df8730b0e2191ae2ae87a3e";
            hash = "sha256-YpQ+gDNzmFJMx1PNFV3zI+aS3lCUjCjI+VGO4/vwIyw=";
          };
        };
        config = ''
          lua << EOF
          require("obsidian").setup({
            attachments = {
              image_text_func = function(path)
                local name = vim.fs.basename(tostring(path))
                local encoded_name = require("obsidian.util").urlencode(name)
                return string.format("![%s](%s)", name, encoded_name)
              end,
              img_folder = "./",
            },
            legacy_commands = false,
            checkbox = {
              order = { " ", "x", "!", ">", "~" },
            },
            ui = {
              enable = false,
            },
            workspaces = {
              {
                name = "vault",
                path = vim.fn.expand("~/vault"),
              },
            },
            daily_notes = {
              folder = "Daily Notes",
              date_format = "%d %b %Y",
              template = vim.fn.expand("~/vault/templates/daily-note.md"),
            },
            completion = {
              nvim_cmp = false,
              blink = true,
            },
            preferred_link_style = "markdown",
            disable_frontmatter = false,
            templates = {
              folder = "templates",
              date_format = "%d %b %Y",
            },
            follow_url_func = function(url)
              vim.ui.open(url)
            end,
            picker = {
              name = "snacks.pick",
              new = "<C-x>",
              insert_link = "<C-l>",
            },
            tag_mappings = {
              tag_note = "<C-x>",
              insert_tag = "<C-l>",
            },
          })
          EOF
        '';
      }
      # Presenting
      {
        plugin = pkgs.vimUtils.buildVimPlugin {
          name = "presenting-nvim";
          src = pkgs.fetchFromGitHub {
            owner = "sotte";
            repo = "presenting.nvim";
            rev = "7dcbc4c9a0ee26d1c05dbc36e48dd5e1b7ebe8f8";
            hash = "sha256-Mv2oB/2RnTvhHfhEDc3Y+CRqzXvnpf7lAd4kgz8VxRs=";
          };
        };
        config = ''
          lua << EOF
          require("presenting").setup({
            options = {
              width = 100,
            },
            separator = {
              markdown = "^---",
            },
            keep_separator = false,
            parse_frontmatter = true,
            keymaps = {
              ["n"] = function()
                Presenting.next()
              end,
              ["p"] = function()
                Presenting.prev()
              end,
              ["q"] = function()
                Presenting.quit()
              end,
              ["f"] = function()
                Presenting.first()
              end,
              ["l"] = function()
                Presenting.last()
              end,
              ["<CR>"] = function()
                Presenting.next()
              end,
              ["<BS>"] = function()
                Presenting.prev()
              end,
            },
          })
          EOF
        '';
      }
      # Markdown TOC
      {
        plugin = pkgs.vimUtils.buildVimPlugin {
          name = "markdown-toc-nvim";
          src = pkgs.fetchFromGitHub {
            owner = "hedyhli";
            repo = "markdown-toc.nvim";
            rev = "1fcab86d9b5fa1ca88aa61c2fce0b7a73b982ef4";
            hash = "sha256-Vl/mCkbYhWoEZI9dLmQyVr3/e1N8jBfCrmhGJ0HHxrQ=";
          };
        };
        config = ''
          lua << EOF
          require("markdown-toc").setup({
            heading = { before_toc = false },
            auto_update = true,
          })
          EOF
        '';
      }
    ];

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
        action = "<cmd>ObsidianOpen<CR>";
        options.desc = "Open on App";
      }
      {
        key = "<leader>sO";
        action = "<cmd>ObsidianSearch<CR>";
        options.desc = "Obsidian Grep";
      }
      {
        key = "<leader>on";
        action = "<cmd>ObsidianNew<CR>";
        options.desc = "New Note";
      }
      {
        key = "<leader>o<space>";
        action = "<cmd>ObsidianQuickSwitch<CR>";
        options.desc = "Find Files";
      }
      {
        key = "<leader>ob";
        action = "<cmd>ObsidianBacklinks<CR>";
        options.desc = "Backlinks";
      }
      {
        key = "<leader>ot";
        action = "<cmd>ObsidianTags<CR>";
        options.desc = "Tags";
      }
      {
        key = "<leader>oT";
        action = "<cmd>ObsidianTemplate<CR>";
        options.desc = "Template";
      }
      {
        key = "<leader>ol";
        mode = "v";
        action = "<cmd>ObsidianLink<CR>";
        options.desc = "Link";
      }
      {
        key = "<leader>oL";
        action = "<cmd>ObsidianLinks<CR>";
        options.desc = "Links";
      }
      {
        key = "<leader>oN";
        mode = "v";
        action = "<cmd>ObsidianLinkNew<CR>";
        options.desc = "New Link";
      }
      {
        key = "<leader>oe";
        mode = "v";
        action = "<cmd>ObsidianExtractNote<CR>";
        options.desc = "Extract Note";
      }
      {
        key = "<leader>ow";
        action = "<cmd>ObsidianWorkspace<CR>";
        options.desc = "Workspace";
      }
      {
        key = "<leader>or";
        action = "<cmd>ObsidianRename<CR>";
        options.desc = "Rename";
      }
      {
        key = "<leader>oi";
        action = "<cmd>ObsidianPasteImg<CR>";
        options.desc = "Paste Image";
      }
      {
        key = "<leader>od";
        action = "<cmd>ObsidianDailies<CR>";
        options.desc = "Daily Notes";
      }
    ];
  };
}
