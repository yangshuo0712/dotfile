return {
    {
        name     = "custom_highlight",
        dir      = vim.fn.stdpath("config") .. "/lua/setup/custom/highlight",
        lazy     = false,
        priority = 999,
        config   = function()
            require("setup.custom.highlight.highlight").setup()
        end,
    },
    {
        name     = "custom_lspconfig",
        dir      = vim.fn.stdpath("config") .. "/lua/setup/custom/lsp",
        lazy     = false,
        priority = 900,
        config   = function()
            require("setup.custom.lsp.lsp").setup()
        end,
    },
    {
        name     = "custom_statusline",
        dir      = vim.fn.stdpath("config") .. "/lua/setup/custom/statusline",
        lazy     = false,
        priority = 1100,
        config   = function()
            require("setup.custom.statusline.statusline").setup()
        end,
    },
}
