return {
	{
		"shaunsingh/nord.nvim",
		config = function()
            -- example
			vim.g.nord_contrast = false
			vim.g.nord_borders = true
			vim.g.nord_disable_background = false
			vim.g.nord_italic = true
			vim.g.nord_uniform_diff_background = false
			vim.g.nord_bold = true

			require('nord').set()
			vim.cmd("colorscheme nord")
		end,
	},
	{
		"rmehri01/onenord.nvim",
		config = function()
		-- 	require("onenord").setup({
		-- 		theme = nil, -- "dark" or "light". Alternatively, remove the option and set vim.o.background instead
		-- 		borders = false, -- Split window borders
		-- 		fade_nc = false, -- Fade non-current windows, making them more distinguishable
		-- 		-- Style that is applied to various groups: see `highlight-args` for options
		-- 		styles = {
		-- 			comments = "italic",
		-- 			strings = "None",
		-- 			keywords = "None",
		-- 			functions = "bold",
		-- 			variables = "None",
		-- 			diagnostics = "underline",
		-- 		},
		-- 		disable = {
		-- 			background = false, -- Disable setting the background color
		-- 			float_background = false, -- Disable setting the background color for floating windows
		-- 			cursorline = false, -- Disable the cursorline
		-- 			eob_lines = true, -- Hide the end-of-buffer lines
		-- 		},
		-- 		-- Inverse highlight for different groups
		-- 		inverse = {
		-- 			match_paren = false,
		-- 		},
		-- 		custom_highlights = {}, -- Overwrite default highlight groups
		-- 		custom_colors = {}, -- Overwrite default colors
		-- 	})
		-- 	vim.cmd('colorscheme onenord')
		end,
	},
}
