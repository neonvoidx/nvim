-- NOTE: nixCats: this just gives nixCats global command a default value
-- so that it doesnt throw an error if you didnt install via nix.
-- usage of both this setup and the nixCats command is optional,
-- but it is very useful for passing info from nix to lua so you will likely use it at least once.
require('nixCatsUtils').setup {
  non_nix_value = true,
}

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- NOTE: nixCats: You might want to move the lazy-lock.json file
local function getlockfilepath()
  if require('nixCatsUtils').isNixCats and type(nixCats.settings.unwrappedCfgPath) == 'string' then
    return nixCats.settings.unwrappedCfgPath .. '/lazy-lock.json'
  else
    return vim.fn.stdpath 'config' .. '/lazy-lock.json'
  end
end

-- NOTE: nixCats: this is the lazy wrapper. Use it like require('lazy').setup() but with an extra
-- argument, the path to lazy.nvim as downloaded by nix, or nil, before the normal arguments.
require('nixCatsUtils.lazyCat').setup(nixCats.pawsible { 'allPlugins', 'start', 'lazy.nvim' }, {
  { import = "plugins" },
}, {
  lockfile = getlockfilepath(),
  checker = { enabled = true, concurrency = 1 },
  change_detection = { enabled = true, notify = false },
  ui = {
    size = { width = 0.8, height = 0.8 },
    border = "rounded",
    backdrop = 50,
    title = "Lazy",
    title_pos = "left",
  },
  git = {
    log = { "-1" },
  },
  rocks = {
    enabled = true,
    hererocks = nil,
  },
  install = {
    missing = true,
    colorscheme = { "eldritch" },
  },
})

vim.keymap.set("n", "<leader>l", "<cmd>Lazy<cr>", { silent = true })
