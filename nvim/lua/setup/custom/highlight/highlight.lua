local M = {}

local palette = require("setup.custom.utils.palette")

local function safe_get_hl(name)
    local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = name, link = false })
    if not ok then
        return {}
    end
    return hl or {}
end

local function get_statusline_bg()
    -- Get background from StatusLine highlight group (follows theme)
    local st = safe_get_hl("StatusLine")
    return st.bg
end

local function get_statusline_fg()
    -- Get foreground from StatusLine highlight group (follows theme)
    local st = safe_get_hl("StatusLine")
    return st.fg
end

local function set_common_highlights(p)
    local hl = vim.api.nvim_set_hl

    -- Background follows theme
    local bg = p.statusline.normal_bg or get_statusline_bg()
    local fg = p.statusline.normal_fg or get_statusline_fg()

    -- Diagnostic highlights: use Nord-compatible colors, bg follows theme
    hl(0, "CustomStatusLineError", { fg = p.statusline.error, bg = bg })
    hl(0, "CustomStatusLineWarning", { fg = p.statusline.warn, bg = bg })
    hl(0, "CustomStatusLineHint", { fg = p.statusline.hint, bg = bg })
    hl(0, "CustomStatusLineInfo", { fg = p.statusline.info, bg = bg })

    -- Main statusline highlight: fg/bg follow theme unless overridden
    hl(0, "CustomStatusLineNormal", { fg = fg, bg = bg })

    -- Winbar: transparent background, optional fg override
    local winbar_fg = p.statusline.fg_winbar or safe_get_hl("Comment").fg
    hl(0, "CustomWinbar", { fg = winbar_fg, bg = "NONE" })
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
