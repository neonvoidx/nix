{ config, ... }:
{
  flake.modules.homeManager.nixvim-keymaps = { pkgs, lib, config, inputs, ... }: {
    programs.nixvim = {
      keymaps = [
        # Better j/k navigation with wrapped lines
        {
          mode = [
            "n"
            "x"
          ];
          key = "j";
          action = "v:count == 0 ? 'gj' : 'j'";
          options = {
            expr = true;
            silent = true;
          };
        }
        {
          mode = [
            "n"
            "x"
          ];
          key = "<Down>";
          action = "v:count == 0 ? 'gj' : 'j'";
          options = {
            expr = true;
            silent = true;
          };
        }
        {
          mode = [
            "n"
            "x"
          ];
          key = "k";
          action = "v:count == 0 ? 'gk' : 'k'";
          options = {
            expr = true;
            silent = true;
          };
        }
        {
          mode = [
            "n"
            "x"
          ];
          key = "<Up>";
          action = "v:count == 0 ? 'gk' : 'k'";
          options = {
            expr = true;
            silent = true;
          };
        }

        # Resize window using <ctrl> arrow keys
        {
          mode = "n";
          key = "<C-Up>";
          action = "<cmd>resize +2<cr>";
          options.desc = "Increase window height";
        }
        {
          mode = "n";
          key = "<C-Down>";
          action = "<cmd>resize -2<cr>";
          options.desc = "Decrease window height";
        }
        {
          mode = "n";
          key = "<C-Left>";
          action = "<cmd>vertical resize -2<cr>";
          options.desc = "Decrease window width";
        }
        {
          mode = "n";
          key = "<C-Right>";
          action = "<cmd>vertical resize +2<cr>";
          options.desc = "Increase window width";
        }

        # Move Lines
        {
          mode = "n";
          key = "<A-j>";
          action = "<cmd>m .+1<cr>==";
          options.desc = "Move down";
        }
        {
          mode = "n";
          key = "<A-k>";
          action = "<cmd>m .-2<cr>==";
          options.desc = "Move up";
        }
        {
          mode = "i";
          key = "<A-j>";
          action = "<esc><cmd>m .+1<cr>==gi";
          options.desc = "Move down";
        }
        {
          mode = "i";
          key = "<A-k>";
          action = "<esc><cmd>m .-2<cr>==gi";
          options.desc = "Move up";
        }
        {
          mode = "v";
          key = "<A-j>";
          action = ":m '>+1<cr>gv=gv";
          options.desc = "Move down";
        }
        {
          mode = "v";
          key = "<A-k>";
          action = ":m '<-2<cr>gv=gv";
          options.desc = "Move up";
        }
        # Clear search with <esc>
        {
          mode = [
            "i"
            "n"
          ];
          key = "<esc>";
          action = "<cmd>noh<cr><esc>";
          options.desc = "Escape and clear hlsearch";
        }

        # Clear search, diff update and redraw
        {
          mode = "n";
          key = "<leader>ur";
          action = "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>";
          options.desc = "Redraw / clear hlsearch / diff update";
        }

        # https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
        {
          mode = "n";
          key = "n";
          action = "'Nn'[v:searchforward].'zv'";
          options = {
            expr = true;
            desc = "Next search result";
          };
        }
        {
          mode = "x";
          key = "n";
          action = "'Nn'[v:searchforward]";
          options = {
            expr = true;
            desc = "Next search result";
          };
        }
        {
          mode = "o";
          key = "n";
          action = "'Nn'[v:searchforward]";
          options = {
            expr = true;
            desc = "Next search result";
          };
        }
        {
          mode = "n";
          key = "N";
          action = "'nN'[v:searchforward].'zv'";
          options = {
            expr = true;
            desc = "Prev search result";
          };
        }
        {
          mode = "x";
          key = "N";
          action = "'nN'[v:searchforward]";
          options = {
            expr = true;
            desc = "Prev search result";
          };
        }
        {
          mode = "o";
          key = "N";
          action = "'nN'[v:searchforward]";
          options = {
            expr = true;
            desc = "Prev search result";
          };
        }

        # Add undo break-points
        {
          mode = "i";
          key = ",";
          action = ",<c-g>u";
        }
        {
          mode = "i";
          key = ".";
          action = ".<c-g>u";
        }
        {
          mode = "i";
          key = ";";
          action = ";<c-g>u";
        }

        # save file
        {
          mode = [
            "i"
            "x"
            "n"
            "s"
          ];
          key = "<C-s>";
          action = "<cmd>w!<cr><esc>";
          options.desc = "Save file";
        }
        # Save all buffers and close
        {
          mode = [
            "i"
            "n"
          ];
          key = "<C-q>";
          action = "<cmd>silent! xa<cr>";
          options.desc = "Save all and quit";
        }

        # better indenting
        {
          mode = "v";
          key = "<";
          action = "<gv";
        }
        {
          mode = "v";
          key = ">";
          action = ">gv";
        }

        # windows
        {
          mode = "n";
          key = "<leader>wd";
          action = "<cmd>q<cr>";
          options = {
            desc = "Delete window";
            remap = true;
          };
        }
        {
          mode = "n";
          key = "<leader>w|";
          action = "<cmd>vsplit<cr>";
          options = {
            desc = "Split window right";
            remap = true;
          };
        }
        {
          mode = "n";
          key = "<leader>w-";
          action = "<cmd>split<cr>";
          options = {
            desc = "Split window below";
            remap = true;
          };
        }

        # Rebind jj and kk to escape
        {
          mode = "i";
          key = "jj";
          action = "<Esc>";
        }
        {
          mode = "i";
          key = "kk";
          action = "<Esc>";
        }

        # remap Insert to Esc, aka my CAPS lock key which is always bound to Insert on my desktop
        {
          mode = [
            "i"
            "n"
            "v"
            "x"
            "o"
            "t"
            "s"
            "c"
            "l"
          ];
          key = "<Insert>";
          action = "<Esc>";
        }

        # Unbind F1 help
        {
          mode = [
            "i"
            "n"
            "v"
            "x"
            "o"
            "t"
            "s"
            "c"
            "l"
          ];
          key = "<F1>";
          action = "<Nop>";
        }
        # Unbind ctrl left click
        {
          mode = [
            "i"
            "n"
            "v"
            "x"
            "o"
            "t"
            "s"
            "c"
            "l"
          ];
          key = "<C-LeftMouse>";
          action = "<Nop>";
        }
        # Unbind tags
        {
          mode = "n";
          key = "<C-t>";
          action = "<Nop>";
        }

        # Remap D to blackhole delete
        {
          mode = [
            "n"
            "v"
          ];
          key = "D";
          action = ''"_d'';
        }
        # Remap C to blackhole change
        {
          mode = [
            "n"
            "v"
          ];
          key = "C";
          action = ''"_c'';
        }
        # Backspace in normal mode to go to start of line
        {
          mode = [ "n" ];
          key = "<Backspace>";
          action = "^";
          options = {
            desc = "Move to first non blank character";
          };
        }

        # Toggle word wrap
        {
          mode = "n";
          key = "<leader>uw";
          action.__raw = ''
            function()
              vim.wo.wrap = not vim.wo.wrap
              vim.notify("Wrap " .. (vim.wo.wrap and "enabled" or "disabled"))
            end
          '';
          options.desc = "Toggle Wrap";
        }
      ];
    };
  };
}
