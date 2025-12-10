{ ... }: {
  programs.nixvim = {
    autoGroups = {
      checktime = { };
      resize_splits = { };
      last_loc = { };
      close_with_q = { };
      wrap = { };
      spell = { };
      auto_create_dir = { };
      NumberToggle = { };
      RestoreCursor = { };
      highlight-yank = { };
    };

    autoCmd = [
      # Check if we need to reload the file when it changed
      {
        event = [ "FocusGained" "TermClose" "TermLeave" ];
        group = "checktime";
        command = "checktime";
      }

      # Resize splits if window got resized
      {
        event = "VimResized";
        group = "resize_splits";
        callback.__raw = ''
          function()
            local current_tab = vim.fn.tabpagenr()
            vim.cmd("tabdo wincmd =")
            vim.cmd("tabnext " .. current_tab)
          end
        '';
      }

      # Go to last loc when opening a buffer
      {
        event = "BufReadPost";
        group = "last_loc";
        callback.__raw = ''
          function(event)
            local exclude = { "gitcommit" }
            local buf = event.buf
            if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].autocmd_last_loc then
              return
            end
            vim.b[buf].autocmd_last_loc = true
            local mark = vim.api.nvim_buf_get_mark(buf, '"')
            local lcount = vim.api.nvim_buf_line_count(buf)
            if mark[1] > 0 and mark[1] <= lcount then
              pcall(vim.api.nvim_win_set_cursor, 0, mark)
            end
          end
        '';
      }

      # Close some filetypes with q
      {
        event = "FileType";
        group = "close_with_q";
        pattern = [
          "PlenaryTestPopup"
          "help"
          "lspinfo"
          "man"
          "notify"
          "qf"
          "query"
          "spectre_panel"
          "startuptime"
          "tsplayground"
          "neotest-output"
          "checkhealth"
          "neotest-summary"
          "neotest-output-panel"
          "lazy"
        ];
        callback.__raw = ''
          function(event)
            vim.bo[event.buf].buflisted = false
            vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
          end
        '';
      }

      # Wrap in text filetypes
      {
        event = "FileType";
        group = "wrap";
        pattern = [ "gitcommit" "markdown" "snacks_notif_history" "trouble" ];
        callback.__raw = ''
          function()
            vim.opt_local.wrap = true
            vim.opt_local.linebreak = true
          end
        '';
      }

      # Check for spelling in text filetypes
      {
        event = "FileType";
        group = "spell";
        pattern = [ "gitcommit" "markdown" ];
        callback.__raw = ''
          function()
            vim.opt_local.spell = true
          end
        '';
      }

      # Auto create dir when saving a file
      {
        event = "BufWritePre";
        group = "auto_create_dir";
        callback.__raw = ''
          function(event)
            if event.match:match("^%w%w+://") then
              return
            end
            local file = vim.loop.fs_realpath(event.match) or event.match
            vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
          end
        '';
      }

      # Toggle relative line numbers in insert mode
      {
        event = "InsertLeave";
        group = "NumberToggle";
        pattern = "*";
        callback.__raw = ''
          function()
            local ignore = { "oil", "fzf" }
            if ignore[vim.bo.filetype] then
              return
            end
            vim.wo.relativenumber = true
          end
        '';
        desc = "Turn on relative line numbering when the buffer is entered.";
      }
      {
        event = "InsertEnter";
        group = "NumberToggle";
        pattern = "*";
        callback.__raw = ''
          function()
            local ignore = { "oil", "fzf" }
            if ignore[vim.bo.filetype] then
              return
            end
            vim.wo.relativenumber = false
          end
        '';
        desc = "Turn off relative line numbering when the buffer is exited.";
      }

      # Disable copilot cmp for certain filetypes
      {
        event = "FileType";
        pattern = [ "gitcommit" "markdown" ];
        callback.__raw = ''
          function(event)
            vim.keymap.set("i", "`", "`", { buffer = event.buf })
            vim.b.ai_cmp = false
          end
        '';
      }

      # Buffer-local options for copilot buffers
      {
        event = "BufEnter";
        pattern = "copilot-*";
        callback.__raw = ''
          function()
            vim.opt_local.relativenumber = false
            vim.opt_local.number = false
            vim.opt_local.conceallevel = 0
          end
        '';
      }

      # Highlight when yanking text
      {
        event = "TextYankPost";
        group = "highlight-yank";
        callback.__raw = ''
          function()
            vim.hl.on_yank()
          end
        '';
        desc = "Highlight when yanking (copying) text";
      }

      # Restore cursor position
      {
        event = "BufReadPre";
        group = "RestoreCursor";
        callback.__raw = ''
          function(args)
            vim.api.nvim_create_autocmd("FileType", {
              buffer = args.buf,
              once = true,
              callback = function()
                local ft = vim.bo[args.buf].filetype
                local last_pos = vim.api.nvim_buf_get_mark(args.buf, '"')[1]
                local last_line = vim.api.nvim_buf_line_count(args.buf)
                if
                  last_pos >= 1
                  and last_pos <= last_line
                  and not ft:match("commit")
                  and not vim.tbl_contains({ "gitrebase", "nofile", "svn", "gitcommit" }, ft)
                then
                  vim.api.nvim_win_set_cursor(0, { last_pos, 0 })
                end
              end,
            })
          end
        '';
      }
    ];

    # Custom user commands
    extraConfigLua = ''
      vim.api.nvim_create_user_command("MasonUpgrade", function()
        local registry = require("mason-registry")
        registry.refresh()
        registry.update()
        local packages = registry.get_all_packages()
        for _, pkg in ipairs(packages) do
          if pkg:is_installed() then
            pkg:install()
          end
        end
        vim.cmd("doautocmd User MasonUpgradeComplete")
      end, { force = true })
    '';
  };
}
