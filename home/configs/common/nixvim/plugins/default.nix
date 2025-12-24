{ ... }:
{
  imports = [
    # Core plugins
    ./blink.nix
    ./eldritch.nix
    ./treesitter.nix
    ./lsp.nix
    ./diagnostics.nix
    
    # File management and navigation
    ./yazi.nix
    ./flash.nix
    
    # UI and appearance
    ./lualine.nix
    ./bufferline.nix
    ./noice.nix
    ./whichkey.nix
    ./highlight-colors.nix
    ./alt-themes.nix
    
    # Code editing and manipulation
    ./format.nix
    ./lint.nix
    ./mini.nix
    ./yanky.nix
    ./inc-rename.nix
    ./comments.nix
    ./folds.nix
    ./guess-indent.nix
    
    # Git integration
    ./git.nix
    ./diffview.nix
    
    # Productivity and utilities
    ./snacks.nix
    ./markdown.nix
    ./session.nix
    ./overseer.nix
    
    # Special purpose plugins
    ./numb.nix
    ./helpview.nix
    ./hmts.nix
    ./ai.nix
    
    # Stub files for unavailable plugins
    ./quickfix.nix
    ./snippets.nix
    ./kitty.nix
  ];
}
