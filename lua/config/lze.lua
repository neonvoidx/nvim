-- Load all plugin specs via lze
-- lua/plugins/init.lua returns { import = "plugins.X" } specs
if nixInfo and nixInfo.lze and type(nixInfo.lze.load) == "function" then
  nixInfo.lze.load("plugins")
end
