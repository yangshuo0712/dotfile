local function picker(name, opts)
    return function()
        Snacks.picker[name](opts)
    end
end

local telescope_layout = {
    reverse = true,
    layout = {
        box = "horizontal",
        backdrop = false,
        width = 0.8,
        height = 0.9,
        border = "none",
        {
            box = "vertical",
            { win = "list",  title = " Results ", title_pos = "center", border = true },
            { win = "input", height = 1,          border = true,        title = "{title} {live} {flags}", title_pos = "center" },
        },
        {
            win = "preview",
            title = "{preview:Preview}",
            width = 0.5,
            border = true,
            title_pos = "center",
        },
    },
}

return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,

    ---@type snacks.Config
    opts = {
        bigfile = { enabled = true },
        dashboard = { enabled = false },
        indent = { enabled = true },
        input = { enabled = true },
        notifier = { enabled = true },
        quickfile = { enabled = false },
        scope = { enabled = true },
        scroll = { enabled = false },
        image = {},
        words = { enabled = false },

        explorer = {
            enabled = false,
            replace_netrw = true,
        },

        statuscolumn = {
            enabled = true,
            folds = {
                open = true,
                git_hl = false,
            },
        },

        picker = {
            enabled = true,
            layout = "telescope",

            sources = {
                explorer = {
                    layout = {
                        layout = {
                            width = 0.25,
                        },
                    },
                },

                lsp_symbols = {
                    finder = "lsp_symbols",
                    format = "lsp_symbol",
                    tree = true,
                    filter = {
                        default = {"Class", "Constructor", "Enum", "Field", "Function", "Interface", "Method", "Module", "Namespace", "Package", "Property", "Struct", "Trait", "Variable",},
                        markdown = true,
                        help = true,
                        lua = {"Class", "Constructor", "Enum", "Field", "Function", "Interface", "Method", "Module", "Namespace", "Property", "Struct", "Trait",},
                    },
                },
            },

            layouts = {
                telescope = telescope_layout,
            },

            win = {
                input = {
                    keys = {
                        ["<C-y>"] = { "confirm", mode = { "n", "i" } },
                    },
                },
            },
        },

        win = {
            enabled = true,
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
        },
    },

    keys = {
        -- Top Pickers
        { "<leader>.",    picker("smart"),                                     desc = "Smart Find Files" },
        { "<leader>,",    picker("buffers"),                                   desc = "Buffers" },
        { "<leader>/",    picker("grep"),                                      desc = "Grep" },
        { "<leader>:",    picker("command_history"),                           desc = "Command History" },
        { "<leader>nn",   picker("notifications"),                             desc = "Notification History" },

        -- Find
        { "<leader>fb",   picker("buffers"),                                   desc = "Buffers" },
        { "<leader>fc",   picker("files", { cwd = vim.fn.stdpath("config") }), desc = "Find Config File" },
        { "<leader>fg",   picker("git_files"),                                 desc = "Find Git Files" },
        { "<leader>fp",   picker("projects"),                                  desc = "Projects" },
        { "<leader>fr",   picker("recent"),                                    desc = "Recent" },

        -- Git
        { "<leader>gb",   picker("git_branches"),                              desc = "Git Branches" },
        { "<leader>gl",   picker("git_log"),                                   desc = "Git Log" },
        { "<leader>gL",   picker("git_log_line"),                              desc = "Git Log Line" },
        { "<leader>gs",   picker("git_status"),                                desc = "Git Status" },
        { "<leader>gS",   picker("git_stash"),                                 desc = "Git Stash" },
        { "<leader>gd",   picker("git_diff"),                                  desc = "Git Diff (Hunks)" },
        { "<leader>gf",   picker("git_log_file"),                              desc = "Git Log File" },

        -- Grep / Search
        { "<leader>sb",   picker("lines"),                                     desc = "Buffer Lines" },
        { "<leader>sB",   picker("grep_buffers"),                              desc = "Grep Open Buffers" },
        { "<leader>sg",   picker("grep"),                                      desc = "Grep" },
        { "<leader>sw",   picker("grep_word"),                                 mode = { "n", "x" },            desc = "Visual selection or word" },

        { [[<leader>s"]], picker("registers"),                                 desc = "Registers" },
        { "<leader>s/",   picker("search_history"),                            desc = "Search History" },
        { "<leader>sa",   picker("autocmds"),                                  desc = "Autocmds" },
        { "<leader>sc",   picker("command_history"),                           desc = "Command History" },
        { "<leader>sC",   picker("commands"),                                  desc = "Commands" },
        { "<leader>sd",   picker("diagnostics"),                               desc = "Diagnostics" },
        { "<leader>sD",   picker("diagnostics_buffer"),                        desc = "Buffer Diagnostics" },
        { "<leader>fh",   picker("help"),                                      desc = "Help Pages" },
        { "<leader>sH",   picker("highlights"),                                desc = "Highlights" },
        { "<leader>si",   picker("icons"),                                     desc = "Icons" },
        { "<leader>sj",   picker("jumps"),                                     desc = "Jumps" },
        { "<leader>sk",   picker("keymaps"),                                   desc = "Keymaps" },
        { "<leader>sl",   picker("loclist"),                                   desc = "Location List" },
        { "<leader>sm",   picker("marks"),                                     desc = "Marks" },
        { "<leader>sM",   picker("man"),                                       desc = "Man Pages" },
        { "<leader>sp",   picker("lazy"),                                      desc = "Search for Plugin Spec" },
        { "<leader>sq",   picker("qflist"),                                    desc = "Quickfix List" },
        { "<leader>sR",   picker("resume"),                                    desc = "Resume" },
        { "<leader>su",   picker("undo"),                                      desc = "Undo History" },
        { "<leader>uC",   picker("colorschemes"),                              desc = "Colorschemes" },

        -- LSP
        { "gd",           picker("lsp_definitions"),                           desc = "Goto Definition" },
        { "gD",           picker("lsp_declarations"),                          desc = "Goto Declaration" },
        { "gr",           picker("lsp_references"),                            nowait = true,                  desc = "References" },
        { "gI",           picker("lsp_implementations"),                       desc = "Goto Implementation" },
        { "gy",           picker("lsp_type_definitions"),                      desc = "Goto Type Definition" },
        { "<leader>ss",   picker("lsp_symbols"),                               desc = "LSP Symbols" },
        { "<leader>sS",   picker("lsp_workspace_symbols"),                     desc = "LSP Workspace Symbols" },
    },
}
