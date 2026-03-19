{ lib, ... }:
{
  config.vim.ui.nvim-ufo = {
    enable = true;

    setupOpts = {
      fold_virt_text_handler = lib.generators.mkLuaInline ''
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

  # Keymaps for ufo go here since NVF's nvim-ufo module doesn't expose them
  config.vim.luaConfigRC."ufo-keymaps" = lib.nvim.dag.entryAnywhere ''
    vim.keymap.set("n", "zR", require("ufo").openAllFolds,  { desc = "Open all folds" })
    vim.keymap.set("n", "zM", require("ufo").closeAllFolds, { desc = "Close all folds" })
  '';
}
