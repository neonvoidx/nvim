{ pkgs, lib, ... }:
{
  config.vim = {
    startPlugins = with pkgs.vimPlugins; [
      bufferline-nvim
      nvim-web-devicons
    ];

    luaConfigRC."bufferline" = lib.nvim.dag.entryAnywhere ''
      require("bufferline").setup({
        options = {
          themable = true,
          mode = "buffers",
          indicator = { style = "none" },
          color_icons = true,
          separator_style = "thin",
          show_tab_indicators = false,
          show_buffer_icons = true,
          show_duplicate_prefix = false,
          max_name_length = 16,
          max_prefix_length = 10,
          tab_size = 25,
          name_formatter = function(buf)
            local name = buf.name or ""
            return name:gsub("intent%.[%w_]+%.", "🛈")
          end,
          truncate_names = true,
          hover = {
            enabled = true,
            delay = 200,
            reveal = { "close" },
          },
          offsets = {
            { filetype = "NvimTree", text = "File Explorer", text_align = "left", separator = true },
          },
          diagnostics = "nvim_lsp",
          diagnostics_indicator = function(_, _, diagnostics_dict, _)
            local s = " "
            for e, n in pairs(diagnostics_dict) do
              local sym = e == "error" and " " or (e == "warning" and " " or "")
              s = s .. n .. sym
            end
            return s
          end,
        },
      })

      -- Buffer navigation keymaps
      local map = vim.keymap.set
      map("n", "<S-h>",     "<cmd>BufferLineCyclePrev<cr>",      { desc = "Prev buffer" })
      map("n", "<S-l>",     "<cmd>BufferLineCycleNext<cr>",      { desc = "Next buffer" })
      map("n", "[b",        "<cmd>BufferLineCyclePrev<cr>",      { desc = "Prev buffer" })
      map("n", "]b",        "<cmd>BufferLineCycleNext<cr>",      { desc = "Next buffer" })
      map("n", "<leader>bp","<cmd>BufferLineTogglePin<cr>",      { desc = "Toggle pin" })
      map("n", "<leader>bP","<cmd>BufferLineGroupClose ungrouped<cr>", { desc = "Delete non-pinned buffers" })
      map("n", "<leader>bo","<cmd>BufferLineCloseOthers<cr>",   { desc = "Delete other buffers" })
      map("n", "<leader>br","<cmd>BufferLineCloseRight<cr>",    { desc = "Delete buffers to the right" })
      map("n", "<leader>bl","<cmd>BufferLineCloseLeft<cr>",     { desc = "Delete buffers to the left" })
    '';
  };
}
