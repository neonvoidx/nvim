{ lib, ... }:
{
  config.vim = {
    globals = {
      # Speed up ts-context-commentstring
      skip_ts_context_commentstring_module = true;
      markdown_recommended_style = 0;
      qf_is_open = false;

      # Leader keys – must be set before any keymap that uses <leader>
      mapleader = " ";
      maplocalleader = "\\";
    };

    options = {
      autowrite = true;
      autoread = true;
      clipboard = "unnamedplus";
      completeopt = "menu,menuone,noselect";
      conceallevel = 1;
      confirm = true;
      cmdheight = 0;
      cursorline = true;
      expandtab = true;
      formatoptions = "jcroqlnt";
      grepformat = "%f:%l:%c:%m";
      grepprg = "rg --vimgrep";
      ignorecase = true;
      inccommand = "nosplit";
      laststatus = 3;
      list = false;
      mouse = "nv";
      mousemoveevent = true;
      number = true;
      pumblend = 10;
      pumborder = "rounded";
      pumheight = 10;
      relativenumber = true;
      scrolloff = 4;
      shiftround = true;
      shiftwidth = 2;
      showmode = false;
      sidescrolloff = 8;
      # TODO: Revisit whether marks/statuscolumn behavior makes a wider sign column useful.
      signcolumn = "yes";
      smartcase = true;
      smartindent = true;
      splitbelow = true;
      splitkeep = "screen";
      splitright = true;
      softtabstop = 2;
      tabstop = 2;
      termguicolors = true;
      timeoutlen = 300;
      undofile = true;
      undolevels = 10000;
      updatetime = 200;
      virtualedit = "block";
      wildmode = "longest:full,full";
      winminwidth = 5;
      wrap = false;
      autochdir = false;
      smoothscroll = true;
      shada = "!,'300,<50,s10,h";

      # Folding
      foldcolumn = "1";
      foldlevel = 99;
      foldlevelstart = 99;
      foldenable = true;
    };

    # Options that require raw Lua (complex types or not exposed by nvf)
    luaConfigRC."options-extra" = lib.nvim.dag.entryAnywhere /* lua */ ''
      -- winborder (vim.o global option, not in vim.opt)
      vim.o.winborder = "rounded"

      -- Complex option types
      vim.opt.sessionoptions = { "blank", "buffers", "curdir", "winsize", "help", "globals", "skiprtp", "folds" }
      vim.opt.shortmess:append({ a = true, A = true, W = true, I = true, c = true, C = true })
      vim.opt.spelllang = { "en" }

      do
        local cwd = vim.fn.getcwd()
        local git_dir = vim.fs.find(".git", { path = cwd, upward = true })[1]
        local root = git_dir and vim.fn.fnamemodify(git_dir, ":h") or cwd
        local shada_dir = vim.fn.stdpath("state") .. "/shada-projects"

        vim.fn.mkdir(shada_dir, "p")
        vim.opt.shadafile = shada_dir .. "/" .. vim.fn.sha256(root) .. ".shada"
      end

      vim.opt.fillchars = {
        foldopen = "▾",
        foldclose = "▸",
        fold = " ",
        foldsep = " ",
        diff = "╱",
        eob = " ",
      }

      vim.diagnostic.config({
        virtual_text = true,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN] = "",
            [vim.diagnostic.severity.INFO] = "󰋼",
            [vim.diagnostic.severity.HINT] = "󰌵",
          },
        },
        float = {
          border = "rounded",
          format = function(d)
            return ("%s (%s) [%s]"):format(d.message, d.source, d.code or d.user_data.lsp.code)
          end,
        },
        underline = true,
        jump = { float = true },
      })
    '';
  };
}
