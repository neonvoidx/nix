{ pkgs, ... }:
{
  programs.nixvim = {
    plugins = {
      # LSP Configuration
      lsp = {
        enable = true;
        inlayHints = true;

        keymaps = {
          diagnostic = {
            "<space>cd" = "open_float";
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
            "gD" = {
              action = "declaration";
              desc = "Goto declaration";
            };
#             "gd" = {
#               action = "definition";
#               desc = "Goto definition";
#             };
            "K" = {
              action = "hover";
              desc = "Hover";
            };
            "gi" = {
              action = "implementation";
              desc = "Implementation";
            };
            "<space>ca" = {
              action = "code_action";
              desc = "Code action";
            };
          };
          extra = [
            {
              key = "<space>cA";
              mode = [ "n" "v" ];
              action.__raw = ''
                function()
                  vim.lsp.buf.code_action({
                    apply = true,
                    context = {
                      only = { "source" },
                      diagnostics = {},
                    },
                  })
                end
              '';
              options.desc = "Code action (buffer)";
            }
            {
              key = "<leader>li";
              action = "<cmd>LspInfo<cr>";
              options.desc = "LSP Info";
            }
            {
              key = "<leader>ll";
              action = "<cmd>LspLog<cr>";
              options.desc = "LSP Logs";
            }
            {
              key = "<leader>r";
              action = "<cmd>LspRestart<cr>";
              options.desc = "LSP Restart";
            }
          ];
        };

        servers = {
          bashls.enable = true;
          jsonls.enable = true;
          gopls.enable = true;
          lua_ls.enable = true;
          basedpyright.enable = true;
          yamlls.enable = true;
          docker_compose_language_service.enable = true;
          dockerls.enable = true;
          neocmake.enable = true;
          terraformls.enable = true;
          zls.enable = true;
          emmet_language_server.enable = true;
          fish_lsp.enable = true;

          vtsls = {
            enable = true;
            settings = {
              complete_function_calls = true;
              vtsls = {
                enableMoveToFileCodeAction = true;
                autoUseWorkspaceTsdk = true;
                experimental = {
                  maxInlayHintLength = 30;
                  completion = {
                    enableServerSideFuzzyMatch = true;
                  };
                };
              };
              typescript = {
                updateImportsOnFileMove = {
                  enabled = "always";
                };
                suggest = {
                  completeFunctionCalls = true;
                };
                inlayHints = {
                  enumMemberValues = {
                    enabled = true;
                  };
                  functionLikeReturnTypes = {
                    enabled = true;
                  };
                  parameterNames = {
                    enabled = "literals";
                  };
                  parameterTypes = {
                    enabled = true;
                  };
                  propertyDeclarationTypes = {
                    enabled = true;
                  };
                  variableTypes = {
                    enabled = false;
                  };
                };
                preferences = {
                  importModuleSpecifier = "relative";
                };
              };
            };
          };

          clangd = {
            enable = true;
            onAttach.function = ''
              require("clangd_extensions.inlay_hints").setup_autocmd()
              require("clangd_extensions.inlay_hints").set_inlay_hints()
            '';
            cmd = [
              "clangd"
              "--background-index"
              "--clang-tidy"
              "--header-insertion=iwyu"
              "--completion-style=detailed"
              "--function-arg-placeholders"
              "--fallback-style=llvm"
            ];
            initOptions = {
              usePlaceholders = true;
              completeUnimported = true;
              clangdFileStatus = true;
            };
            filetypes = [ "c" "cpp" "objc" "objcpp" "cuda" ];
            rootDir = ''
              require("lspconfig.util").root_pattern(
                "compile_commands.json",
                "compile_flags.txt",
                "configure.ac",
                "Makefile",
                "configure.in",
                "config.h.in",
                "meson.build",
                "meson_options.txt",
                "build.ninja",
                ".git"
              )
            '';
          };
        };
      };

      # Illuminate - Auto highlights same words/symbols
      illuminate = {
        enable = true;
        providers = [ "lsp" "treesitter" "regex" ];
      };

      # Trouble - Diagnostics UI
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
              filter = {
                buf = 0;
              };
            };
          };
        };
      };

      # LazyDev - Lua development
      lazydev = {
        enable = true;
        settings = {
          library = [
            {
              path = "\${3rd}/luv/library";
              words = [ "vim%.uv" ];
            }
          ];
        };
      };

      # Rustaceanvim
      rustaceanvim = {
        enable = true;
      };

      # LSP Kind - icons for completion
      lspkind = {
        enable = true;
        mode = "symbol";
        preset = "default";
      };
    };

    extraPlugins = with pkgs.vimPlugins; [
      clangd_extensions-nvim
      {
        plugin = pkgs.vimUtils.buildVimPlugin {
          name = "tiny-inline-diagnostic";
          src = pkgs.fetchFromGitHub {
            owner = "rachartier";
            repo = "tiny-inline-diagnostic.nvim";
            rev = "v3.9.0";
            hash = "sha256-KZwdnjlmcT5cSPxBLqUK0U9a8yPeQePbKZlNxn1D8mg=";
          };
        };
        config = ''
          lua << EOF
          require("tiny-inline-diagnostic").setup({
            options = {
              show_source = {
                enabled = true,
              },
              multilines = {
                enabled = true,
              },
              add_messages = {
                display_count = true,
              },
            },
          })
          vim.diagnostic.config({ virtual_text = false })
          EOF
        '';
      }
    ];

    keymaps = [
      # Trouble keymaps
      {
        key = "<leader>xX";
        action = "<cmd>Trouble diagnostics toggle<cr>";
        options.desc = "Diagnostics (Trouble)";
      }
      {
        key = "<leader>xx";
        action = "<cmd>Trouble diagnostics toggle filter.buf=0<cr>";
        options.desc = "Buffer Diagnostics (Trouble)";
      }
      {
        key = "<leader>cs";
        action = "<cmd>Trouble symbols toggle focus=false<cr>";
        options.desc = "Symbols (Trouble)";
      }
      {
        key = "<leader>cl";
        action = "<cmd>Trouble lsp toggle focus=false win.position=right<cr>";
        options.desc = "LSP Definitions / references / ... (Trouble)";
      }
      {
        key = "<leader>xl";
        action = "<cmd>Trouble loclist toggle<cr>";
        options.desc = "Location List (Trouble)";
      }
      {
        key = "<leader>xq";
        action = "<cmd>Trouble qflist toggle<cr>";
        options.desc = "Quickfix List (Trouble)";
      }
      # Clangd keymap
      {
        key = "<leader>ch";
        action = "<cmd>ClangdSwitchSourceHeader<cr>";
        options.desc = "Switch Source/Header (C/C++)";
      }
    ];

    extraConfigLua = ''
      -- Setup clangd_extensions
      require("clangd_extensions").setup({
        inlay_hints = {
          inline = false,
        },
        ast = {
          role_icons = {
            type = "",
            declaration = "",
            expression = "",
            specifier = "",
            statement = "",
            ["template argument"] = "",
          },
          kind_icons = {
            Compound = "",
            Recovery = "",
            TranslationUnit = "",
            PackExpansion = "",
            TemplateTypeParm = "",
            TemplateTemplateParm = "",
            TemplateParamObject = "",
          },
        },
      })
    '';
  };
}
