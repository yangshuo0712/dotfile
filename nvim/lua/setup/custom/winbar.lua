local M = {}
local custom_hl = require 'setup.custom.highlight'.hl
local function format_path_with_icons(bufname, hl_group, separator)
    local parts = vim.split(bufname, "/", { trimempty = true })
    local formatted_parts = {}

    for i, part in ipairs(parts) do
        if i == #parts then
            local icon, hl, _ = MiniIcons.get('file', part)
            table.insert(formatted_parts, string.format("%%#%s# %s%%#%s# %s", hl, icon, hl_group, part))
        else
            table.insert(formatted_parts, string.format("%%#%s# %s", hl_group, part))
        end
    end
    return table.concat(formatted_parts, separator)
end
function M.render()
    local bufnr = vim.api.nvim_get_current_buf()
    local bufname = vim.api.nvim_buf_get_name(bufnr)
    local formatted = nil

    if vim.bo[bufnr].buftype ~= "" then
        if bufname:match("CodeCompanion") then
            vim.wo.winbar = " CodeCompanion"
        elseif bufname:match("toggleterm") then
            vim.wo.winbar = " Terminal"
        end
        return
    end
    if bufname == "" then
        bufname = "[No Name]"
    else
        bufname = vim.fn.fnamemodify(bufname, ":.")
        formatted = format_path_with_icons(bufname, custom_hl.winbar, " ›")--
    end
    vim.wo.winbar = formatted
end

local augroup = vim.api.nvim_create_augroup('winbar.nvim', { clear = true })
M.setup = function()
    vim.api.nvim_create_autocmd({
        "BufEnter",
        "BufFilePost",
    }, {
        group = augroup,
        callback = function()
            M.render()
        end,
    })
end

M.setup()

return M
