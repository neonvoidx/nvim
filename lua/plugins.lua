local project_root = require("util").project_root

vim.pack.add({
  -- Dependencies
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/nvim-tree/nvim-web-devicons",
  -- UI
  "https://github.com/akinsho/bufferline.nvim",
  "https://github.com/eldritch-theme/eldritch.nvim",
  "https://github.com/dmtrKovalenko/fff.nvim",
  "https://github.com/mikesmithgh/kitty-scrollback.nvim",
  "https://github.com/folke/persistence.nvim",
  "https://github.com/nvim-lualine/lualine.nvim",
  "https://github.com/knubie/vim-kitty-navigator",
  "https://github.com/folke/which-key.nvim",
  "https://github.com/mikavilpas/yazi.nvim",
  -- Coding
  "https://github.com/folke/flash.nvim",
  "https://github.com/lewis6991/gitsigns.nvim",
  "https://github.com/kdheepak/lazygit.nvim",
  "https://github.com/nvim-mini/mini.pairs",
  "https://github.com/stevearc/conform.nvim",
  "https://github.com/mfussenegger/nvim-lint",
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/nvim-treesitter/nvim-treesitter",
  "https://github.com/nvim-treesitter/nvim-treesitter-context",
  "https://github.com/RRethy/nvim-treesitter-endwise",
  "https://github.com/folke/todo-comments.nvim",
  "https://github.com/folke/trouble.nvim",
  "https://github.com/calops/hmts.nvim",
  -- Folding
  "https://github.com/kevinhwang91/promise-async",
  "https://github.com/kevinhwang91/nvim-ufo",
  -- Editing
  "https://github.com/nvim-mini/mini.surround",
  "https://github.com/rachartier/tiny-inline-diagnostic.nvim",
}, { confirm = false })

-- Colorscheme: Eldritch
require("eldritch").setup({ transparent = true })
vim.cmd.colorscheme("eldritch")

-- Bufferline
require("bufferline").setup({ options = { diagnostics = "nvim_lsp", always_show_bufferline = true } })

-- FFF
vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if name == "fff.nvim" and (kind == "install" or kind == "update") then
      if not ev.data.active then
        vim.cmd.packadd("fff.nvim")
      end
      require("fff.download").download_or_build_binary()
    end
  end,
})
local fff_plugin_dir = vim.fn.stdpath("data") .. "/site/pack/core/opt/fff.nvim"
local fff_binary = fff_plugin_dir .. "/target/release/libfff_nvim.so"
if not vim.uv.fs_stat(fff_binary) then
  local ok, err = pcall(require("fff.download").download_or_build_binary)
  if not ok then
    vim.notify("fff.nvim binary build failed: " .. tostring(err), vim.log.levels.WARN)
  end
end
require("fff").setup({
  base_path = vim.fn.getcwd(),
  lazy_sync = true,
  debug = {
    enabled = true,
    show_scores = true,
    show_file_info = { file_info = true, score_breakdown = false, timings = false, full_path = false },
  },
  title = "🗲 fff",
  prompt = "> ",
  layout = { prompt_position = "top", height = 0.9, width = 0.9 },
  keymaps = { move_up = { "<Up>", "<C-k>" }, move_down = { "<Down>", "<C-j>" } },
})

-- Flash
require("flash").setup({ auto_jump = true, multi_window = false })

-- Gitsigns
require("gitsigns").setup({
  current_line_blame = true,
  current_line_blame_opts = { delay = 100 },
  signs = {
    add = { text = "+" },
    change = { text = "± " },
    delete = { text = "˗" },
    topdelete = { text = "" },
    changedelete = { text = "±" },
  },
  on_attach = function(bufnr)
    local gitsigns = require("gitsigns.actions")
    -- Navigation
    vim.keymap.set("n", "]c", function()
      if vim.wo.diff then
        vim.cmd.normal({ "]c", bang = true })
      else
        gitsigns.nav_hunk("next")
      end
    end, { desc = "Next hunk" })

    vim.keymap.set("n", "[c", function()
      if vim.wo.diff then
        vim.cmd.normal({ "[c", bang = true })
      else
        gitsigns.nav_hunk("prev")
      end
    end, { desc = "Prev hunk" })
    vim.keymap.set("n", "<leader>gb", function()
      gitsigns.blame()
    end, { buffer = bufnr, desc = "Toggle blame" })
    vim.keymap.set("n", "<leader>gd", function()
      gitsigns.diffthis()
    end, { buffer = bufnr, desc = "Diff this against upstream" })
    vim.keymap.set("n", "<leader>gc", function()
      gitsigns.show_commit()
    end, { buffer = bufnr, desc = "Show commit" })
    vim.keymap.set("n", "<leader>gh", function()
      gitsigns.setqflist()
    end, { buffer = bufnr, desc = "Send hunks to qf" })
    vim.keymap.set("n", "<leader>gr", function()
      local rev = vim.fn.input("Revision: ")
      gitsigns.show(rev)
    end, { buffer = bufnr, desc = "Show revision..." })
  end,
})

