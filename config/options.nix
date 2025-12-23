{ pkgs, ... }:
{
  # Neovim options ported from lua/config/opts.lua
  
  opts = {
    # Global options
    winborder = "rounded";
    
    # Editor options
    autowrite = true;
    autoread = true;
    clipboard = "unnamedplus";
    completeopt = "menu,menuone,noselect";
    conceallevel = 1;
    confirm = true;
    cursorline = true;
    expandtab = true;
    formatoptions = "jcroqlnt";
    
    # Search options
    grepformat = "%f:%l:%c:%m";
    grepprg = "rg --vimgrep";
    ignorecase = true;
    smartcase = true;
    
    # Preview options
    inccommand = "nosplit";
    
    # UI options
    laststatus = 3;
    list = true;
    mouse = "nv";
    mousemoveevent = true;
    number = true;
    relativenumber = true;
    pumblend = 10;
    pumheight = 10;
    scrolloff = 4;
    sidescrolloff = 8;
    showmode = false;
    signcolumn = "yes";
    
    # Split options
    splitbelow = true;
    splitright = true;
    splitkeep = "screen";
    
    # Indentation options
    shiftround = true;
    shiftwidth = 2;
    smartindent = true;
    tabstop = 2;
    
    # Spelling
    spelllang = "en";
    
    # Terminal options
    termguicolors = true;
    
    # Timing options
    timeoutlen = 300;
    updatetime = 200;
    
    # Undo options
    undofile = true;
    undolevels = 10000;
    
    # Other options
    virtualedit = "block";
    wildmode = "longest:full,full";
    winminwidth = 5;
    wrap = false;
    autochdir = false;
    
    # Session options
    sessionoptions = "buffers,curdir,tabpages,winsize,help,globals,skiprtp,folds";
    
    # Folding
    fillchars = {
      foldopen = "";
      foldclose = "";
      fold = " ";
      foldsep = " ";
      diff = "╱";
      eob = " ";
    };
  };
  
  # Enable smooth scroll on nvim >= 0.10
  extraConfigLua = ''
    if vim.fn.has("nvim-0.10") == 1 then
      vim.opt.smoothscroll = true
    end
    
    -- Append to shortmess
    vim.opt.shortmess:append({ W = true, I = true, c = true, C = true })
  '';
  
  # Global variables
  globals = {
    # For nvim-ts-context-commentstring
    skip_ts_context_commentstring_module = true;
    markdown_recommended_style = 0;
    qf_is_open = false;
  };
  
  # WSL clipboard configuration
  extraConfigLuaPre = ''
    -- Set wsl-clipboard for vim clipboard if running WSL
    local function is_wsl()
      local version_file = io.open("/proc/version", "rb")
      if version_file ~= nil and string.find(version_file:read("*a"), "microsoft") then
        version_file:close()
        return true
      end
      return false
    end
    
    if is_wsl() then
      vim.g.clipboard = {
        name = "wsl-clipboard",
        copy = {
          ["+"] = "wcopy",
          ["*"] = "wcopy",
        },
        paste = {
          ["+"] = "wpaste",
          ["*"] = "wpaste",
        },
        cache_enabled = true,
      }
    end
  '';
  
  # Diagnostics configuration
  diagnostics = {
    virtual_text = true;
    signs = {
      text = {
        error = "";
        warn = "";
        info = "󰋼";
        hint = "󰌵";
      };
    };
    float = {
      border = "rounded";
    };
    underline = true;
    update_in_insert = false;
  };
}
