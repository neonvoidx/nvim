-- vim.pack: plugins are cloned into {data}/site/pack/core/opt and locked in our
-- own state dir. Requires `git`
--
-- The default 'packlockfile' is hardcoded to $XDG_CONFIG_HOME/nvim/…, i.e. it
-- would collide with any other Neovim config on this machine. Isolate it.
-- TODO remove after done
vim.opt.packlockfile = vim.fn.stdpath("state") .. "/pack-lock.json"

-- Order matters: each plugin is `:packadd!`-ed in order, so dependencies come
-- before their consumers.
local function add(plugins)
	local ok, err = pcall(vim.pack.add, plugins, { confirm = false })
	if not ok then
		vim.notify("vim.pack: " .. tostring(err), vim.log.levels.WARN)
	end
end

add({
	-- colorscheme
	{ src = "https://github.com/eldritch-theme/eldritch.nvim" },
	-- dependencies
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/tpope/vim-repeat" },
	{ src = "https://github.com/kevinhwang91/promise-async" },
	-- editing / motion / mini
	{ src = "https://github.com/echasnovski/mini.nvim" },
	{ src = "https://github.com/gbprod/yanky.nvim" },
	-- formatting / linting
	{ src = "https://github.com/stevearc/conform.nvim" },
	{ src = "https://github.com/mfussenegger/nvim-lint" },
	-- context / helpers
	{ src = "https://github.com/nacro90/numb.nvim" },
	{ src = "https://github.com/NMAC427/guess-indent.nvim" },
	{ src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" },
	-- buffers / git
	{ src = "https://github.com/kevinhwang91/nvim-ufo" },
	-- navigation / file management
	{ src = "https://github.com/smart-splits-nvim/smart-splits.nvim" },
	{ src = "https://github.com/mikavilpas/yazi.nvim" },
})
