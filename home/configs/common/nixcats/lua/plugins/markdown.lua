return {
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = "cd app && yarn install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    keys = {
      { "<leader>cp", "<cmd>MarkdownPreview<cr>", desc = "Markdown preview" },
    },
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "codecompanion", "markdown", "copilot-chat", "rmd", "norg", "org" },
    opts = {
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
    },
  },
  {
    "obsidian-nvim/obsidian.nvim",
    version = "*",
    lazy = true,
    event = "VimEnter",
    cond = function()
      -- Check if the current working directory is within the vault
      local cwd = vim.fn.getcwd()
      local vault_path = vim.fn.expand("~/vault")
      local blog_path = vim.fn.expand("~/homepage")
      return vim.startswith(cwd, vault_path) or vim.startswith(cwd, blog_path)
    end,
    config = function(_, opts)
      local wk = require("which-key")
      wk.add({
        { "<leader>o", group = "Obsidian", icon = "" },
      })
      local prefix = "<leader>o"

      local mappings = {
        { prefix .. "o", "<cmd>Obsidian open<CR>", desc = "Open on App" },
        { "<leader>sO", "<cmd>Obsidian search<CR>", desc = "Obsidian Grep" },
        { prefix .. "n", "<cmd>Obsidian new<CR>", desc = "New Note" },
        { prefix .. "<space>", "<cmd>Obsidian quickswitch<CR>", desc = "Find Files" },
        { prefix .. "b", "<cmd>Obsidian backlinks<CR>", desc = "Backlinks" },
        { prefix .. "t", "<cmd>Obsidian tags<CR>", desc = "Tags" },
        { prefix .. "T", "<cmd>Obsidian template<CR>", desc = "Template" },
        { prefix .. "l", "<cmd>Obsidian link<CR>", mode = "v", desc = "Link" },
        { prefix .. "L", "<cmd>Obsidian links<CR>", desc = "Links" },
        { prefix .. "N", "<cmd>Obsidian linknew<CR>", mode = "v", desc = "New Link" },
        { prefix .. "e", "<cmd>Obsidian extractnote<CR>", mode = "v", desc = "Extract Note" },
        { prefix .. "w", "<cmd>Obsidian workspace<CR>", desc = "Workspace" },
        { prefix .. "r", "<cmd>Obsidian rename<CR>", desc = "Rename" },
        { prefix .. "i", "<cmd>Obsidian paste_img<CR>", desc = "Paste Image" },
        { prefix .. "d", "<cmd>Obsidian dailies<CR>", desc = "Daily Notes" },
      }

      -- Set up the plugin
      require("obsidian").setup(opts)

      -- Register keymaps
      for _, mapping in ipairs(mappings) do
        local mode = mapping.mode or "n"
        vim.keymap.set(mode, mapping[1], mapping[2], { desc = mapping.desc })
      end
    end,
    opts = {
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
        -- Open the URL in the default web browser.
        -- vim.fn.jobstart({ "open", url }) -- Mac OS
        -- vim.fn.jobstart({"xdg-open", url})  -- linux
        -- vim.cmd(':silent exec "!start ' .. url .. '"') -- Windows
        vim.ui.open(url) -- need Neovim 0.10.0+
      end,
      picker = {
        name = "snacks.pick",
        new = "<C-x>",
        -- Insert a link to the selected note.
        insert_link = "<C-l>",
      },
      tag_mappings = {
        -- Add tag(s) to current note.
        tag_note = "<C-x>",
        -- Insert a tag at the current location.
        insert_tag = "<C-l>",
      },
    },
  },
  {
    "sotte/presenting.nvim",
    opts = {
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
    },
    cmd = { "Presenting" },
  },
  {
    "hedyhli/markdown-toc.nvim",
    ft = "markdown",
    opts = {
      heading = { before_toc = false },
      auto_update = true,
    },
  },
}
