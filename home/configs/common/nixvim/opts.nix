{ ... }:
{
  clipboard.register = "unnamedplus";
  providers.wl-copy.enable = true;
  globals.mapleader = " ";
  autoCmd = [
    {
      event = [ "BufReadPost" ];
      pattern = [ "*" ];
      callback.__raw = ''
        function()
          local mark = vim.api.nvim_buf_get_mark(0, '"')
          local lcount = vim.api.nvim_buf_line_count(0)
          if mark[1] > 0 and mark[1] <= lcount then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
          end
        end
      '';
    }
  ];
  globalOpts = {
    termguicolors = true;
    shiftwidth = 2;
    undofile = true;
    swapfile = false;
    backup = false;
    autoread = true;
    cursorline = true;
    ruler = true;
  };
  diagnostics = {
    virtual_text = true;
    signs = {
      text = {
        "vim.diagnostic.severity.ERROR" = "";
        "vim.diagnostic.severity.WARN" = "";
        "vim.diagnostic.severity.INFO" = "󰋼";
        "vim.diagnostic.severity.HINT" = "󰌵";
      };
    };
    update_in_insert = true;
    severity_sort = true;
    float = {
      border = "rounded";
      format.__raw = ''
        function(d)
          return ("%s (%s) [%s]"):format(d.message, d.source, d.code or d.user_data.lsp.code)
        end
      '';
    };
    jump = {
      severity.__raw = "vim.diagnostic.severity.WARN";
    };
  };
  opts = {
    winborder = "rounded";
    autowrite = true;
    autoread = true;
    completeopt = "menu,menuone,noselect";
    conceallevel = 1;
    confirm = true;
    cursorline = true;
    expandtab = true;
    formatoptions = "jcroqlnt";
    grepformat = "%f:%l:%c:%m";
    grepprg = "rg";
    ignorecase = true;
    inccommand = "nosplit";
    laststatus = 3;
    list = true;
    mouse = "nv";
    mousemoveevent = true;
    number = true;
    pumblend = 10;
    pumheight = 10;
    relativenumber = true;
    scrolloff = 4;
    shiftround = true;
    shiftwidth = 2;
    showmode = false;
    sidescrolloff = 8;
    signcolumn = "yes";
    smartcase = true;
    smartindent = true;
    spelllang = "en";
    splitbelow = true;
    splitkeep = "screen";
    splitright = true;
    tabstop = 2;
    termguicolors = true;
    timeoutlen = 300;
    undofile = true;
    undolevels = 10000;
    updatetime = 200;
    virtualedit = "block";
    wildmode = "longest:full,full";
    winminwidth = 5;
    wrap = false;
    autochdir = false;
    smoothscroll = true;
  };
}
