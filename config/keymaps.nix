{ lib, ... }:
{
  config.vim.luaConfigRC."keymaps" = lib.nvim.dag.entryAnywhere /* lua */ ''
        local map = vim.keymap.set

        -- Helper: diff current buffer against clipboard
        local function compareToClip()
          local ftype = vim.api.nvim_eval("&filetype")
          vim.cmd("vsplit")
          vim.cmd("enew")
          vim.cmd("normal! P")
          vim.cmd("setlocal buftype=nowrite")
          vim.cmd("set filetype=" .. ftype)
          vim.cmd("diffthis")
          vim.cmd([[execute "normal! \<C-w>h"]])
          vim.cmd("diffthis")
        end

        local function goto_diag(next, severity)
          return function()
            vim.diagnostic.jump({
              count = next and 1 or -1,
              severity = severity,
              float = true,
            })
          end
        end

        -- Better up/down (respect visual lines)
        map({ "n", "x" }, "j",      "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
        map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
        map({ "n", "x" }, "k",      "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
        map({ "n", "x" }, "<Up>",   "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

        -- Window resize
        map("n", "<C-Up>",    "<cmd>resize +2<cr>",          { desc = "Increase window height" })
        map("n", "<C-Down>",  "<cmd>resize -2<cr>",          { desc = "Decrease window height" })
        map("n", "<C-Left>",  "<cmd>vertical resize -2<cr>", { desc = "Decrease window width"  })
        map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width"  })

        -- Move lines
        map("n", "<A-j>", "<cmd>m .+1<cr>==",        { desc = "Move line down" })
        map("n", "<A-k>", "<cmd>m .-2<cr>==",        { desc = "Move line up"   })
        map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move line down" })
        map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move line up"   })
        map("v", "<A-j>", ":m '>+1<cr>gv=gv",        { desc = "Move selection down" })
        map("v", "<A-k>", ":m '<-2<cr>gv=gv",        { desc = "Move selection up"   })

        -- Search
        map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })
        map("n", "<leader>ur", "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>",
          { desc = "Redraw / clear hlsearch / diff update" })
        map("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next search result" })
        map("x", "n", "'Nn'[v:searchforward]",      { expr = true, desc = "Next search result" })
        map("o", "n", "'Nn'[v:searchforward]",      { expr = true, desc = "Next search result" })
        map("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev search result" })
        map("x", "N", "'nN'[v:searchforward]",      { expr = true, desc = "Prev search result" })
        map("o", "N", "'nN'[v:searchforward]",      { expr = true, desc = "Prev search result" })

        -- Undo break-points
        map("i", ",", ",<c-g>u")
        map("i", ".", ".<c-g>u")
        map("i", ";", ";<c-g>u")

        -- Save / quit
        map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w!<cr><esc>", { desc = "Save file"       })
        map({ "i", "n" },           "<C-q>", "<cmd>silent! xa<cr>", { desc = "Save all and quit" })

        -- Indenting
        map("v", "<", "<gv")
        map("v", ">", ">gv")

        -- Windows
        map("n", "<leader>wd", "<cmd>q<cr>",      { desc = "Delete window", remap = true })
        map("n", "<leader>w|", "<cmd>vsplit<cr>", { desc = "Split right",   remap = true })
        map("n", "<leader>w-", "<cmd>split<cr>",  { desc = "Split below",   remap = true })

        -- Escape shortcuts
        map("i", "jj", "<Esc>")
        map("i", "kk", "<Esc>")

        -- Select all content
        map("n", "==", "gg<S-v>G")
        map("n", "<A-a>", "ggVG", { noremap = true, silent = true, desc = "Select all" })

        -- Commenting (add comment above/below current line)
    map("n", "gco", "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Below" })
    map("n", "gcO", "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Above" })
        
        -- Create new file
    map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })

        -- Smart undo break-points (create undo points at logical stops)
        map("i", ",", ",<c-g>u")
        map("i", ".", ".<c-g>u")
        map("i", ";", ";<c-g>u")

        -- Copy whole file to clipboard
        map("n", "<C-c>", ":%y+<CR>", opts)

        -- Better line start/end (more comfortable than $ and ^)
        map("n", "gl", "$", { desc = "Go to end of line" })
        map("n", "gh", "^", { desc = "Go to start of line" })

        -- CAPS LOCK is bound to Insert on the desktop – remap to Esc
        local esc_modes = { "i", "n", "v", "x", "o", "t", "s", "c", "l" }
        map(esc_modes, "<Insert>", "<Esc>")

        -- Unbind nuisance keys
        map(esc_modes, "<F1>",          "<Nop>")
        map(esc_modes, "<C-LeftMouse>", "<Nop>")
        map("n", "<C-t>", "<Nop>")

        -- Black-hole delete / change
        map({ "n", "v" }, "D", '"_d')
        map({ "n", "v" }, "C", '"_c')

        -- Visual search-and-replace for the current selection
        map("x", "<C-r>", '"hy:%s/<C-r>h//g<Left><Left>', { desc = "Substitute visual selection" })

        -- Navigation
        map("n", "<Backspace>", "^", { desc = "Move to first non-blank character" })
        map("n", "]e", goto_diag(true, vim.diagnostic.severity.ERROR),  { desc = "Next error" })
        map("n", "[e", goto_diag(false, vim.diagnostic.severity.ERROR), { desc = "Prev error" })
        map("n", "]w", goto_diag(true, vim.diagnostic.severity.WARN),   { desc = "Next warning" })
        map("n", "[w", goto_diag(false, vim.diagnostic.severity.WARN),  { desc = "Prev warning" })
        map("n", "]d", goto_diag(true, { min = vim.diagnostic.severity.WARN }),  { desc = "Next diagnostic" })
        map("n", "[d", goto_diag(false, { min = vim.diagnostic.severity.WARN }), { desc = "Prev diagnostic" })

        -- Paste without overwriting the yank register
        map("v", "p", '"_dP')

        -- Diff vs clipboard
        map("n", "<leader>D", compareToClip, { desc = "Diff vs clipboard" })

  '';
}
