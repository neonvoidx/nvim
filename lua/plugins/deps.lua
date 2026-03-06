-- Dependency specs using lze's dep_of / on_require handlers.
-- These replace manual vim.cmd.packadd() calls inside after hooks.
return {
  -- nui.nvim is required by noice during its initialisation
  { "nui.nvim", dep_of = "noice.nvim" },
  -- promise-async is required by nvim-ufo during its initialisation
  { "promise-async", dep_of = "nvim-ufo" },
  -- blink-copilot is a blink.cmp source — must be available before blink loads
  { "blink-copilot", dep_of = "blink.cmp" },
  -- SchemaStore is required by lspconfig's jsonls / yamlls setup
  { "SchemaStore.nvim", dep_of = "nvim-lspconfig" },
  -- treesitter-endwise integrates with treesitter and must load before it
  { "nvim-treesitter-endwise", dep_of = "nvim-treesitter" },
  -- plenary is required lazily by yazi and others — load on any require("plenary.*")
  { "plenary.nvim", on_require = "plenary" },
}
