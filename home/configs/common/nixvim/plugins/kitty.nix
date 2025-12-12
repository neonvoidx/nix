{ ... }:
{
  # Kitty-specific plugins:
  # - knubie/vim-kitty-navigator: Navigate between kitty windows and nvim splits
  # - mikesmithgh/kitty-scrollback.nvim: Kitty scrollback integration
  # - fladson/vim-kitty: Syntax highlighting for kitty config files
  #
  # These plugins are terminal-specific and not available as built-in nixvim plugins
  # They are conditionally loaded only when running in kitty terminal (TERM=xterm-kitty)
  # To add manually, use extraPlugins in nixvim configuration with appropriate conditions
}
