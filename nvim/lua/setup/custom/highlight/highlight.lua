local M = {}

local palette = require("setup.custom.utils.palette")

local function set_common_highlights(p)
    local hl = vim.api.nvim_set_hl
    local b = p.base
    hl(0, "CustomStatusLineError", { fg = b.error })
    hl(0, "CustomStatusLineWarning", { fg = b.warn })
    hl(0, "CustomStatusLineHint", { fg = b.hint, bg = b.bg_dark })
    hl(0, "CustomStatusLineInfo", { fg = b.info, bg = b.bg_dark })
    hl(0, "CustomStatusLineNormal", { fg = b.normal, bg = b.bg_line })
    hl(0, "CustomWinbar", { fg = b.fg_winbar, bg = "NONE" })
end

local function set_theme_overrides()
    local hl = vim.api.nvim_set_hl
    local theme = vim.g.colors_name or ""

    hl(0, "SnacksPicker", { bg = "none", nocombine = true })
    hl(0, "WinSeparator", { fg = "#43445E", bg = "none", nocombine = true })
    vim.cmd([[highlight! link WinBar Normal]])
    vim.cmd([[highlight! link WinBarNC Normal]])
    vim.cmd([[highlight! link TroubleNormal Normal]])
    vim.cmd([[highlight! link TroubleNormalNC Normal]])
    vim.cmd([[highlight! link LspInlayHint Comment]])

end

function M.setup()
    local group = vim.api.nvim_create_augroup("CustomHighlights", { clear = true })

    vim.api.nvim_create_autocmd("ColorScheme", {
        group = group,
        callback = function()
            set_common_highlights(palette)
            set_theme_overrides()
        end,
    })

    set_common_highlights(palette)
    set_theme_overrides()
end

return M
