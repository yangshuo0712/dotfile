vim.api.nvim_create_autocmd("TermOpen", {
    pattern = "*",
    callback = function()
        set_terminal_keymaps()
    end,
})

vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "*",
    callback = function()
        vim.api.nvim_set_hl(0, "SnacksPicker", { bg = "none", nocombine = true })
        vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#43445E", bg = "none", nocombine = true })
        vim.cmd("highlight! link WinBar Normal")
        vim.cmd("highlight! link WinBarNC Normal")
        vim.cmd("highlight! link TroubleNormal Normal")
        vim.cmd("highlight! link TroubleNormalNC Normal")
        vim.cmd("highlight! link LspInlayHint Comment")

        local ColorScheme = vim.g.colors_name
        if ColorScheme == "nord" then
            vim.cmd("highlight! link NonText Comment")
            vim.cmd("highlight! MiniCursorword guifg=NONE guibg=NONE gui=underline")
            vim.cmd("highlight! MiniCursorwordCurrent guifg=NONE guibg=NONE gui=underline")
            vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#434C5E", bg = "none", nocombine = true })
            vim.api.nvim_set_hl(0, "@markup.link", { fg = "#81A1C1", bg = "none", nocombine = true })
            vim.api.nvim_set_hl(0, "@markup.heading.1.markdown", { fg = "#8FBCBB", bold = true, nocombine = true })
            vim.api.nvim_set_hl(0, "@markup.heading.2.markdown", { fg = "#88C0D0", bold = true, nocombine = true })
            vim.api.nvim_set_hl(0, "@markup.heading.3.markdown", { fg = "#81A1C1", bold = true, nocombine = true })
            vim.api.nvim_set_hl(0, "@markup.heading.4.markdown", { fg = "#5E81AC", bold = true, nocombine = true })
            vim.api.nvim_set_hl(0, "@markup.heading.5.markdown", { fg = "#81ACC1", bold = true, nocombine = true })
            vim.api.nvim_set_hl(0, "@markup.heading.6.markdown", { fg = "#4C566A", bold = true, nocombine = true })
        elseif ColorScheme == "onenord" then
            vim.cmd("highlight! MiniCursorword guifg=NONE guibg=NONE gui=underline")
            vim.cmd("highlight! MiniCursorwordCurrent guifg=NONE guibg=NONE gui=underline")
            vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#81A1C1", bg = "none", nocombine = true })
            vim.api.nvim_set_hl(0, "NormalFloat", { fg = "#C8D0E0", bg = "#2e3440", nocombine = true })
            vim.api.nvim_set_hl(0, "StatusLine", { bg = "#434C5E", fg = "#D8DEE9", })
            vim.api.nvim_set_hl(0, "SnacksNotifierBorderInfo", { fg = "#81A1C1", bg = "none", nocombine = true })
            vim.api.nvim_set_hl(0, "SnacksNotifierIconInfo", { fg = "#81A1C1", bg = "none", nocombine = true })
            vim.api.nvim_set_hl(0, "SnacksNotifierTitleInfo", { fg = "#81A1C1", bg = "none", nocombine = true })
            vim.api.nvim_set_hl(0, "SnacksNotifierFooterInfo", { fg = "#81A1C1", bg = "none", nocombine = true })
        end
    end,
})

---@type table<number, {token:lsp.ProgressToken, msg:string, done:boolean}[]>
local progress = vim.defaulttable()
vim.api.nvim_create_autocmd("LspProgress", {
    ---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
    callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        local value = ev.data.params
        .value --[[@as {percentage?: number, title?: string, message?: string, kind: "begin" | "report" | "end"}]]
        if not client or type(value) ~= "table" then
            return
        end
        local p = progress[client.id]

        for i = 1, #p + 1 do
            if i == #p + 1 or p[i].token == ev.data.params.token then
                p[i] = {
                    token = ev.data.params.token,
                    msg = ("[%3d%%] %s%s"):format(
                        math.floor(value.kind == "end" and 100 or value.percentage or 100),
                        value.title or "",
                        value.message and (" **%s**"):format(value.message) or ""
                    ),
                    done = value.kind == "end",
                }
                break
            end
        end

        local msg = {} ---@type string[]
        progress[client.id] = vim.tbl_filter(function(v)
            return table.insert(msg, v.msg) or not v.done
        end, p)

        local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
        vim.notify(table.concat(msg, "\n"), "info", {
            id = "lsp_progress",
            title = client.name,
            opts = function(notif)
                notif.icon = #progress[client.id] == 0 and " "
                    or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
            end,
        })
    end,
})
