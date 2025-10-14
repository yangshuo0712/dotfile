return {
	{
		name = "custom_highlight",
		dir = vim.fn.stdpath("config") .. "/lua/setup/custom/highlight",
		lazy = false,
		priority = 999,
		config = function()
			require("setup.custom.highlight.highlight").setup()
		end,
	},
	{
		name = "custom_lspconfig",
		dir = vim.fn.stdpath("config") .. "/lua/setup/custom/lsp",
		lazy = false,
		priority = 900,
		config = function()
			require("setup.custom.lsp.lsp").setup()
		end,
	},
	{
		name = "custom_statusline",
		dir = vim.fn.stdpath("config") .. "/lua/setup/custom/statusline",
		lazy = false,
		priority = 1100,
		config = function()
			require("setup.custom.statusline.statusline").setup()
		end,
	},
	{
		name = "custom_runme",
		dir = vim.fn.stdpath("config") .. "/lua/setup/custom/runme",
		lazy = true,
		priority = 850,
		keys = {
			{ "<F5>", mode = "n" },
			{ "<leader>r", mode = "v" },
			{ "<leader>R", mode = { "n", "v" } },
			{ "<C-\\>", mode = { "n", "i", "v", "t", "x" } },
		},
		dependencies = {
			{ "akinsho/toggleterm.nvim" },
		},
		config = function()
			local ok, runme = pcall(require, "setup.custom.runme.runme")
			if not ok then
				vim.notify("[custom_runme] require failed: " .. tostring(runme), vim.log.levels.ERROR)
				return
			end
			runme.setup({
				terminal_opts = { size = 15, direction = "horizontal", close_on_exit = false, open_mapping = nil },
				keymaps = { run_file = "<F5>", run_selection = "<leader>r", send_to_repl = "<leader>R" },
				tmp_dir = nil,
				use_toggleterm = true,
			})
		end,
	},
}
