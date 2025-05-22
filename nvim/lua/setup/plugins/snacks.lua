return
{
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
---@diagnostic disable-next-line: undefined-doc-name
    ---@type snacks.Config
    opts = {
        bigfile = { enabled = true },
        dashboard = { enabled = false },
        indent = { enabled = true },
        input = { enabled = true },
        notifier = { enabled = true, },
        quickfile = { enabled = false },
        scope = { enabled = true },
        scroll = { enabled = true },
        statuscolumn = { enabled = true },
        words = { enabled = true },
        explorer = {
            enabled = false,
            replace_netrw = true,
        },
        picker = {
            enabled = true,
            sources = {
                explorer = {
                    layout = {
                        layout = {
                            width = 0.25
                        },
                    },
                },
                lsp_symbols = {
                    finder = "lsp_symbols",
                    format = "lsp_symbol",
                    tree = true,
                    filter = {
                        default = {
                            "Class",
                            "Constructor",
                            "Enum",
                            "Field",
                            "Function",
                            "Interface",
                            "Method",
                            "Module",
                            "Namespace",
                            "Package",
                            "Property",
                            "Struct",
                            "Trait",
                            "Variable",
                        },
                        -- set to `true` to include all symbols
                        markdown = true,
                        help = true,
                        -- you can specify a different filter for each filetype
                        lua = {
                            "Class",
                            "Constructor",
                            "Enum",
                            "Field",
                            "Function",
                            "Interface",
                            "Method",
                            "Module",
                            "Namespace",
                            -- "Package", -- remove package since luals uses it for control flow structures
                            "Property",
                            "Struct",
                            "Trait",
                        },
                    },
                }
            },
            layouts = {
                telescope = {
                    reverse = true,
                    layout = {
                        -- can be 'vertical' or 'horizontal'
                        box = "horizontal",
                        backdrop = false,
                        width = 0.75,
                        height = 0.8,
                        -- control the outest border
                        border = "none",
                        {
                            box = "vertical",
                            {
                                win = "list",
                                title = " Results ",
                                title_pos = "center",
                                border = "rounded"
                            },
                            {
                                win = "input",
                                height = 1,
                                border = "rounded",
                                title = "{title} {live} {flags}",
                                title_pos = "center"
                            },
                        },
                        {
                            win = "preview",
                            title = "{preview:Preview}",
                            -- width = 0.45,
                            border = "rounded",
                            title_pos = "center",
                        },
                    },
                },

            },
            layout = "telescope",
            win = {
                input = {
                    keys = {
                        ["<C-y>"] = { "confirm", mode = { 'n', 'i' } }
                    }
                }
            }
        },
        win = {
            enable = true,
            wo = {
                cursorcolumn = false,
                cursorline = false,
                cursorlineopt = "both",
                colorcolumn = "",
                fillchars = "eob: ,lastline:…",
                list = false,
                listchars = "extends:…,tab:  ",
                number = false,
                relativenumber = false,
                signcolumn = "no",
                spell = false,
                winbar = "",
                statuscolumn = "",
                wrap = false,
                sidescrolloff = 0,
            },
        }
    },
    keys = {
        -- Top Pickers & Explorer
        { "<leader>.",  function() Snacks.picker.smart() end,                                   desc = "Smart Find Files" },
        { "<leader>,",  function() Snacks.picker.buffers() end,                                 desc = "Buffers" },
        { "<leader>/",  function() Snacks.picker.grep() end,                                    desc = "Grep" },
        { "<leader>:",  function() Snacks.picker.command_history() end,                         desc = "Command History" },
        { "<leader>nn", function() Snacks.picker.notifications() end,                           desc = "Notification History" },
        -- { "<leader>e",       function() Snacks.explorer() end,                                       desc = "File Explorer" },
        -- find
        { "<leader>fb", function() Snacks.picker.buffers() end,                                 desc = "Buffers" },
        { "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
        { "<leader>ff", function() Snacks.picker.files() end,                                   desc = "Find Files" },
        { "<leader>fg", function() Snacks.picker.git_files() end,                               desc = "Find Git Files" },
        { "<leader>fp", function() Snacks.picker.projects() end,                                desc = "Projects" },
        { "<leader>fr", function() Snacks.picker.recent() end,                                  desc = "Recent" },
        -- git
        { "<leader>gb", function() Snacks.picker.git_branches() end,                            desc = "Git Branches" },
        { "<leader>gl", function() Snacks.picker.git_log() end,                                 desc = "Git Log" },
        { "<leader>gL", function() Snacks.picker.git_log_line() end,                            desc = "Git Log Line" },
        { "<leader>gs", function() Snacks.picker.git_status() end,                              desc = "Git Status" },
        { "<leader>gS", function() Snacks.picker.git_stash() end,                               desc = "Git Stash" },
        { "<leader>gd", function() Snacks.picker.git_diff() end,                                desc = "Git Diff (Hunks)" },
        { "<leader>gf", function() Snacks.picker.git_log_file() end,                            desc = "Git Log File" },
        -- Grep
        { "<leader>sb", function() Snacks.picker.lines() end,                                   desc = "Buffer Lines" },
        { "<leader>sB", function() Snacks.picker.grep_buffers() end,                            desc = "Grep Open Buffers" },
        { "<leader>sg", function() Snacks.picker.grep() end,                                    desc = "Grep" },
        { "<leader>sw", function() Snacks.picker.grep_word() end,                               desc = "Visual selection or word", mode = { "n", "x" } },
        -- search
        { '<leader>s"', function() Snacks.picker.registers() end,                               desc = "Registers" },
        { '<leader>s/', function() Snacks.picker.search_history() end,                          desc = "Search History" },
        { "<leader>sa", function() Snacks.picker.autocmds() end,                                desc = "Autocmds" },
        { "<leader>sb", function() Snacks.picker.lines() end,                                   desc = "Buffer Lines" },
        { "<leader>sc", function() Snacks.picker.command_history() end,                         desc = "Command History" },
        { "<leader>sC", function() Snacks.picker.commands() end,                                desc = "Commands" },
        { "<leader>sd", function() Snacks.picker.diagnostics() end,                             desc = "Diagnostics" },
        { "<leader>sD", function() Snacks.picker.diagnostics_buffer() end,                      desc = "Buffer Diagnostics" },
        { "<leader>fh", function() Snacks.picker.help() end,                                    desc = "Help Pages" },
        { "<leader>sH", function() Snacks.picker.highlights() end,                              desc = "Highlights" },
        { "<leader>si", function() Snacks.picker.icons() end,                                   desc = "Icons" },
        { "<leader>sj", function() Snacks.picker.jumps() end,                                   desc = "Jumps" },
        { "<leader>sk", function() Snacks.picker.keymaps() end,                                 desc = "Keymaps" },
        { "<leader>sl", function() Snacks.picker.loclist() end,                                 desc = "Location List" },
        { "<leader>sm", function() Snacks.picker.marks() end,                                   desc = "Marks" },
        { "<leader>sM", function() Snacks.picker.man() end,                                     desc = "Man Pages" },
        { "<leader>sp", function() Snacks.picker.lazy() end,                                    desc = "Search for Plugin Spec" },
        { "<leader>sq", function() Snacks.picker.qflist() end,                                  desc = "Quickfix List" },
        { "<leader>sR", function() Snacks.picker.resume() end,                                  desc = "Resume" },
        { "<leader>su", function() Snacks.picker.undo() end,                                    desc = "Undo History" },
        { "<leader>uC", function() Snacks.picker.colorschemes() end,                            desc = "Colorschemes" },
        -- LSP
        { "gd",         function() Snacks.picker.lsp_definitions() end,                         desc = "Goto Definition" },
        { "gD",         function() Snacks.picker.lsp_declarations() end,                        desc = "Goto Declaration" },
        { "gr",         function() Snacks.picker.lsp_references() end,                          nowait = true,                     desc = "References" },
        { "gI",         function() Snacks.picker.lsp_implementations() end,                     desc = "Goto Implementation" },
        { "gy",         function() Snacks.picker.lsp_type_definitions() end,                    desc = "Goto T[y]pe Definition" },
        { "<leader>ss", function() Snacks.picker.lsp_symbols() end,                             desc = "LSP Symbols" },
        { "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end,                   desc = "LSP Workspace Symbols" },
    },
}
