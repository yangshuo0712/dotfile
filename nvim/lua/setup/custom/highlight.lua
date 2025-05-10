local M = {}
M.hl = {
    winbar = "WinBar",
    statusline = {
        normal = "StatusLine",
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
        hl(0, "CustomStatuslineError", { fg = "#ff5555", bg = "#333846", bold = false })
        hl(0, "CustomStatuslineWarning", { fg = "#f1fa8c", bg = "#333846", bold = false })
        hl(0, "CustomStatuslineHint", { fg = "#8be9fd", bg = "#333846", bold = false })
        hl(0, "CustomStatuslineInfo", { fg = "#50fa7b", bg = "#333846", bold = false })
        hl(0, "CustomWinbar", { fg = "#546178", bg ="NONE", bold = false })
    end
    vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "*",
        callback = set_highlight_groups
    })

    set_highlight_groups()

end

M.setup()

return M
