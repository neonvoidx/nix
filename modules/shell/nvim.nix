{ den, ... }:
{
  # TODO add this aspect to neonvoid
  den.aspects.nvim.homeManager =
    { pkgs, config, ... }:
    {
      programs.nvim = {
        enable = true;
        defaultEditor = true;
        viAlias = true;
        vimAlias = true;
        vimdiffAlias = true;
        withRuby = false;
        withPython3 = false;
        sideloadInitLua = true;
        plugins = with pkgs.vimPlugins; [
          nvim-treesitter.withAllGrammars
        ];

        extraPackages = with pkgs; [
          # Runtime dependencies
          ripgrep
          fd
          cargo
          rustc
          rust-analyzer
          rustfmt
          gnumake
          unzip
          python3
          tree-sitter

          # Formatters
          black
          nixfmt
          prettierd
          stylua

          # Language Servers
          # TODO add all LSPs
        ];
      };

      # TODO auto pull this from github
      home.file.".config/nvim" = {
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix/assets/nvim/init.lua";
        recursive = true;
      };
    };
}
