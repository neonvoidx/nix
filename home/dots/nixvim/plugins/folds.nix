{ pkgs, ... }: {
  programs.nixvim = {
    plugins = {
      nvim-ufo = {
        enable = true;
        setupLspCapabilities = true;
        settings = {
          fold_virt_text_handler = # lua
            ''
              function(virtText, lnum, endLnum, width, truncate)
                local newVirtText = {}
                local suffix = ("   %d lines"):format(endLnum - lnum)
                local sufWidth = vim.fn.strdisplaywidth(suffix)
                local targetWidth = width - sufWidth
                local curWidth = 0
                for _, chunk in ipairs(virtText) do
                  local chunkText = chunk[1]
                  local chunkWidth = vim.fn.strdisplaywidth(chunkText)
                  if targetWidth > curWidth + chunkWidth then
                    table.insert(newVirtText, chunk)
                  else
                    chunkText = truncate(chunkText, targetWidth - curWidth)
                    local hlGroup = chunk[2]
                    table.insert(newVirtText, { chunkText, hlGroup })
                    chunkWidth = vim.fn.strdisplaywidth(chunkText)
                    if curWidth + chunkWidth < targetWidth then
                      suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
                    end
                    break
                  end
                  curWidth = curWidth + chunkWidth
                end
                table.insert(newVirtText, { suffix, "MoreMsg" })
                return newVirtText
              end
            '';
        };
      };
    };

    opts = {
      foldcolumn = "1";
      foldlevel = 99;
      foldlevelstart = 99;
      foldenable = true;
    };

    keymaps = [
      {
        key = "zR";
        action.__raw = "require('ufo').openAllFolds";
        options.desc = "Open all folds";
      }
      {
        key = "zM";
        action.__raw = "require('ufo').closeAllFolds";
        options.desc = "Close all folds";
      }
    ];

  };
}
