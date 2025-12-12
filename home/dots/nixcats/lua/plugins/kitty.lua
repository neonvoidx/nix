return {
  {
    "knubie/vim-kitty-navigator",
    vscode = false,
    cond = function()
      if os.getenv("TERM") == "xterm-kitty" then
        return true
      end
      return false
    end,
    build = {
      "cp ./*.py ~/.config/kitty/",
    },
  },
  {
    "mikesmithgh/kitty-scrollback.nvim",
    vscode = false,
    lazy = true,
    cond = function()
      if os.getenv("TERM") == "xterm-kitty" then
        return true
      end
      return false
    end,
    cmd = { "KittyScrollbackGenerateKittens", "KittyScrollbackCheckHealth" },
    event = { "User KittyScrollbackLaunch" },
    -- version = '*', -- latest stable version, may have breaking changes if major version changed
    -- version = '^5.0.0', -- pin major version, include fixes and features that do not have breaking changes
    config = function()
      require("kitty-scrollback").setup()
    end,
  },
  {
    "fladson/vim-kitty",
    ft = "kitty",
  },
}
