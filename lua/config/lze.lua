-- Load all plugin specs via lze
local lze = nixInfo.lze

local plugin_modules = {
  "plugins.eldritch",
  "plugins.alt-themes",
  "plugins.snacks",
  "plugins.noice",
  "plugins.lualine",
  "plugins.bufferline",
  "plugins.whichkey",
  "plugins.flash",
  "plugins.mini",
  "plugins.comments",
  "plugins.diff",
  "plugins.session",
  "plugins.folds",
  "plugins.format",
  "plugins.lint",
  "plugins.git",
  "plugins.guess-indent",
  "plugins.help",
  "plugins.highlight-colors",
  "plugins.inc-rename",
  "plugins.numb",
  "plugins.nix",
  "plugins.overseer",
  "plugins.quickfix",
  "plugins.yanky",
  "plugins.blink",
  "plugins.ai",
  "plugins.treesitter",
  "plugins.lsp",
  "plugins.mason",
  "plugins.markdown",
  "plugins.snippets",
  "plugins.kitty",
  "plugins.yazi",
}

for _, mod in ipairs(plugin_modules) do
  local ok, specs = pcall(require, mod)
  if ok and type(specs) == "table" then
    lze.load(specs)
  elseif not ok then
    vim.notify("lze.lua: failed to load " .. mod .. ": " .. tostring(specs), vim.log.levels.WARN)
  end
end
