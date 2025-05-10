local M = {}
M.hl = {
    winbar = "WinBar",
    statusline = {
        normal = "CustomStatusLineNormal",
        diagnostics = {
            errors = "StatusLine",
            warnings = "StatusLine",
            hints = "StatusLine",
            info = "StatusLine"},
        }
    }
function M.setup()
    local function set_highlight_groups()
        local hl = vim.api.nvim_set_hl
        hl(0, "CustomStatusLineError", { fg = "#ff5555", bg = "#333846", bold = false })
        hl(0, "CustomStatusLineWarning", { fg = "#f1fa8c", bg = "#333846", bold = false })
        hl(0, "CustomStatusLineHint", { fg = "#8be9fd", bg = "#333846", bold = false })
        hl(0, "CustomStatusLineInfo", { fg = "#50fa7b", bg = "#333846", bold = false })
        hl(0, "CustomWinbar", { fg = "#546178", bg ="NONE", bold = false })
        hl(0, "CustomStatusLineNormal", { fg = "#d8dee9", bg ="#434c5e", bold = true })
    end
    vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "*",
        callback = set_highlight_groups
    })

    set_highlight_groups()

end

M.setup()

return M
