{
  opts = {
    autowrite = true;
    autoread = true;
    clipboard = "unnamedplus";
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
    sessionoptions = [
      "buffers"
      "curdir"
      "tabpages"
      "winsize"
      "help"
      "globals"
      "skiprtp"
      "folds"
    ];
    shiftround = true;
    shiftwidth = 2;
    showmode = false;
    sidescrolloff = 8;
    signcolumn = "yes";
    smartcase = true;
    smartindent = true;
    spelllang = [ "en" ];
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
    fillchars = {
      foldopen = "";
      foldclose = "";
      fold = " ";
      foldsep = " ";
      diff = "╱";
      eob = " ";
    };
    winborder = "rounded";
  };
  globals = {
    g.skip_ts_context_commentstring_module = true;
    g.markdown_recommended_style = 0;
  };

}
