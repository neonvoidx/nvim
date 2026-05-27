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
