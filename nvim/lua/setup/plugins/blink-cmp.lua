return {
    'saghen/blink.cmp',
    dependencies = 'rafamadriz/friendly-snippets',
    version = '*',
    ---@module 'blink.cmp'
    ---type blink.cmp.Config
    opts = {
        keymap = { preset = 'default' },
        appearance = {
            use_nvim_cmp_as_default = true,
            nerd_font_variant = 'mono',
        },
        sources = {
            default = { 'lsp', 'path', 'snippets', 'buffer', 'codecompanion' },
        },
        cmdline = {
            enabled = false,
        },
        completion = {
            keyword = { range = "full" },
            list = { selection = { preselect = true, auto_insert = true } },
            accept = { auto_brackets = { enabled = true }, },
            menu = {
                auto_show = true,
                draw = {
                    columns = {
                        { "label", "label_description", gap = 1 },
                        { "kind_icon", "kind" },
                    },
                },
            },
            documentation = {
                auto_show = false,
                auto_show_delay_ms = 500,
            },
            ghost_text = { enabled = false },
        },
    },
    opts_extend = { 'sources.default' },
}
