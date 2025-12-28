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
}
