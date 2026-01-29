local M = {}

local path = require("setup.custom.utils.path")

-- =========================
-- Highlight groups
-- =========================
local custom_hl = {
    statusline = {
        normal = "CustomStatusLineNormal",
        diagnostics = {
            errors   = "CustomStatusLineError",
            warnings = "CustomStatusLineWarning",
            hints    = "CustomStatusLineHint",
            infos    = "CustomStatusLineInfo",
            normal   = "CustomStatusLineNormal",
        },
    },
}

-- =========================
-- Mode map
-- =========================
local modes = {
    ["n"]  = "NORMAL",
    ["i"]  = "INSERT",
    ["v"]  = "VISUAL",
    ["V"]  = "V-LINE",
    [""] = "V-BLOCK",
    ["c"]  = "COMMAND",
    ["R"]  = "REPLACE",
    ["s"]  = "SELECT",
    ["S"]  = "S-LINE",
    [""] = "S-BLOCK",
    ["t"]  = "TERMINAL",
}

-- =========================
-- Icon highlight cache
-- =========================
local icon_hl_cache = {}

local function safe_get_hl(name)
    local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = name, link = false })
    if not ok then
        return {}
    end
    return hl or {}
end

local function statusline_bg()
    -- Prefer your own statusline group background if it has one;
    -- fallback to built-in StatusLine bg; final fallback: none (transparent).
    local my = safe_get_hl(custom_hl.statusline.normal)
    if my.bg ~= nil then
        return my.bg
    end
    local st = safe_get_hl("StatusLine")
    if st.bg ~= nil then
        return st.bg
    end
    return nil
end

local function ensure_icon_hl(base_hl)
    -- Create a derived highlight group that:
    -- - keeps the icon fg (from MiniIcons group)
    -- - forces bg to match statusline bg
    if not base_hl or base_hl == "" then
        base_hl = custom_hl.statusline.normal
    end

    local cached = icon_hl_cache[base_hl]
    if cached and vim.fn.hlexists(cached) == 1 then
        return cached
    end

    -- Use a deterministic name; sanitize a bit just in case
    local derived = ("CustomStatusLineIcon_%s"):format(base_hl:gsub("[^%w_]", "_"))

    local base = safe_get_hl(base_hl)
    local bg = statusline_bg()

    -- Only set what we need: fg from base, bg from statusline
    -- If base has no fg, we won't force fg (fallback to default).
    vim.api.nvim_set_hl(0, derived, {
        fg = base.fg,
        bg = bg,
        bold = base.bold,
        italic = base.italic,
        underline = base.underline,
        undercurl = base.undercurl,
        reverse = base.reverse,
        strikethrough = base.strikethrough,
    })

    icon_hl_cache[base_hl] = derived
    return derived
end

function M.refresh_highlights()
    -- Clear cache so highlights get rebuilt after ColorScheme/theme change
    icon_hl_cache = {}
end

-- =========================
-- Mode indicator
-- =========================
---@diagnostic disable-next-line: unused-local
local function get_mode(hl_group)
    local mode = vim.fn.mode()
    return string.format("%%#%s# %s ", hl_group, modes[mode] or mode)
end

-- =========================
-- Filetype + icon
-- =========================
local function ft_with_icon()
    local ext = vim.bo.filetype
    if ext == "" then
        return ""
    end

    ---@diagnostic disable-next-line: undefined-global
    local icon, hl, _ = MiniIcons.get("filetype", ext)

    local base_icon_hl = (hl and hl ~= "") and hl or custom_hl.statusline.normal
    local icon_hl = ensure_icon_hl(base_icon_hl)

    return string.format(
        "%%#%s#%s %%#%s#%s",
        icon_hl,
        icon or "",
        custom_hl.statusline.normal,
        ext
    )
end

-- =========================
-- LSP client name
-- =========================
local function lsp_client()
    local buf_ft  = vim.api.nvim_get_option_value("filetype", { buf = 0 })
    local clients = vim.lsp.get_clients()

    if next(clients) == nil then
        return ""
    end

    for _, client in ipairs(clients) do
        ---@diagnostic disable-next-line: undefined-field
        local filetypes = client.config.filetypes
        if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
            return client.name
        end
    end

    return ""
end

-- =========================
-- Diagnostics summary
-- =========================
local function diagnostics(hl_groups)
    local errors   = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
    local warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })

    if errors ~= 0 or warnings ~= 0 then
        return string.format(
            "%%#%s# %d %%#%s# %d %%#%s#",
            hl_groups.normal,
            errors,
            hl_groups.normal,
            warnings,
            custom_hl.statusline.normal
        )
    end

    return ""
end

-- =========================
-- Search count
-- =========================
---@diagnostic disable-next-line: unused-local
local function search_count()
    if vim.v.hlsearch == 0 then
        return ""
    end

    local sc = vim.fn.searchcount({ maxcount = 999, timeout = 500 })

    if sc.total > 0 then
        local current = sc.current > 0 and sc.current or 1
        return string.format(" 󰍉 %s/%d ", current, sc.total)
    end

    return ""
end

-- =========================
-- Cursor position
-- =========================
local function cursor_position(hl_group)
    local total_lines  = vim.fn.line("$")
    local current_line = vim.fn.line(".")

    if total_lines == 0 then
        return " All "
    elseif current_line == 1 then
        return " Top "
    elseif current_line == total_lines then
        return " Bot "
    else
        local percent = math.floor((current_line / total_lines) * 100)
        return string.format(" %%#%s#%2d%%%% ", hl_group, percent)
    end
end

-- =========================
-- Statusline render
-- =========================
-- M.render = function()
--     return table.concat({
--         get_mode(custom_hl.statusline.normal),
--         "    ",
--         path.pretty_path({ max_depth = 4, cwd_indicator = "" }),
--         " %m %r %h %w ",
--         diagnostics(custom_hl.statusline.diagnostics),
--         "%= ",
--         lsp_client(),
--         "    ",
--         -- search_count(),
--         ft_with_icon(),
--         "    ",
--         " %l,%c",
--         "    ",
--         cursor_position(custom_hl.statusline.normal),
--         "%#" .. custom_hl.statusline.normal .. "#",
--     })
-- end
M.render = function()
  local N = custom_hl.statusline.normal
  return table.concat({
    ("%#" .. N .. "#"),
    -- "    ",
    path.pretty_path({ max_depth = 4, cwd_indicator = "" }),
    " %m %r %h %w ",
    diagnostics(custom_hl.statusline.diagnostics),
    "%= ",
    lsp_client(),
    "    ",
    ft_with_icon(),
    "    ",
    " %l,%c",
    "    ",
    cursor_position(N),
    "%#" .. N .. "#",
  })
end
-- =========================
-- Setup
-- =========================
M.setup = function()
    vim.o.statusline = "%!v:lua.require'setup.custom.statusline'.render()"

    -- Rebuild derived icon highlight groups whenever colorscheme changes
    local aug = vim.api.nvim_create_augroup("CustomStatuslineIconHL", { clear = true })
    vim.api.nvim_create_autocmd("ColorScheme", {
        group = aug,
        callback = function()
            M.refresh_highlights()
        end,
    })
end

return M
