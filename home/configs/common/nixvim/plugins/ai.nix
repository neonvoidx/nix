{ ... }:
{
  plugins.copilot-lua = {
    enable = true;
    filetypes = {
      markdown = false;
      help = false;
      sh.__raw = ''
        function()
          if string.match(vim.fs.basename(vim.api.nvim_buf_get_name(0)), "^%.env.*") then
            return false
          end
          return true
        end
      '';
    };
  };

  # Plugin: folke/sidekick.nvim not available in nixvim
  # This is an AI assistance plugin that is not yet available
}
