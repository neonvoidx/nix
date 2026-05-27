{ den, inputs, ... }:
{
  den.aspects.neovim.homeManager =
    {
      pkgs,
      ...
    }:
    {
      programs.neovim = {
        enable = true;
        defaultEditor = true;
        viAlias = true;
        vimAlias = true;
        withNodeJs = true;
        withPython3 = true;
        # Needed to load our own lua over HM generation
        sideloadInitLua = true;
        plugins = with pkgs.vimPlugins; [
          nvim-treesitter.withAllGrammars
        ];
        extraPackages = with pkgs; [
          # LSP Servers
          basedpyright
          clang-tools
          gopls
          lua-language-server
          nixd
          rust-analyzer
          vtsls
          yaml-language-server

          # Formatters & Linters
          black
          cmake-lint
          eslint_d
          isort
          markdownlint-cli2
          nixfmt
          prettierd
          rustfmt
          stylua

          # Tools & Utilities
          fd
          git
          github-markdown-toc-go
          lazygit
          markdown-toc
          ripgrep
          tree-sitter
          yazi

          # Language Runtimes
          cargo
          go
          nodejs
          python3
          python3Packages.pip
          python3Packages.pyyaml
        ];
      };
    };
}