-- Kitty Scrollback
local is_kitty = vim.env.TERM == "xterm-kitty"
if is_kitty then
  local pass_keys = vim.api.nvim_get_runtime_file("pass_keys.py", false)[1]
  if pass_keys then
    vim.fn.mkdir(vim.fn.expand("~/.config/kitty"), "p")
    vim.fn.system({ "cp", pass_keys, vim.fn.expand("~/.config/kitty/") })
  end
  require("kitty-scrollback").setup()
end

-- Mini Pairs
require("mini.pairs").setup({})

-- Mini Surround
require("mini.surround").setup({
  mappings = {
    add = "gsa",
    delete = "gsd",
    find = "gsf",
    find_left = "gsF",
    highlight = "gsh",
    replace = "gsr",
    update_n_lines = "gsn",
  },
})

-- Native UI
require("vim._core.ui2").enable({ enable = true })

-- Persistence
require("persistence").setup()
vim.schedule(function()
  require("persistence").load()
end)

-- Conform
require("conform").setup({
  notify_on_error = false,
  formatters = { prettierd = { require_cwd = true } },
  formatters_by_ft = {
    javascript = { "eslint_d", "prettierd" },
    typescript = { "eslint_d", "prettierd" },
    javascriptreact = { "eslint_d", "prettierd" },
    typescriptreact = { "eslint_d", "prettierd" },
    ["javascript.jsx"] = { "eslint_d", "prettierd" },
    ["typescript.tsx"] = { "eslint_d", "prettierd" },
    css = { "prettierd" },
    html = { "prettierd" },
    json = { "prettierd" },
    yaml = { "prettierd" },
    lua = { "stylua" },
    python = { "isort", "black" },
    markdown = { "prettierd", "markdownlint-cli2", "markdown-toc" },
    ["markdown.mdx"] = { "prettierd", "markdownlint-cli2", "markdown-toc" },
    nix = { "nixfmt" },
    rust = { "rustfmt" },
    go = { "gofmt" },
  },
  format_on_save = function(bufnr)
    if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
      return
    end
    return { timeout_ms = 500, lsp_format = "fallback" }
  end,
})

-- Nvim Lint
local lint = require("lint")
lint.linters_by_ft = {
  cmake = { "cmakelint" },
  javascript = { "eslint_d" },
  javascriptreact = { "eslint_d" },
  ["javascript.jsx"] = { "eslint_d" },
  typescript = { "eslint_d" },
  typescriptreact = { "eslint_d" },
  ["typescript.tsx"] = { "eslint_d" },
}
vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
  group = vim.api.nvim_create_augroup("lint", { clear = true }),
  callback = function()
    require("lint").try_lint()
  end,
})

-- LSP
local servers = {
  basedpyright = {},
  clangd = {},
  gopls = {},
  nixd = {},
  rust_analyzer = {},
  yamlls = {},
  lua_ls = {
    cmd = { "lua-language-server" },
    filetypes = { "lua" },
    root_markers = {
      ".luarc.json",
      ".luarc.jsonc",
      ".luacheckrc",
      ".stylua.toml",
      "stylua.toml",
      "selene.toml",
      "selene.yml",
      ".git",
    },
    settings = {
      Lua = {
        runtime = { version = "LuaJIT" },
        diagnostics = { globals = { "vim", "require" } },
        workspace = { library = vim.api.nvim_get_runtime_file("", true) },
        telemetry = { enable = false },
      },
    },
  },
  vtsls = {
    settings = {
      complete_function_calls = true,
      vtsls = {
        enableMoveToFileCodeAction = true,
        autoUseWorkspaceTsdk = true,
        experimental = { maxInlayHintLength = 30, completion = { enableServerSideFuzzyMatch = true } },
      },
      typescript = {
        updateImportsOnFileMove = { enabled = "always" },
        suggest = { completeFunctionCalls = true },
        inlayHints = {
          enumMemberValues = { enabled = true },
          functionLikeReturnTypes = { enabled = true },
          parameterNames = { enabled = "literals" },
          parameterTypes = { enabled = true },
          propertyDeclarationTypes = { enabled = true },
          variableTypes = { enabled = false },
        },
        preferences = { importModuleSpecifier = "relative" },
      },
    },
  },
}
for server, config in pairs(servers) do
  vim.lsp.config(server, config)
  vim.lsp.enable(server)
