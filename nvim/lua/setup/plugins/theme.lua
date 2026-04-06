return {
    {
        "gbprod/nord.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            require("nord").setup({
                styles = {
                    -- Style to be applied to different syntax groups
                    -- Value is any valid attr-list value for `:help nvim_set_hl`
                    comments = { italic = false },
                    keywords = {},
                    functions = {},
                    variables = {},
                }
            })
            -- vim.cmd.colorscheme("nord")
        end,
    },
    {
        "EdenEast/nightfox.nvim",
        config = function()
            require("nightfox").setup({})
            vim.cmd.colorscheme("nordfox")
        end
    },
}
