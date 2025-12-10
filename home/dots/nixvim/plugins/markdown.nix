{ pkgs, ... }: {
  # Markdown plugins configuration

  plugins = {
    # Markdown preview
    markdown-preview = {
      enable = true;
      settings = {
        auto_start = false;
        auto_close = true;
        refresh_slow = false;
        command_for_global = false;
        open_to_the_world = false;
        open_ip = "";
        browser = "";
        echo_preview_url = false;
        browserfunc = "";
        preview_options = {
          mkit = { };
          katex = { };
          uml = { };
          maid = { };
          disable_sync_scroll = false;
          sync_scroll_type = "middle";
          hide_yaml_meta = true;
          sequence_diagrams = { };
          flowchart_diagrams = { };
          content_editable = false;
          disable_filename = false;
          toc = { };
        };
        markdown_css = "";
        highlight_css = "";
        port = "";
        page_title = "「\${name}」";
        filetypes = [ "markdown" ];
        theme = "dark";
      };
    };

    # Render markdown in Neovim
    render-markdown = {
      enable = true;
      settings = {
        file_types = [ "markdown" ];
        code = {
          enabled = true;
          sign = true;
          style = "full";
          position = "left";
          width = "full";
          left_pad = 0;
          right_pad = 0;
          min_width = 0;
          border = "thin";
          above = "▄";
          below = "▀";
          highlight = "RenderMarkdownCode";
          highlight_inline = "RenderMarkdownCodeInline";
        };
        heading = {
          enabled = true;
          sign = true;
          position = "overlay";
          icons = [ "󰲡 " "󰲣 " "󰲥 " "󰲧 " "󰲩 " "󰲫 " ];
          signs = [ "󰫎 " ];
          width = "full";
          left_pad = 0;
          right_pad = 0;
          min_width = 0;
          border = false;
          above = "▄";
          below = "▀";
          backgrounds = [
            "RenderMarkdownH1Bg"
            "RenderMarkdownH2Bg"
            "RenderMarkdownH3Bg"
            "RenderMarkdownH4Bg"
            "RenderMarkdownH5Bg"
            "RenderMarkdownH6Bg"
          ];
          foregrounds = [
            "RenderMarkdownH1"
            "RenderMarkdownH2"
            "RenderMarkdownH3"
            "RenderMarkdownH4"
            "RenderMarkdownH5"
            "RenderMarkdownH6"
          ];
        };
      };
    };
  };

  # Additional markdown plugins via extraPlugins
  extraPlugins = with pkgs.vimPlugins; [
    # Markdown TOC generator
    {
      plugin = pkgs.vimUtils.buildVimPlugin {
        name = "markdown-toc.nvim";
        src = pkgs.fetchFromGitHub {
          owner = "hedyhli";
          repo = "markdown-toc.nvim";
          rev = "main";
          sha256 = ""; # Will need to be filled
        };
      };
    }
    # Presentation mode
    {
      plugin = pkgs.vimUtils.buildVimPlugin {
        name = "presenting.nvim";
        src = pkgs.fetchFromGitHub {
          owner = "sotte";
          repo = "presenting.nvim";
          rev = "main";
          sha256 = ""; # Will need to be filled
        };
      };
    }
  ];

  # Additional configuration
  extraConfigLua = ''
    -- Markdown TOC configuration
    require("markdown-toc").setup()

    -- Markdown keymaps
    local wk = require("which-key")
    wk.add({
      {
        "<leader>m",
        group = "+markdown",
        icon = { icon = " " },
      },
    })

    vim.keymap.set("n", "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>", { desc = "Markdown preview" })
    vim.keymap.set("n", "<leader>mt", "<cmd>MardownTocGenerate<cr>", { desc = "Generate TOC" })
    vim.keymap.set("n", "<leader>mr", "<cmd>RenderMarkdownToggle<cr>", { desc = "Toggle render markdown" })
  '';
}
