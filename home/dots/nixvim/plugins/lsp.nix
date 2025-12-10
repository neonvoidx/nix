{ ... }: {
  programs.nixvim = {

    plugins = {
      # LSP configuration
      lsp = {
        enable = true;

        keymaps = {
          silent = true;
          diagnostic = {
            "[e" = {
              action = "goto_prev";
              desc = "Jump to the previous diagnostic error";
            };
            "]e" = {
              action = "goto_next";
              desc = "Jump to the next diagnostic error";
            };
          };
          lspBuf = {
            gD = "declaration";
            gd = "definition";
            K = "hover";
            gi = "implementation";
            "<space>ca" = "code_action";
            "<leader>li" = "lsp_info";
            "<leader>r" = "restart";
          };
        };

        servers = {
          # Bash
          bashls.enable = true;

          # JSON
          jsonls.enable = true;

          # Go
          gopls.enable = true;

          # Lua
          lua_ls = {
            enable = true;
            settings = { Lua = { diagnostics = { globals = [ "vim" ]; }; }; };
          };

          # Python
          basedpyright.enable = true;

          # YAML
          yamlls.enable = true;

          # Docker
          docker_compose_language_service.enable = true;
          dockerls.enable = true;

          # CMake
          neocmake.enable = true;

          # TypeScript/JavaScript
          vtsls = {
            enable = true;
            settings = {
              complete_function_calls = true;
              vtsls = {
                enableMoveToFileCodeAction = true;
                autoUseWorkspaceTsdk = true;
                experimental = {
                  maxInlayHintLength = 30;
                  completion = { enableServerSideFuzzyMatch = true; };
                };
              };
              typescript = {
                updateImportsOnFileMove = { enabled = "always"; };
                suggest = { completeFunctionCalls = true; };
                inlayHints = {
                  enumMemberValues = { enabled = true; };
                  functionLikeReturnTypes = { enabled = true; };
                  parameterNames = { enabled = "literals"; };
                  parameterTypes = { enabled = true; };
                  propertyDeclarationTypes = { enabled = true; };
                  variableTypes = { enabled = false; };
                };
                preferences = { importModuleSpecifier = "relative"; };
              };
            };
          };

          # Terraform
          terraformls.enable = true;

          # C/C++
          clangd = {
            enable = true;
            cmd = [
              "clangd"
              "--background-index"
              "--clang-tidy"
              "--header-insertion=iwyu"
              "--completion-style=detailed"
              "--function-arg-placeholders"
              "--fallback-style=llvm"
            ];
            onAttach.function = ''
              require("clangd_extensions.inlay_hints").setup_autocmd()
              require("clangd_extensions.inlay_hints").set_inlay_hints()
            '';
          };

          # Zig
          zls.enable = true;

          # Emmet
          emmet_language_server.enable = true;

          # Fish
          fish_lsp.enable = true;
        };
      };

      # Mason - LSP/DAP/linter installer
      mason = { enable = true; };

      # Additional LSP plugins
      lspkind = {
        enable = true;
        mode = "symbol";
        cmp = { enable = true; };
      };

      # Rust tools
      rustaceanvim = { enable = true; };

      # Clangd extensions
      clangd-extensions = {
        enable = true;
        ast = {
          roleIcons = {
            type = "";
            declaration = "";
            expression = "";
            specifier = "";
            statement = "";
            templateArgument = "";
          };
          kindIcons = {
            compound = "";
            recovery = "";
            translationUnit = "";
            packExpansion = "";
            templateTypeParm = "";
            templateTemplateParm = "";
            templateParamObject = "";
          };
        };
      };

      # LazyDev - Neovim Lua API completion
      lazydev = {
        enable = true;
        settings = {
          library = [{
            path = "luvit-meta/library";
            words = [ "vim%.uv" ];
          }];
        };
      };

      # Trouble - diagnostics list
      trouble = {
        enable = true;
        settings = {
          modes = {
            diagnostics_buffer = {
              mode = "diagnostics";
              preview = {
                type = "float";
                relative = "editor";
                border = "rounded";
                title = "Preview";
                title_pos = "center";
                position = [ 0 (-2) ];
                size = {
                  width = 0.4;
                  height = 0.4;
                };
                zindex = 200;
              };
              filter = { buf = 0; };
            };
          };
        };
      };

      # Illuminate - highlight word under cursor
      illuminate = {
        enable = true;
        providers = [ "lsp" "treesitter" "regex" ];
      };

      # Tiny inline diagnostics
      tiny-inline-diagnostic = {
        enable = true;
        settings = {
          options = {
            show_source = { enabled = true; };
            multilines = { enabled = true; };
            add_messages = { display_count = true; };
          };
        };
      };
    };

    # Additional LSP keymaps and configuration
    extraConfigLua = # lua
      ''
        -- Additional LSP keymaps
        vim.api.nvim_create_autocmd("LspAttach", {
          group = vim.api.nvim_create_augroup("UserLspConfig", {}),
          callback = function(ev)
            local opts = { buffer = ev.buf }
            
            -- Additional code action keymap
            vim.keymap.set({ "n", "v" }, "<space>cA", function()
              vim.lsp.buf.code_action({
                apply = true,
                context = {
                  only = { "source" },
                  diagnostics = {},
                },
              })
            end, vim.tbl_extend("force", opts, { desc = "Code action (buffer)" }))
            
            vim.keymap.set({ "n" }, "<leader>ll", "<cmd>LspLog<cr>", 
              vim.tbl_extend("force", opts, { desc = "LSP Logs" }))
          end,
        })

        -- Trouble keymaps
        local wk = require("which-key")
        wk.add({
          {
            "<leader>x",
            group = "+trouble",
            icon = { icon = " " },
          },
          {
            "<leader>c",
            group = "+code",
            icon = { icon = " " },
          },
        })

        vim.keymap.set("n", "<leader>xX", "<cmd>Trouble diagnostics toggle<cr>", 
          { desc = "Diagnostics (Trouble)" })
        vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", 
          { desc = "Buffer Diagnostics (Trouble)" })
        vim.keymap.set("n", "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>", 
          { desc = "Symbols (Trouble)" })
        vim.keymap.set("n", "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", 
          { desc = "LSP Definitions / references / ... (Trouble)" })
        vim.keymap.set("n", "<leader>xl", "<cmd>Trouble loclist toggle<cr>", 
          { desc = "Location List (Trouble)" })
        vim.keymap.set("n", "<leader>xq", "<cmd>Trouble qflist toggle<cr>", 
          { desc = "Quickfix List (Trouble)" })

        -- Mason keymap
        vim.keymap.set("n", "<leader>lm", "<cmd>Mason<cr>", { desc = "Mason" })
      '';
  };
}
