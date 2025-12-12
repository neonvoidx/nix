{ ... }: {
  programs.nixvim = {
    plugins = {
      mini = {
        enable = true;
        mockDevIcons = true;
        modules = {
          pairs = {
            modes = {
              insert = true;
              command = false;
              terminal = false;
            };
            markdown = false;
            mappings = { };
          };
          icons = { style = "glyph"; };
          surround = {
            mappings = {
              add = "gsa";
              delete = "gsd";
              find = "gsf";
              find_left = "gsF";
              highlight = "gsh";
              replace = "gsr";
              update_n_lines = "gsn";
            };
          };
        };
      };
    };
  };
}
