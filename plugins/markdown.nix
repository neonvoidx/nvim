{ userPlugins, pkgs, lib, ... }:
let
  markdown-toc-nvim = userPlugins.markdown-toc-nvim;
in
{
  config.vim = {
    startPlugins = with pkgs.vimPlugins; [
      render-markdown-nvim
      obsidian-nvim
      markdown-toc-nvim
    ];

    luaConfigRC."markdown" = lib.nvim.dag.entryAnywhere /* lua */ ''
      -- ── Render-markdown ───────────────────────────────────────────────
      require("render-markdown").setup({
        file_types = { "markdown", "codecompanion" },
        anti_conceal = {
          enabled = true,
          ignore = { code_background = true, sign = true },
        },
        completions = { blink = { enabled = true } },
        preset = "obsidian",
        bullet = { right_pad = 1 },
        checkbox = {
          enabled = true,
          unchecked = { icon = "▢ " },
          checked   = { icon = "✓ " },
          custom    = { todo = { rendered = "◯ " } },
          right_pad = 1,
        },
      })

      -- ── Obsidian ──────────────────────────────────────────────────────
      local cwd = vim.fn.getcwd()
      local vault_path = vim.fn.expand("~/vault")
      local blog_path  = vim.fn.expand("~/homepage")

      if vim.startswith(cwd, vault_path) or vim.startswith(cwd, blog_path) then
        require("obsidian").setup({
          attachments = {
            image_text_func = function(path)
              local name = vim.fs.basename(tostring(path))
              local encoded_name = require("obsidian.util").urlencode(name)
              return string.format("![%s](%s)", name, encoded_name)
            end,
            img_folder = "./",
          },
          legacy_commands = false,
          checkbox = { order = { " ", "x", "!", ">", "~" } },
          ui = { enable = false },
          workspaces = {
            { name = "vault", path = vim.fn.expand("~/vault") },
          },
          daily_notes = {
            folder = "Daily Notes",
            date_format = "%d %b %Y",
            template = vim.fn.expand("~/vault/templates/daily-note.md"),
          },
          completion = { nvim_cmp = false, blink = true },
          preferred_link_style = "markdown",
          disable_frontmatter = false,
          templates = { folder = "templates", date_format = "%d %b %Y" },
          follow_url_func = function(url) vim.ui.open(url) end,
          picker = {
            name = "snacks.pick",
            new = "<C-x>",
            insert_link = "<C-l>",
          },
        })

        local wk = require("which-key")
        wk.add({ { "<leader>o", group = "Obsidian", icon = "" } })

        local prefix = "<leader>o"
        local map = vim.keymap.set
        map("n", prefix .. "o", "<cmd>Obsidian open<CR>",        { desc = "Open on App" })
        map("n", prefix .. "n", "<cmd>Obsidian new<CR>",         { desc = "New Note" })
        map("n", prefix .. "b", "<cmd>Obsidian backlinks<CR>",   { desc = "Backlinks" })
        map("n", prefix .. "t", "<cmd>Obsidian tags<CR>",        { desc = "Tags" })
        map("n", prefix .. "T", "<cmd>Obsidian template<CR>",    { desc = "Template" })
        map("n", prefix .. "d", "<cmd>Obsidian dailies<CR>",     { desc = "Daily Notes" })
        map("n", prefix .. "w", "<cmd>Obsidian workspace<CR>",   { desc = "Workspace" })
        map("n", prefix .. "r", "<cmd>Obsidian rename<CR>",      { desc = "Rename" })
        map("n", prefix .. "i", "<cmd>Obsidian paste_img<CR>",   { desc = "Paste Image" })
        map("n", "<leader>sO", "<cmd>Obsidian search<CR>",  { desc = "Obsidian Grep" })
        map("v", prefix .. "l", "<cmd>Obsidian link<CR>",        { desc = "Link" })
        map("v", prefix .. "N", "<cmd>Obsidian linknew<CR>",     { desc = "New Link" })
        map("v", prefix .. "e", "<cmd>Obsidian extractnote<CR>", { desc = "Extract Note" })
      end

      -- ── Markdown-toc ─────────────────────────────────────────────────
      require("mtoc").setup({
        heading = { before_toc = false },
        auto_update = true,
      })
    '';
  };
}
