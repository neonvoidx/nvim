{ lib, ... }:
{
  config.vim.luaConfigRC."autocmds" = lib.nvim.dag.entryAnywhere ''
    local function augroup(name)
      return vim.api.nvim_create_augroup("autocmd_" .. name, { clear = true })
    end

    -- Reload buffer when file changes outside neovim
    vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
      group = augroup("checktime"),
      command = "checktime",
    })

    -- Equalise splits after window resize
    vim.api.nvim_create_autocmd({ "VimResized" }, {
      group = augroup("resize_splits"),
      callback = function()
        local current_tab = vim.fn.tabpagenr()
        vim.cmd("tabdo wincmd =")
        vim.cmd("tabnext " .. current_tab)
      end,
    })

    -- Jump to last cursor position when reopening a buffer
    vim.api.nvim_create_autocmd("BufReadPost", {
      group = augroup("last_loc"),
      callback = function(event)
        local exclude = { "gitcommit" }
        local buf = event.buf
        if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].autocmd_last_loc then
          return
        end
        vim.b[buf].autocmd_last_loc = true
        local mark = vim.api.nvim_buf_get_mark(buf, '"')
        local lcount = vim.api.nvim_buf_line_count(buf)
        if mark[1] > 0 and mark[1] <= lcount then
          pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
      end,
    })

    -- Close auxiliary filetypes with <q>
    vim.api.nvim_create_autocmd("FileType", {
      group = augroup("close_with_q"),
      pattern = {
        "PlenaryTestPopup", "help", "lspinfo", "man", "notify", "qf",
        "query", "spectre_panel", "startuptime", "tsplayground",
        "neotest-output", "checkhealth", "neotest-summary",
        "neotest-output-panel", "lazy",
      },
      callback = function(event)
        vim.bo[event.buf].buflisted = false
        vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
      end,
    })

    -- Enable line wrap for prose filetypes
    vim.api.nvim_create_autocmd("FileType", {
      group = augroup("wrap_ft"),
      pattern = { "gitcommit", "markdown", "snacks_notif_history", "trouble" },
      callback = function()
        vim.opt_local.wrap = true
        vim.opt_local.linebreak = true
      end,
    })

    -- Enable spell checking for prose filetypes
    vim.api.nvim_create_autocmd("FileType", {
      group = augroup("spell_ft"),
      pattern = { "gitcommit", "markdown" },
      callback = function()
        vim.opt_local.spell = true
      end,
    })

    -- Auto-create missing parent directories on save
    vim.api.nvim_create_autocmd({ "BufWritePre" }, {
      group = augroup("auto_create_dir"),
      callback = function(event)
        if event.match:match("^%w%w+://") then return end
        local file = vim.loop.fs_realpath(event.match) or event.match
        vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
      end,
    })

    -- Relative line numbers: off in insert, on elsewhere
    local numtog = augroup("NumberToggle")
    vim.api.nvim_create_autocmd({ "InsertEnter" }, {
      group = numtog,
      pattern = "*",
      callback = function()
        local ignore = { oil = true, fzf = true }
        if ignore[vim.bo.filetype] then return end
        vim.wo.relativenumber = false
      end,
    })
    vim.api.nvim_create_autocmd({ "InsertLeave" }, {
      group = numtog,
      pattern = "*",
      callback = function()
        local ignore = { oil = true, fzf = true }
        if ignore[vim.bo.filetype] then return end
        vim.wo.relativenumber = true
      end,
    })

    -- Disable mini.pairs backtick and copilot completion in markdown/gitcommit
    vim.api.nvim_create_autocmd("FileType", {
      group = augroup("markdown_pairs"),
      pattern = { "gitcommit", "markdown" },
      callback = function(event)
        vim.keymap.set("i", "`", "`", { buffer = event.buf })
        vim.b.ai_cmp = false
      end,
    })

    -- Copilot scratch buffers: clean up UI
    vim.api.nvim_create_autocmd("BufEnter", {
      group = augroup("copilot_buf"),
      pattern = "copilot-*",
      callback = function()
        vim.opt_local.relativenumber = false
        vim.opt_local.number = false
        vim.opt_local.conceallevel = 0
      end,
    })

    -- Briefly highlight yanked text
    vim.api.nvim_create_autocmd("TextYankPost", {
      group = augroup("highlight_yank"),
      desc = "Highlight when yanking (copying) text",
      callback = function()
        vim.hl.on_yank()
      end,
    })

    -- Restore cursor to last known position on file open
    vim.api.nvim_create_autocmd("BufReadPre", {
      group = augroup("RestoreCursor"),
      callback = function(args)
        vim.api.nvim_create_autocmd("FileType", {
          buffer = args.buf,
          once = true,
          callback = function()
            local ft = vim.bo[args.buf].filetype
            local last_pos = vim.api.nvim_buf_get_mark(args.buf, '"')[1]
            local last_line = vim.api.nvim_buf_line_count(args.buf)
            if
              last_pos >= 1
              and last_pos <= last_line
              and not ft:match("commit")
              and not vim.tbl_contains({ "gitrebase", "nofile", "svn", "gitcommit" }, ft)
            then
              vim.api.nvim_win_set_cursor(0, { last_pos, 0 })
            end
          end,
        })
      end,
    })
  '';
}
