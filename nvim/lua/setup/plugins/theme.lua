return {
    -- {
    --     "shaunsingh/nord.nvim",
    --     priority = 1001,
    --     config = function()
    --         -- example
    --         vim.g.nord_contrast = false
    --         vim.g.nord_borders = true
    --         vim.g.nord_disable_background = true
    --         vim.g.nord_italic = false
    --         vim.g.nord_uniform_diff_background = false
    --         vim.g.nord_bold = false
    --
    --         require('nord').set()
    --         vim.cmd("colorscheme nord")
    --     end,
    -- },
    {
        "gbprod/nord.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            require("nord").setup({})
            vim.cmd.colorscheme("nord")
        end,
    },
    -- {
    --     'sainnhe/sonokai',
    --     lazy = false,
    --     priority = 1000,
    --     config = function()
    --         -- Optionally configure and load the colorscheme
    --         -- directly inside the plugin declaration.
    --         vim.g.sonokai_enable_italic = true
    --         vim.g.sonokai_style = 'atlantis'
    --         vim.cmd.colorscheme('sonokai')
    --     end
    -- }
}
