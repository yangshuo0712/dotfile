local M = {}
local custom_hl = require 'setup.custom.highlight'.hl
local modes = {
    ["n"] = "NORMAL",
    ["i"] = "INSERT",
    ["v"] = "VISUAL",
    ["V"] = "V-LINE",
    [""] = "V-BLOCK",
    ["c"] = "COMMAND",
    ["R"] = "REPLACE",
    ["s"] = "SELECT",
    ["S"] = "S-LINE",
    [""] = "S-BLOCK",
    ["t"] = "TERMINAL",
}

---@diagnostic disable-next-line: unused-local
local function get_mode(hl_group)
    local mode = vim.fn.mode()
    return string.format("%%#%s# %s ", hl_group, modes[mode] or mode)
end

---@diagnostic disable-next-line: unused-local
local function get_short_path(max_depth)
    max_depth = max_depth or 3

    local filepath = vim.fn.expand("%:.")
    if filepath == "" then return "[No Name]" end

    local parts = {}
    for part in string.gmatch(filepath, "[^/]+") do
        table.insert(parts, part)
    end

    local len = #parts
    if len <= max_depth then
        return filepath
    else
        local tail_parts = {}
        for i = len - max_depth + 1, len do
            table.insert(tail_parts, parts[i])
        end
        return "…/" .. table.concat(tail_parts, "/")
    end
end

---@diagnostic disable-next-line: unused-function
local function get_highlighted_relative_path(max_depth)
    max_depth = max_depth or 3

    local relpath = vim.fn.expand("%:.")
    if relpath == "" then
        return "%#Comment#[No Name]%*"
    end

    local parts = {}
    for part in string.gmatch(relpath, "[^/]+") do
        table.insert(parts, part)
    end

    local len = #parts
    local shown_parts = {}

    local prefix = ""
    if len > max_depth then
        prefix = "…/"
        for i = len - max_depth + 1, len - 1 do
            table.insert(shown_parts, parts[i])
        end
    else
        for i = 1, len - 1 do
            table.insert(shown_parts, parts[i])
        end
    end

    local last = parts[len]

    local comment_part = prefix .. table.concat(shown_parts, "/")
    if comment_part ~= "" then
        comment_part = comment_part .. "/"
    end

    return string.format("%%#Comment#%s%%#StatusLine#%s%%*", comment_part, last)
end

local function lsp_client()
    local msg = ''
    local buf_ft = vim.api.nvim_get_option_value('filetype', { buf = 0 })
    local clients = vim.lsp.get_clients()
    if next(clients) == nil then
        return msg
    end
    for _, client in ipairs(clients) do
---@diagnostic disable-next-line: undefined-field
        local filetypes = client.config.filetypes
        if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
            return client.name
        end
    end
    return msg
end

local function diagnostics(hl_groups)
    local diag_str = ""
    local errors   = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
    local warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
    -- local hints    = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
    -- local info     = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })

    if errors ~= 0 or warnings ~= 0 then
        diag_str = string.format("%%#%s# %s%%#%s#  %s",
            hl_groups.errors,
            errors,
            hl_groups.warnings,
            warnings)
    end

    return diag_str
end

---@diagnostic disable-next-line: unused-local
local function search_count()
    if vim.v.hlsearch == 0 then
        return ""
    end

    local sc = vim.fn.searchcount({ maxcount = 999, timeout = 500 })

    if sc.total > 0 then
        local current = sc.current > 0 and sc.current or "1"
        return string.format(" 󰍉 %s/%d ", current, sc.total)
    end

    return ""
end

local function cursor_position(hl_groups)
    local total_lines = vim.fn.line("$")
    local current_line = vim.fn.line(".")
    if total_lines == 0 then
        return " All "
    elseif current_line == 1 then
        return " Top "
    elseif current_line == total_lines then
        return " Bot "
    else
        local percent = math.floor((current_line / total_lines) * 100)
        return string.format(" %%#%s#%2d%%%% ", hl_groups, percent)
    end
end

M.render = function()
    return table.concat({
        get_mode(custom_hl.statusline.normal),
        "    ",
        get_short_path(4),
        " %m %r %h %w ",
        "%= ",
        search_count(),
        "    ",
        diagnostics(custom_hl.statusline.diagnostics),
        "    ",
        -- search_count(),
        lsp_client(),
        "    ",
        " %l,%c",
        "    ",
        cursor_position(custom_hl.statusline.normal),
    })
end

M.setup = function()
    vim.o.statusline = "%!v:lua.require'setup.custom.statusline'.render()"
end

M.setup()

return M
