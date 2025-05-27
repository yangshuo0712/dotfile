return
{
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        ft = { "markdown" },
        build = ":call mkdp#util#install()",
    },
    {
        "MeanderingProgrammer/render-markdown.nvim",
        dependencies = {
            'nvim-treesitter/nvim-treesitter',
            'echasnovski/mini.nvim'
        }, -- if you use the mini.nvim suite
        ft = {
            "markdown",
            "codecompanion"
        },
        opts = {
            heading = {
                backgrounds = {
                    -- 'RenderMarkdownH1Bg',
                    -- 'RenderMarkdownH2Bg',
                    -- 'RenderMarkdownH3Bg',
                    -- 'RenderMarkdownH4Bg',
                    -- 'RenderMarkdownH5Bg',
                    -- 'RenderMarkdownH6Bg',
                },
            },
        }
    },
}
