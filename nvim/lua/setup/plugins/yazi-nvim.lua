return
---@diagnostic disable-next-line: undefined-doc-name
---@type LazySpec
{
    "mikavilpas/yazi.nvim",
    event = "VeryLazy",
    keys = {
        {
            "<leader>-",
            mode = { "n", "v" },
            "<cmd>Yazi<cr>",
            desc = "Open yazi at the current file",
        },
        {
            -- Open in the current working directory
            "<leader>cw",
            "<cmd>Yazi cwd<cr>",
            desc = "Open the file manager in nvim's working directory",
        },
        {
            "<c-up>",
            "<cmd>Yazi toggle<cr>",
            desc = "Resume the last yazi session",
        },
    },
---@diagnostic disable-next-line: undefined-doc-name
    ---@type YaziConfig | {}
    opts = {
        -- if you want to open yazi instead of netrw, see below for more info
        open_for_directories = false,
        floating_window_scaling_factor = 0.9,
        yazi_floating_window_winblend = 0,
        yazi_floating_window_border = "rounded",
        highlight_groups = {
            -- See https://github.com/mikavilpas/yazi.nvim/pull/180
            hovered_buffer = nil,
            -- See https://github.com/mikavilpas/yazi.nvim/pull/351
            hovered_buffer_in_same_directory = nil,
        },
        highlight_hovered_buffers_in_same_directory = false,
        keymaps = {
            show_help = "<f1>",
        },
    },
}
