{ ... }:
{
  plugins.mini = {
    enable = true;
    modules = {
      pairs = {
        modes = {
          insert = true;
          command = false;
          terminal = false;
        };
        mappings = {
          # Uncomment to disable specific pairs
          # ['"'] = false;
          # ["'"] = false;
          # ["`"] = false;
        };
      };
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
}
