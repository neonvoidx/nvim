{
  userPlugins,
  pkgs,
  lib,
  ...
}:
let
  markdown-toc-nvim = userPlugins.markdown-toc-nvim;
  presenting-nvim = userPlugins.presenting-nvim;
in
{
  config.vim = {
    startPlugins = with pkgs.vimPlugins; [
      render-markdown-nvim
      obsidian-nvim
      markdown-toc-nvim
      markdown-preview-nvim
      presenting-nvim
    ];

    luaConfigRC."markdown" = lib.nvim.dag.entryAnywhere /* lua */ ''
        vim.g.mkdp_filetypes = { "markdown" }

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
        require("obsidian").setup({
          attachments = {
            image_text_func = function(path)
              local name = vim.fs.basename(tostring(path))
              local encoded_name = require("obsidian.util").urlencode(name)
              return string.format("![%s](%s)", name, encoded_name)
            end,
            folder = "./",
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
          link = { style = "markdown" },
          frontmatter = { enabled = true },
          templates = { folder = "templates", date_format = "%d %b %Y" },
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

        -- ── Markdown-toc ─────────────────────────────────────────────────
        require("mtoc").setup({
          heading = { before_toc = false },
          auto_update = true,
        })

        -- ── Markdown-preview ──────────────────────────────────────────────
        require("presenting").setup({})

        vim.keymap.set("n", "<leader>cp", "<cmd>MarkdownPreview<CR>", { desc = "Markdown preview" })
        vim.keymap.set("n", "<leader>cP", "<cmd>Presenting<CR>", { desc = "Presentation mode toggle" })
        vim.keymap.set("n", "<leader>cX", function()
          if _G.Presenting ~= nil then
            _G.Presenting.quit()
          end
        end, { desc = "Presentation mode stop" })
    '';
  };
}
