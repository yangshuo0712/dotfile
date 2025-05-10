local M = {}
local icons = require 'setup.custom.icons'.lsp_icons
local custom_hl = require 'setup.custom.highlight'.hl
local cached_symbols = {}
local last_context = {}
local debounce_update_symbols_timers = {}
local DEBOUNCE_UPDATE_SYMBOLS_DELAY = 200 --ms
local debounce_update_context_timers = {}
local DEBOUNCE_UPDATE_CONTEXT_DELAY = 200 --ms
local fileexclude = { "NvimTree", "help", "dashboard", "packer", "lazy" }
local valid_kinds = { [5] = true, [6] = true, [12] = true }
local kind_map = { [5] = icons.class, [6] = icons.method, [12] = icons.Function }

-- 判断是否需要排除当前 buffer
local function should_exclude(bufnr)
    local ft = vim.bo.filetype
    if ft == "" then
        return ""
    end
    local bufname = vim.api.nvim_buf_get_name(bufnr)
    for _, pattern in ipairs(fileexclude) do
        if bufname:match(pattern) then
            return true
        end
    end
    return false
end
--------------------------------------------------------------------------------
-- 遍历符号树，获取包含当前行的所有有效符号（类、方法、函数）
local function traverse_symbols(symbols, line, chain)
    for _, sym in ipairs(symbols) do
        local range = sym.range or (sym.location and sym.location.range)
        if range and range.start and range["end"] then
            if line >= range.start.line and line <= range["end"].line then
                if valid_kinds[sym.kind] then
                    local icon_hl = kind_map[sym.kind] or { "", "" }
                    table.insert(chain, string.format("%%#%s#%s%%#%s#%s",
                        icon_hl.hl,
                        icon_hl.glyph,
                        custom_hl.winbar,
                        sym.name)
                    )
                end
                if sym.children then
                    traverse_symbols(sym.children, line, chain)
                end
                break -- 只保留第一个匹配的分支
            end
        end
    end
    return chain
end
--------------------------------------------------------------------------------
-- 更新当前 buffer 的符号缓存（异步请求 LSP）
local function update_buffer_symbols(bufnr)
    bufnr = bufnr or vim.api.nvim_get_current_buf()
    if should_exclude(bufnr) then
        return
    end
    local params = { textDocument = vim.lsp.util.make_text_document_params() }
    vim.lsp.buf_request(bufnr, "textDocument/documentSymbol", params, function(err, result)
        if err or not result then
            return
        end
        cached_symbols[bufnr] = result
    end)
end
--------------------------------------------------------------------------------
-- 初始化当前 buffer 的符号缓存（仅在 LspAttach 后执行）
function M.init_buffer_symbols()
    local bufnr = vim.api.nvim_get_current_buf()
    if should_exclude(bufnr) then
        return
    end
    -- 初始化时请求一次符号
    update_buffer_symbols(bufnr)
end

local function debounce_update_buffer_symbols(bufnr)
    if debounce_update_symbols_timers[bufnr] then
        debounce_update_symbols_timers[bufnr]:stop()
        debounce_update_symbols_timers[bufnr]:close()
    end
    debounce_update_symbols_timers[bufnr] = vim.loop.new_timer()
    debounce_update_symbols_timers[bufnr]:start(DEBOUNCE_UPDATE_SYMBOLS_DELAY, 0, vim.schedule_wrap(function()
        update_buffer_symbols(bufnr)
    end))
end
--------------------------------------------------------------------------------
-- 根据当前光标位置获取结构化符号链
-- 返回类似 "Class > method > func" 的字符串，以及与上次上下文对比后是否需要重绘（need_redraw）
local function update_context_at_cursor(bufnr)
    if should_exclude(bufnr) then
        return "", false
    end
    local pos = vim.api.nvim_win_get_cursor(0)
    local line = pos[1] - 1 -- 行号从 0 开始
    local symbols = cached_symbols[bufnr]
    if not symbols then
        return "", false
    end
    local chain = traverse_symbols(symbols, line, {})
    local context = table.concat(chain, " > ")
    local need_redraw = (last_context[bufnr] ~= context)
    -- if context == "" then
    --     last_context[bufnr] = {context, need_redraw}
    -- end
    -- last_context[bufnr] = {" > " .. context, need_redraw}
    if need_redraw then
        last_context[bufnr] = context
        local formatted = require 'setup.custom.winbar'.get_formatted()
        if context == "" then
            vim.wo.winbar = formatted
        else
            vim.wo.winbar = formatted .. " > " .. context
        end
    end
end

local function debounce_update_cursor_context(bufnr)
    if debounce_update_context_timers[bufnr] then
        debounce_update_context_timers[bufnr]:stop()
        debounce_update_context_timers[bufnr]:close()
    end
    debounce_update_context_timers[bufnr] = vim.loop.new_timer()
    debounce_update_context_timers[bufnr]:start(DEBOUNCE_UPDATE_CONTEXT_DELAY, 0, vim.schedule_wrap(function()
        update_context_at_cursor(bufnr)
    end))
end

function M.get_context_at_cursor()
    local bufnr = vim.api.nvim_get_current_buf()
    local need_redraw = update_context_at_cursor(bufnr)
    if need_redraw then
        return last_context[bufnr]
    end
    return need_redraw
end
--------------------------------------------------------------------------------
vim.api.nvim_create_augroup("CustomNavic", { clear = true })

vim.api.nvim_create_autocmd("LspAttach", {
    group = "CustomNavic",
    callback = function(args)
        local bufnr = args.buf
        if should_exclude(bufnr) then
            return
        end
        -- 初始化当前 buffer 的符号缓存
        M.init_buffer_symbols()
        vim.notify("Buffer symbols init completed.", 2)
        vim.api.nvim_create_autocmd({ "TextChanged", "InsertLeave" }, {
            group = "CustomNavic",
            buffer = bufnr,
            callback = function()
                debounce_update_buffer_symbols(bufnr)
            end,
        })

        vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
            group = "CustomNavic",
            buffer = bufnr,
            callback = function()
                debounce_update_cursor_context(bufnr)
            end,
        })

        vim.api.nvim_create_autocmd("BufWipeout", {
            group = "CustomNavic",
            buffer = bufnr,
            callback = function()
                if debounce_update_symbols_timers[bufnr] then
                    debounce_update_symbols_timers[bufnr]:stop()
                    debounce_update_symbols_timers[bufnr]:close()
                    debounce_update_symbols_timers[bufnr] = nil
                end
                if debounce_update_context_timers[bufnr] then
                    debounce_update_context_timers[bufnr]:stop()
                    debounce_update_context_timers[bufnr]:close()
                    debounce_update_context_timers[bufnr] = nil
                end
                cached_symbols[bufnr] = nil
                last_context[bufnr] = nil
            end,
        })
    end,
})

return M
