local M = {}
local custom_hl = require 'setup.custom.highlight'.hl
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

local function get_mode(hl_group)
    local mode = vim.fn.mode()
    return string.format("%%#%s# %s ", hl_group, modes[mode] or mode)
end

local function lsp_client()
    local msg = ''
    local buf_ft = vim.api.nvim_get_option_value('filetype', { buf = 0 })
    local clients = vim.lsp.get_clients()
    if next(clients) == nil then
        return msg
    end
    for _, client in ipairs(clients) do
        local filetypes = client.config.filetypes
        if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
            return client.name
        end
    end
    return msg
end

local function diagnostics(hl_groups)
    local errors   = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
    local warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
    -- local hints    = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
    -- local info     = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })

     local diag_str = string.format("%%#%s# %s%%#%s#  %s",
     hl_groups.errors,
     errors,
     hl_groups.warnings,
     warnings)

    return diag_str
end

local function search_count()
    if vim.v.hlsearch == 0 then
        return ""
    end
    local sc = vim.fn.searchcount({ maxcount = 999, timeout = 500 })
    if sc.total > 0 and sc.current > 0 then
        return string.format(" 󰍉 %d/%d ", sc.current, sc.total)
    end
    return ""
end

M.render = function()
    return table.concat({
        get_mode(custom_hl.statusline.normal),
        diagnostics(custom_hl.statusline.diagnostics),
        " %t %m %r %h %w %= ",
        search_count(),
        lsp_client(),
        " %l,%c %p%% ",
    })
end

M.setup = function ()
    vim.o.statusline = "%!v:lua.require'setup.custom.statusline'.render()"
end

M.setup()

return M
