{ ... }: {
  programs.nixvim = {
    plugins.quicker = { enable = true; };

    keymaps = [
      {
        key = "<leader>q";
        action.__raw = # lua
          ''
            function()
              require("quicker").toggle()
            end
          '';
        options.desc = "Toggle quickfix";
      }
      {
        key = ">";
        action.__raw = # lua
          ''
            function()
              require("quicker").expand({ before = 2, after = 2, add_to_existing = true })
            end
          '';
        options.desc = "Expand quickfix content";
      }
      {
        key = "<";
        action.__raw = # lua
          ''
            function()
              require("quicker").collapse()
            end
          '';
        options.desc = "Collapse quickfix context";

      }
    ];
  };
}
