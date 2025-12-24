{ ... }:
{
  plugins.overseer = {
    enable = true;
    settings = {
      templates = [ "builtin" ];
    };
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>or";
      action = "<cmd>OverseerRun<cr>";
      options.desc = "Run Task";
    }
    {
      mode = "n";
      key = "<leader>ol";
      action = "<cmd>OverseerToggle<cr>";
      options.desc = "Toggle Task List";
    }
  ];
}
