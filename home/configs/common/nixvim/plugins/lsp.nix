{ lib, ... }:
let
  servers = [ "vtsls" "eslint" "nixd" "basedpyright" "bashls" "biome" "clangd" "cmake" "copilot" "docker_compose_language_server" "dockerls" "elixirls" "gopls" "hyprls" "jsonls" "lua_ls" "qmlls" "rust_analyzer" "stylua"];
in
{
  plugins.lspconfig. enable = true;
  lsp = {
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
    } // lib.genAttrs servers (_: { enable = true; });
  };
}
