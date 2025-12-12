{ pkgs, ... }: {
  programs.nixvim = {
    plugins = {
      noice = {
        enable = true;
        settings = {
          lsp = {
            progress = { enabled = true; };
            override = {
              "vim.lsp.util.convert_input_to_markdown_lines" = true;
              "vim.lsp.util.stylize_markdown" = true;
            };
          };
          presets = {
            bottom_search = true;
            command_palette = true;
            inc_rename = true;
            lsp_doc_border = true;
            long_message_to_split = false;
          };
        };
      };
    };
  };
}
