{ ... }: {
  programs.nixvim = {
    plugins = {
      gitsigns = { enable = true; };
      gitblame = {
        enabled = true;
        settings = {
          message_template = "<author> • <date> <<sha>>";
          date_format = "%r";
        };
      };
    };
  };
}
