{ ... }: {
  programs.nixvim = {
    plugins.overseer = {
      enable = true;
      templates = [ "builtin" ];
    };

    keymaps = [
      {
        key = "<leader>or";
        action = "<cmd>OverseerRun<cr>";
        options.desc = "Run Task";
      }
      {
        key = "<leader>ol";
        action = "<cmd>OverseerToggle<cr>";
        options.desc = "Toggle Task List";
      }
    ];
  };
}
