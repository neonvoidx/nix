{ inputs, pkgs, ... }:
{
  imports = [
    inputs.nixcats.homeModule
  ];
  
  nixCats = {
    enable = true;
    packageNames = [ "nixCats" ];
    
    luaPath = "${./../../../configs/nixcats}";
    
    categoryDefinitions = { pkgs, settings, categories, name, ... }: {
      lspsAndRuntimeDeps = with pkgs; [
        nodePackages.vtsls
        nodePackages.eslint
        nixd
        basedpyright
        nodePackages.bash-language-server
        biome
        clang-tools
        cmake-language-server
        docker-compose-language-server
        dockerfile-language-server-nodejs
        elixir-ls
        gopls
        hyprls
        nodePackages.vscode-langservers-extracted
        lua-language-server
        libsForQt5.qtdeclarative
        rust-analyzer
        stylua
        ripgrep
        fd
        tree-sitter
      ];

      startupPlugins = with pkgs.vimPlugins; [
        (pkgs.vimUtils.buildVimPlugin {
          name = "eldritch.nvim";
          src = pkgs.fetchFromGitHub {
            owner = "eldritch-theme";
            repo = "eldritch.nvim";
            rev = "0415fa72c348e814a7a6cc9405593a4f812fe12f";
            hash = "sha256-nEt25TqsYePRCYkCI9zEk/awFBQ9ENyYWR0hSyy24GY=";
          };
        })
        nvim-treesitter.withAllGrammars
        nvim-lspconfig
        lazydev-nvim
        rustaceanvim-nightly
        vim-illuminate
        lspkind-nvim
        blink-cmp
        lualine-nvim
        nvim-web-devicons
        bufferline-nvim
        noice-nvim
        nui-nvim
        nvim-notify
        which-key-nvim
        nvim-colorizer-lua
        flash-nvim
        yazi-nvim
        plenary-nvim
        nvim-autopairs
        mini-nvim
        yanky-nvim
        inc-rename-nvim
        comment-nvim
        nvim-ufo
        promise-async
        guess-indent-nvim
        gitsigns-nvim
        diffview-nvim
        conform-nvim
        nvim-lint
        snacks-nvim
        render-markdown-nvim
        persistence-nvim
        overseer-nvim
        numb-nvim
        helpview-nvim
        hmts-nvim
      ];
    };
    
    packages = {
      nixCats = {
        categories = {
          lspsAndRuntimeDeps = true;
          startupPlugins = true;
        };
      };
    };
  };
}
