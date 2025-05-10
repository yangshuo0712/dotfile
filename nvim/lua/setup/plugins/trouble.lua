return {
    "folke/trouble.nvim",
    opts = {
        auto_close = true,
        modes = {
            symbols = {
                desc = "document symbols",
                mode = "lsp_document_symbols",
                focus = false,
                win = {
                    type = "split",
                    relative = "win",
                    position = "right",
                    size = 0.3,
                },
            },
            diagnostics = {
                desc = "diagnostics",
                win = {
                    type = "split",
                    relative = "win",
                    position = "bottom",
                    size = 0.5,
                }
            }
        },
        keys = {
            ["<C-y>"] = "jump",
        }
    },
    cmd = "Trouble",
    keys = {
        {
            "<leader>xX",
            "<cmd>Trouble diagnostics toggle<cr>",
            desc = "Diagnostics (Trouble)",
        },
        {
            "<leader>xx",
            "<cmd>Trouble diagnostics filter.buf=0<cr>",
            desc = "Buffer Diagnostics (Trouble)",
        },
        {
            "<leader>cs",
            "<cmd>Trouble symbols toggle focus=true<cr>",
            desc = "Symbols (Trouble)",
        },
        {
            "<leader>cl",
            "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
            desc = "LSP Definitions / references / ... (Trouble)",
        },
        {
            "<leader>xL",
            "<cmd>Trouble loclist toggle<cr>",
            desc = "Location List (Trouble)",
        },
        {
            "<leader>xQ",
            "<cmd>Trouble qflist toggle<cr>",
            desc = "Quickfix List (Trouble)",
        },
    },
}
