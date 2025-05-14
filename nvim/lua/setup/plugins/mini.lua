return
{
    {
        'echasnovski/mini.nvim',
        version = false,
        config = function()
            require 'mini.ai'.setup()
            require 'mini.pairs'.setup()
            require 'mini.surround'.setup()
            require 'mini.cursorword'.setup()
            require 'mini.bracketed'.setup()
            local hipatterns = require 'mini.hipatterns'
            hipatterns.setup({
                highlighters = {
                    fixme     = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
                    hack      = { pattern = '%f[%w]()HACK()%f[%W]', group = 'MiniHipatternsHack' },
                    todo      = { pattern = '%f[%w]()TODO()%f[%W]', group = 'MiniHipatternsTodo' },
                    note      = { pattern = '%f[%w]()NOTE()%f[%W]', group = 'MiniHipatternsNote' },
                    hex_color = hipatterns.gen_highlighter.hex_color(),
                },
            })

            local splitjoin_config = {
                detect = {
                    separator = '[,;]',
                }
            }
            require 'mini.splitjoin'.setup(splitjoin_config)

            local move_config = {
                mappings = {
                    -- Move visual selection in Visual mode. Defaults are Alt (Meta) + hjkl.
                    left = '<M-h>',
                    right = '<M-l>',
                    down = '<M-j>',
                    up = '<M-k>',

                    -- Move current line in Normal mode
                    line_left = '<M-H>',
                    line_right = '<M-L>',
                    line_down = '<M-J>',
                    line_up = '<M-K>',
                },

                -- Options which control moving behavior
                options = {
                    -- Automatically reindent selection during linewise vertical move
                    reindent_linewise = true,
                },
            }
            require 'mini.move'.setup(move_config)

            local files_config = {
                options = {
                    -- Whether to delete permanently or move into module-specific trash
                    permanent_delete = true,
                    -- Whether to use for editing directories
                    use_as_default_explorer = true,
                },

                -- Customization of explorer windows
                windows = {
                    -- Maximum number of windows to show side by side
                    max_number = math.huge,
                    -- Whether to show preview of file/directory under cursor
                    preview = false,
                    -- Width of focused window
                    width_focus = 50,
                    -- Width of non-focused window
                    width_nofocus = 15,
                    -- Width of preview window
                    width_preview = 25,
                },
            }
            require 'mini.files'.setup(files_config)
            ---@diagnostic disable-next-line: undefined-global
            vim.keymap.set('n', '<leader>e', function () MiniFiles.open() end, { desc = 'Open MiniFiles'} )
        end,
    },
    {
        "echasnovski/mini.icons",
        config = function()
            require 'mini.icons'.setup()
        end
    }
}
