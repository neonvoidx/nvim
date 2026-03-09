{ ... }:

{
  globals = {
    # For speed up, using nvim-ts-context-commentstring
    skip_ts_context_commentstring_module = true;
    markdown_recommended_style = 0;
    qf_is_open = false;

    # Set leader keys early so all keymaps using <leader> resolve correctly.
    mapleader = " ";
    maplocalleader = ",";
  };

  opts = {
    autowrite = true;
    autoread = true;
    clipboard = "unnamedplus";
    completeopt = "menu,menuone,noselect";
    conceallevel = 1;
    confirm = true;
    cursorline = true;
    expandtab = true;
    formatoptions = "jcroqlnt";
    grepformat = "%f:%l:%c:%m";
    grepprg = "rg --vimgrep";
    ignorecase = true;
    inccommand = "nosplit";
    laststatus = 3;
    list = true;
    mouse = "nv";
    mousemoveevent = true;
    number = true;
    pumblend = 10;
    pumheight = 10;
    relativenumber = true;
    scrolloff = 4;
    sessionoptions = [
      "buffers"
      "curdir"
      "tabpages"
      "winsize"
      "help"
      "globals"
      "skiprtp"
      "folds"
    ];
    shiftround = true;
    shiftwidth = 2;
    shortmess = "WICc";
    showmode = false;
    sidescrolloff = 8;
    signcolumn = "yes";
    smartcase = true;
    smartindent = true;
    spelllang = [ "en" ];
    splitbelow = true;
    splitkeep = "screen";
    splitright = true;
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

    # Folding UI
    fillchars = {
      foldopen = "";
      foldclose = "";
      fold = " ";
      foldsep = " ";
      diff = "╱";
      eob = " ";
    };
  };

  # Not a vim.opt setting; it is a vim.o option (global option).
  # nixvim doesn't expose winborder under opts at the time of writing, so keep it as lua.
  extraConfigLua = ''
    vim.o.winborder = "rounded"

    vim.diagnostic.config({
      virtual_text = true,
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = "",
          [vim.diagnostic.severity.WARN] = "",
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
      jump = {
        float = true,
      },
    })
  '';
}
