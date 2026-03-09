{ ... }:
{
  autoGroups = {
    checktime = { clear = true; };
    resize_splits = { clear = true; };
    last_loc = { clear = true; };
    close_with_q = { clear = true; };
    wrap = { clear = true; };
    spell = { clear = true; };
    auto_create_dir = { clear = true; };
    NumberToggle = { clear = true; };
    markdown_disable_pairs = { clear = true; };
    copilot_buf = { clear = true; };
    highlight_yank = { clear = true; };
    RestoreCursor = { clear = true; };
  };

  autoCmd = [
    # Reload file when it changes outside nvim
    {
      event = [
        "FocusGained"
        "TermClose"
        "TermLeave"
      ];
      group = "checktime";
      command = "checktime";
    }

    # Resize splits when the window is resized
    {
      event = [ "VimResized" ];
      group = "resize_splits";
      callback.__raw = ''
        function()
          local current_tab = vim.fn.tabpagenr()
          vim.cmd("tabdo wincmd =")
          vim.cmd("tabnext " .. current_tab)
        end
      '';
    }

    # Go to last cursor location when opening a buffer
    {
      event = "BufReadPost";
      group = "last_loc";
      callback.__raw = ''
        function(event)
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
        end
      '';
    }

    # Close certain filetypes with <q>
    {
      event = "FileType";
      group = "close_with_q";
      pattern = [
        "PlenaryTestPopup"
        "help"
        "lspinfo"
        "man"
        "notify"
        "qf"
        "query"
        "spectre_panel"
        "startuptime"
        "tsplayground"
        "neotest-output"
        "checkhealth"
        "neotest-summary"
        "neotest-output-panel"
        "lazy"
      ];
      callback.__raw = ''
        function(event)
          vim.bo[event.buf].buflisted = false
          vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
        end
      '';
    }

    # Wrap in text-heavy filetypes
    {
      event = "FileType";
      group = "wrap";
      pattern = [
        "gitcommit"
        "markdown"
        "snacks_notif_history"
        "trouble"
      ];
      callback.__raw = ''
        function()
          vim.opt_local.wrap = true
          vim.opt_local.linebreak = true
        end
      '';
    }

    # Enable spell in text filetypes
    {
      event = "FileType";
      group = "spell";
      pattern = [
        "gitcommit"
        "markdown"
      ];
      callback.__raw = ''
        function()
          vim.opt_local.spell = true
        end
      '';
    }

    # Auto-create intermediate directories on write
    {
      event = [ "BufWritePre" ];
      group = "auto_create_dir";
      callback.__raw = ''
        function(event)
          if event.match:match("^%w%w+://") then
            return
          end
          local file = vim.loop.fs_realpath(event.match) or event.match
          vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
        end
      '';
    }

    # Relative numbers: off in insert mode
    {
      event = [ "InsertEnter" ];
      group = "NumberToggle";
      pattern = "*";
      callback.__raw = ''
        function()
          local ignore = { oil = true, fzf = true }
          if ignore[vim.bo.filetype] then return end
          vim.wo.relativenumber = false
        end
      '';
    }
    {
      event = [ "InsertLeave" ];
      group = "NumberToggle";
      pattern = "*";
      callback.__raw = ''
        function()
          local ignore = { oil = true, fzf = true }
          if ignore[vim.bo.filetype] then return end
          vim.wo.relativenumber = true
        end
      '';
    }

    # Disable mini.pairs backtick and copilot cmp in markdown/gitcommit
    {
      event = "FileType";
      group = "markdown_disable_pairs";
      pattern = [
        "gitcommit"
        "markdown"
      ];
      callback.__raw = ''
        function(event)
          vim.keymap.set("i", "`", "`", { buffer = event.buf })
          vim.b.ai_cmp = false
        end
      '';
    }

    # Copilot buffers: disable line numbers / conceal
    {
      event = "BufEnter";
      group = "copilot_buf";
      pattern = "copilot-*";
      callback.__raw = ''
        function()
          vim.opt_local.relativenumber = false
          vim.opt_local.number = false
          vim.opt_local.conceallevel = 0
        end
      '';
    }

    # Highlight yanked text
    {
      event = "TextYankPost";
      group = "highlight_yank";
      desc = "Highlight when yanking (copying) text";
      callback.__raw = ''
        function()
          vim.hl.on_yank()
        end
      '';
    }

    # Restore cursor position on BufReadPre
    {
      event = "BufReadPre";
      group = "RestoreCursor";
      callback.__raw = ''
        function(args)
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
        end
      '';
    }
  ];
}