end
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
  callback = function(ev)
    local opts = { buffer = ev.buf }
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client ~= nil and client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
    end
    local function lmap(lhs, rhs, desc)
      vim.keymap.set("n", lhs, rhs, vim.tbl_extend("force", opts, { desc = desc }))
    end
    lmap("K", vim.lsp.buf.hover, "Hover documentation")
    lmap("<leader>ca", vim.lsp.buf.code_action, "Code action")
    lmap("<leader>cA", function()
      vim.lsp.buf.code_action({ apply = true, context = { only = { "source" }, diagnostics = {} } })
    end, "Code action (buffer)")
    lmap("<leader>cr", vim.lsp.buf.rename, "Rename symbol")
    lmap("<leader>li", "<cmd>checkhealth vim.lsp<cr>", "LSP Info")
    lmap("<leader>ll", function()
      vim.cmd("edit " .. vim.lsp.log.get_filename())
    end, "LSP Logs")
    lmap("<leader>lr", "<cmd>LspRestart<cr>", "LSP Restart")
    vim.lsp.inlay_hint.enable(false)
    lmap("<leader>lI", function()
      local enabled = not vim.lsp.inlay_hint.is_enabled({})
      vim.lsp.inlay_hint.enable(enabled)
      vim.notify("Inlay hints: " .. (enabled and " on" or "off"))
    end, "Toggle inlay hints")
  end,
})

-- Todo Comments
require("todo-comments").setup({
  signs = true,
  merge_keywords = false,
  keywords = {
    BUG = { icon = "", color = "error" },
    FIXME = { icon = "", color = "error" },
    fixme = { icon = "", color = "error" },
    HACK = { icon = "", color = "info" },
    NOTE = { icon = "❦", color = "info" },
    note = { icon = "❦", color = "info" },
    TODO = { icon = "★", color = "actionItem" },
    todo = { icon = "★", color = "actionItem" },
    WARN = { icon = "󰀦", color = "warning" },
    warn = { icon = "󰀦", color = "warning" },
    WARNING = { icon = "󰀦", color = "warning" },
  },
  colors = {
    actionItem = { "ActionItem", "#f1fc79" },
    default = { "Identifier", "#37f499" },
    error = { "LspDiagnosticsDefaultError", "ErrorMsg", "#f16c75" },
    info = { "LspDiagnosticsDefaultInformation", "#ebfafa" },
    warning = { "LspDiagnosticsDefaultWarning", "WarningMsg", "#f7c67f" },
  },
  highlight = { keyword = "bg", pattern = [[.*<(KEYWORDS)\s*]] },
  search = {
    command = "rg",
    args = { "--color=never", "--no-heading", "--with-filename", "--line-number", "--column" },
    pattern = [[\b(KEYWORDS)\b]],
  },
})

-- Treesitter
require("nvim-treesitter-endwise").init()
local is_nixos = (function()
  local f = io.open("/etc/os-release", "r")
  if not f then
    return false
  end
  local content = f:read("*a")
  f:close()
  return content:find("ID=nixos") ~= nil
end)()
if not is_nixos then
  vim.api.nvim_create_autocmd("UIEnter", {
    once = true,
    callback = function()
      require("nvim-treesitter.install").install("all")
    end,
  })
end

-- Treesitter Context
require("treesitter-context").setup({ enable = true, multiwindow = true, max_lines = 0, separator = "▔" })

-- UFO: better folding
require("ufo").setup({
  fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
    local newVirtText = {}
    local suffix = (" %d lines"):format(endLnum - lnum)
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
  end,
})
vim.keymap.set("n", "zR", require("ufo").openAllFolds, { desc = "Open all folds" })
vim.keymap.set("n", "zM", require("ufo").closeAllFolds, { desc = "Close all folds" })

-- HMTS
require("hmts").setup({})

-- Tiny Inline Diagnostic
require("tiny-inline-diagnostic").setup({
  preset = "modern",
  options = {
    show_source = { enabled = false },
    show_code = true,
    add_messages = { messages = true, display_count = false },
    multilines = { enabled = true, always_show = false },
    throttle = 20,
  },
})

-- Trouble
require("trouble").setup({ modes = { diagnostics_buffer = { mode = "diagnostics", filter = { buf = 0 } } } })

-- Which Key
require("which-key").setup({
  preset = "helix",
  spec = {
    {
      mode = { "n" },
      { "<leader>w", group = "+window", icon = { icon = " " } },
      { "<leader>c", group = "+code", icon = { icon = " " } },
      { "<leader>g", group = "+git", icon = { icon = " " } },
      { "<leader>", group = "+lsp", icon = { icon = " " } },
      { "<leader>u", group = "+ui", icon = { icon = " " } },
      { "<leader>b", group = "+buffer", icon = { icon = " " } },
      { "<leader>a", group = "+ai", icon = { icon = " " } },
      { "<leader>f", group = "+file", icon = { icon = " " } },
      { "<leader>.", group = "+scratch", icon = { icon = " " } },
      { "<leader>x", group = "+x", icon = { icon = " " } },
      { "<leader>n", group = "+notifications", icon = { icon = " " } },
      { "<leader>l", group = "+LSP", icon = { icon = " " } },
    },
  },
})

-- Yazi
require("yazi").setup({ open_for_directories = true })
