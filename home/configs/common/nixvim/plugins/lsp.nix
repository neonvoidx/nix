{ lib,... }:
{
  plugins = {
    lsp = {
      enable = true;
      autoLoad = true;
      keymaps = {
        silent = true;
        diagnostic = {
          "]e" = "goto_next";
          "[e" = "goto_prev";
        };
        lspBuf = {
          gd = "definition";
          gD = "references";
          gt = "type_definition";
          gi = "implementation";
          K = "hover";
        };
        servers = {
          "*" = {
            config = {
              capabilities = {
                textDocument = {
                  semanticTokens = {
                    multilineTokenSupport = true;
                  };
                };
              };
              root_markers = [
                ".git"
              ];
            };
          };
          vtsls = {
            enable = true;
          };
          eslint = {
            enable = true;
          };
        };
      };
    };
    lspconfig.enable = true;
  };
}
