{ ... }: {
  programs.nixvim = {
    opts = {
      # Global options
      winborder = "rounded";

      # Editor options
      autowrite = true;
      autoread = true;
      clipboard = "unnamedplus";
      completeopt = "menu,menuone,noselect";
      conceallevel = 1;
      confirm = true;
      cursorline = true;
      expandtab = true;
      formatoptions = "jcroqlnt";

      # Search options
      grepformat = "%f:%l:%c:%m";
      grepprg = "rg --vimgrep";
      ignorecase = true;
      smartcase = true;

      # Preview options
      inccommand = "nosplit";

      # UI options
      laststatus = 3;
      list = true;
      mouse = "nv";
      mousemoveevent = true;
      number = true;
      relativenumber = true;
      pumblend = 10;
      pumheight = 10;
      scrolloff = 4;
      sidescrolloff = 8;
      showmode = false;
      signcolumn = "yes";

      # Split options
      splitbelow = true;
      splitright = true;
      splitkeep = "screen";

      # Indentation options
      shiftround = true;
      shiftwidth = 2;
      smartindent = true;
      tabstop = 2;

      # Spelling
      spelllang = "en";

      # Terminal options
      termguicolors = true;

      # Timing options
      timeoutlen = 300;
      updatetime = 200;

      # Undo options
      undofile = true;
      undolevels = 10000;

      # Other options
      virtualedit = "block";
      wildmode = "longest:full,full";
      winminwidth = 5;
      wrap = false;
      autochdir = false;

      # Session options
      sessionoptions =
        "buffers,curdir,tabpages,winsize,help,globals,skiprtp,folds";

      # Folding
      fillchars = {
        foldopen = "";
        foldclose = "";
        fold = " ";
        foldsep = " ";
        diff = "╱";
        eob = " ";
      };
    };

    # Enable smooth scroll on nvim >= 0.10
    extraConfigLua = # lua
      ''
        if vim.fn.has("nvim-0.10") == 1 then
          vim.opt.smoothscroll = true
        end

        -- Append to shortmess
        vim.opt.shortmess:append({ W = true, I = true, c = true, C = true })
      '';

    # Global variables
    globals = {
      # For nvim-ts-context-commentstring
      skip_ts_context_commentstring_module = true;
      markdown_recommended_style = 0;
      qf_is_open = false;
    };

    # Diagnostics configuration
    diagnostics = {
      virtual_text = true;
      signs = {
        text = {
          error = "";
          warn = "";
          info = "󰋼";
          hint = "󰌵";
        };
      };
      float = { border = "rounded"; };
      underline = true;
      update_in_insert = false;
    };
  };
}
