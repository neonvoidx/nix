{
  autoGroups = {
    checktime = { };
    resize_splits = { };
    last_loc = { };
    close_with_q = { };
    wrap = { };
    spell = { };
    auto_create_dir = { };
    NumberToggle = { };
    highlight-yank = { };
    RestoreCursor = { };
  };
  autoCmd = [
    {
      event = [ "FocusGained" "TermClose" "TermLeave" ];
      group = "checktime";
      command = "checktime";
    }
    {
      event = [ "VimResized" ];
      group = "resize_splits";
      callback = {
        __raw = # lua
          ''
            function()
              local current_tab = vim.fn.tabpagenr()
              vim.cmd("tabdo wincmd =")
              vim.cmd("tabnext " .. current_tab)
            end
          '';
      };
    }
    {
      event = "BufReadPost";
      group = "last_loc";
      callback = {
        __raw = # lua
          ''
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
      };
    }
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
      callback = {
        __raw = # lua
          ''
            function(event)
              vim.bo[event.buf].buflisted = false
              vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
            end
          '';
      };
    }
    {
      event = "FileType";
      group = "wrap";
      pattern = [ "gitcommit" "markdown" "snacks_notif_history" "trouble" ];
      callback = {
        __raw = # lua
          ''
            function()
              vim.opt_local.wrap = true
              vim.opt_local.linebreak = true
            end
          '';
      };
    }
    {
      event = "FileType";
      group = "spell";
      pattern = [ "gitcommit" "markdown" ];
      callback = {
        __raw = # lua
          ''
            function()
              vim.opt_local.spell = true
            end
          '';
      };
    }
    {
      event = [ "BufWritePre" ];
      group = "auto_create_dir";
      callback = {
        __raw = # lua
          ''
            function(event)
              if event.match:match("^%w%w+://") then
                return
              end
              local file = vim.loop.fs_realpath(event.match) or event.match
              vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
            end
          '';
      };
    }
    {
      event = [ "InsertLeave" ];
      group = "NumberToggle";
      pattern = "*";
      callback = {
        __raw = # lua
          ''
            function()
              local ignore = { "oil", "fzf" }
              if ignore[vim.bo.filetype] then
                return
              end
              vim.wo.relativenumber = true
            end
          '';
      };
    }
    {
      event = [ "InsertEnter" ];
      group = "NumberToggle";
      pattern = "*";
      callback = {
        __raw = # lua
          ''
            function()
              local ignore = { "fzf" }
              if ignore[vim.bo.filetype] then
                return
              end
              vim.wo.relativenumber = false
            end
          '';
      };
    }
    {
      event = "FileType";
      pattern = [ "gitcommit" "markdown" ];
      callback = {
        __raw = # lua
          ''
            function(event)
              vim.keymap.set("i", "`", "`", { buffer = event.buf })
              vim.b.ai_cmp = false
            end
          '';
      };
    }
    {
      event = "BufEnter";
      pattern = "copilot-*";
      callback = {
        __raw = # lua
          ''
            function()
              vim.opt_local.relativenumber = false
              vim.opt_local.number = false
              vim.opt_local.conceallevel = 0
            end
          '';
      };
    }
    {
      event = "TextYankPost";
      group = "highlight-yank";
      callback = {
        __raw = # lua
          ''
            function()
              vim.hl.on_yank()
            end
          '';
      };
    }
    {
      event = "BufReadPre";
      group = "RestoreCursor";
      callback = {
        __raw = # lua
          ''
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
      };
    }
  ];
}
