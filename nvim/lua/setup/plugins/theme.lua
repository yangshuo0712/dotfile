return {
	{
		"shaunsingh/nord.nvim",
        priority = 1001,
		config = function()
            -- example
			vim.g.nord_contrast = false
			vim.g.nord_borders = true
			vim.g.nord_disable_background = false
			vim.g.nord_italic = false
			vim.g.nord_uniform_diff_background = false
			vim.g.nord_bold = true

			require('nord').set()
			vim.cmd("colorscheme nord")
		end,
	},
}
