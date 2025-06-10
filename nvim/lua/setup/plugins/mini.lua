---@diagnostic disable: undefined-global
return {
    {
        "echasnovski/mini.nvim",
        version = false,
        config = function()
            require("mini.ai").setup()
            require("mini.pairs").setup()
            require("mini.surround").setup()
            require("mini.cursorword").setup()
            require("mini.bracketed").setup()
            require("mini.indentscope").setup()
            require("mini.extra").setup()

            local icons_config = {
                -- Icon style: 'glyph' or 'ascii'
                style              = 'glyph',

                -- Customize per category. See `:h MiniIcons.config` for details.
                default            = {},
                directory          = {},
                extension          = {},
                file               = {},
                filetype           = { go = { glyph = '', hl = 'MiniIconsAzure' } },
                lsp                = {},
                os                 = {},

                -- Control which extensions will be considered during "file" resolution
                use_file_extension = function(ext, file) return true end,
            }
            require("mini.icons").setup(icons_config)

            ---@diagnostic disable-next-line: unused-local
            local win_config = function()
                local height = math.floor(0.618 * vim.o.lines)
                local width = math.floor(0.618 * vim.o.columns)
                return {
                    anchor = "NW",
                    height = height,
                    width = width,
                    row = math.floor(0.5 * (vim.o.lines - height)),
                    col = math.floor(0.5 * (vim.o.columns - width)),
                }
            end
            local pick_config = {
                window = { config = win_config() },
                mappings = {
                    toggle_info = "<S-Tab>",
                    toggle_preview = "<Tab>",
                    move_down = "<C-n>",
                    move_up = "<C-p>",
                },
            }
            require("mini.pick").setup(pick_config)

            local hipatterns = require("mini.hipatterns")
            hipatterns.setup({
                highlighters = {
                    fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
                    hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
                    todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
                    note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },
                    hex_color = hipatterns.gen_highlighter.hex_color(),
                },
            })

            local splitjoin_config = {
                detect = {
                    separator = "[,;]",
                },
            }
            require("mini.splitjoin").setup(splitjoin_config)

            local move_config = {
                mappings = {
                    -- Move visual selection in Visual mode. Defaults are Alt (Meta) + hjkl.
                    left = "<M-h>",
                    right = "<M-l>",
                    down = "<M-j>",
                    up = "<M-k>",

                    -- Move current line in Normal mode
                    line_left = "<M-H>",
                    line_right = "<M-L>",
                    line_down = "<M-J>",
                    line_up = "<M-K>",
                },

                -- Options which control moving behavior
                options = {
                    -- Automatically reindent selection during linewise vertical move
                    reindent_linewise = true,
                },
            }
            require("mini.move").setup(move_config)

            local files_config = {
                options = {
                    -- Whether to delete permanently or move into module-specific trash
                    permanent_delete = true,
                    -- Whether to use for editing directories
                    use_as_default_explorer = true,
                },

                windows = {
                    max_number = math.huge,
                    -- Whether to show preview of file/directory under cursor
                    preview = false,
                    width_focus = 35,
                    width_nofocus = 15,
                    width_preview = 25,
                },
            }

            local map_split = function(buf_id, lhs, direction)
                local rhs = function()
                    -- Make new window and set it as target
                    local cur_target = MiniFiles.get_explorer_state().target_window
                    local new_target = vim.api.nvim_win_call(cur_target, function()
                        vim.cmd(direction .. " split")
                        return vim.api.nvim_get_current_win()
                    end)

                    MiniFiles.set_target_window(new_target)

                    -- This intentionally doesn't act on file under cursor in favor of
                    -- explicit "go in" action (`l` / `L`). To immediately open file,
                    -- add appropriate `MiniFiles.go_in()` call instead of this comment.
                end

                -- Adding `desc` will result into `show_help` entries
                local desc = "Split " .. direction
                vim.keymap.set("n", lhs, rhs, { buffer = buf_id, desc = desc })
            end

            vim.api.nvim_create_autocmd("FileType", {
                pattern = {
                    "help",
                    "lazy",
                    "mason",
                    "trouble",
                },
                callback = function()
                    vim.b.miniindentscope_disable = true
                end,
            })

            vim.api.nvim_create_autocmd("User", {
                pattern = "MiniFilesBufferCreate",
                callback = function(args)
                    local buf_id = args.data.buf_id
                    -- Tweak keys to your liking
                    map_split(buf_id, "<C-s>", "belowright horizontal")
                    map_split(buf_id, "<C-v>", "belowright vertical")
                    map_split(buf_id, "<C-t>", "tab")
                end,
            })

            -- Set focused directory as current working directory
            local set_cwd = function()
                local path = (MiniFiles.get_fs_entry() or {}).path
                if path == nil then return vim.notify('Cursor is not on valid entry') end
                vim.fn.chdir(vim.fs.dirname(path))
            end

            -- Yank in register full path of entry under cursor
            local yank_path = function()
                local path = (MiniFiles.get_fs_entry() or {}).path
                if path == nil then return vim.notify('Cursor is not on valid entry') end
                vim.fn.setreg(vim.v.register, path)
            end

            -- Open path with system default handler (useful for non-text files)
            local ui_open = function() vim.ui.open(MiniFiles.get_fs_entry().path) end

            vim.api.nvim_create_autocmd('User', {
                pattern = 'MiniFilesBufferCreate',
                callback = function(args)
                    local b = args.data.buf_id
                    vim.keymap.set('n', 'g~', set_cwd, { buffer = b, desc = 'Set cwd' })
                    vim.keymap.set('n', 'gX', ui_open, { buffer = b, desc = 'OS open' })
                    vim.keymap.set('n', 'gy', yank_path, { buffer = b, desc = 'Yank path' })
                end,
            })

            local set_mark = function(id, path, desc)
                MiniFiles.set_bookmark(id, path, { desc = desc })
            end
            vim.api.nvim_create_autocmd('User', {
                pattern = 'MiniFilesExplorerOpen',
                callback = function()
                    set_mark('c', vim.fn.stdpath('config'), 'Config') -- path
                    set_mark('w', vim.fn.getcwd, 'Working directory') -- callable
                    set_mark('~', '~', 'Home directory')
                end,
            })
            -- Custom MiniFileWindow
            vim.api.nvim_create_autocmd("User", {
                pattern = "MiniFilesWindowOpen",
                callback = function(args)
                    local win_id = args.data.win_id

                    -- Customize window-local settings
                    -- vim.wo[win_id].winblend = 50
                    local config = vim.api.nvim_win_get_config(win_id)
                    config.border, config.title_pos = "single", "center"
                    vim.api.nvim_win_set_config(win_id, config)
                end,
            })

            vim.api.nvim_create_autocmd("User", {
                pattern = "MiniFilesWindowUpdate",
                callback = function(args)
                    local config = vim.api.nvim_win_get_config(args.data.win_id)

                    -- Ensure fixed height
                    -- config.height = 10

                    -- Ensure no title padding
                    local n = #config.title
                    config.title[1][1] = config.title[1][1]:gsub("^ ", "")
                    config.title[n][1] = config.title[n][1]:gsub(" $", "")

                    vim.api.nvim_win_set_config(args.data.win_id, config)
                end,
            })

            -- keybinds
            require("mini.files").setup(files_config)
            vim.keymap.set("n", "<leader>e", function()
                if not MiniFiles.close() then
                    MiniFiles.open()
                end
            end, { desc = "Open MiniFiles" })
            vim.keymap.set("n", "<leader>ff", "<Cmd>Pick files<Enter>", { noremap = true, silent = true })
            vim.keymap.set("n", "<leader>,", "<Cmd>Pick buffers<Enter>", { noremap = true, silent = true })
            vim.keymap.set("n", "<leader>fh", "<Cmd>Pick help<Enter>", { noremap = true, silent = true })
            vim.keymap.set("n", "<leader>.", function()
                MiniExtra.pickers.oldfiles({ current_dir = false, preserve_order = false })
            end, { noremap = true, silent = true })
            vim.keymap.set("n", "<leader>/", function()
                MiniPick.builtin.grep_live()
            end, { noremap = true, silent = true })
            vim.keymap.set("n", "<leader>ss", function()
                MiniExtra.pickers.lsp({ scope = "document_symbol" })
            end, { noremap = true, silent = true })
            vim.keymap.set("n", "<leader>sS", function()
                MiniExtra.pickers.lsp({ scope = "workspace_symbol" })
            end, { noremap = true, silent = true })
            vim.keymap.set("n", "<leader>df", function()
                MiniExtra.pickers.lsp({ scope = "declaration" })
            end, { noremap = true, silent = true })
            vim.keymap.set("n", "<leader>sd", function()
                MiniExtra.pickers.diagnostic()
            end, { noremap = true, silent = true })
            vim.keymap.set("n", "<leader>sj", function()
                MiniExtra.pickers.list({ scope = "jump" })
            end, { noremap = true, silent = true })
            vim.keymap.set("n", "<leader>sk", function()
                MiniExtra.pickers.keymaps({ scope = "all" })
            end, { noremap = true, silent = true })
            vim.keymap.set("n", "<leader>sD", function()
                MiniExtra.pickers.diagnostic({ scope = "current" })
            end, { noremap = true, silent = true })
            vim.keymap.set("n", "<leader>td", function()
                MiniExtra.pickers.hipatterns({ scope = "all" })
            end, { noremap = true, silent = true })
            vim.keymap.set("n", "<leader>sH", function()
                MiniExtra.pickers.hl_groups()
            end, {
                noremap = true,
                silent = true,
                desc = "Search the hl_groups."
            })
        end,
    },
}
