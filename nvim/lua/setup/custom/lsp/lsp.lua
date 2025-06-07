local M = {}

M.servers = {
    "lua_ls",
    "basedpyright",
    "clangd",
    "rust-analyzer",
    "gopls",
}

function M.on_attach(event)
    local buf = event.buf
    local client = vim.lsp.get_client_by_id(event.data.client_id)

    local map = function(lhs, rhs, desc)
        vim.keymap.set({ "n", "v" }, lhs, rhs, { buffer = buf, desc = desc })
    end

    map("<leader>ca", vim.lsp.buf.code_action, "LSP code action")
    map("<leader>rn", vim.lsp.buf.rename, "Rename symbol")
    map("<A-d>", function() vim.diagnostic.open_float(nil, { border = "single" }) end,
        "Line diagnostics")
    map("K", function() vim.lsp.buf.hover { border = "single" } end,
        "Hover")

    vim.diagnostic.config({
        virtual_lines = { current_line = true },
        -- virtual_text = true,
    })

    --inlayhints
    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
        vim.keymap.set("n", "<leader>ih", function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
        end, { buffer = event.buf, desc = "toggle lsp inlay hints" })
    end
end

function M.setup()
    for _, name in ipairs(M.servers) do
        vim.lsp.enable(name)
    end

    local grp = vim.api.nvim_create_augroup("user_lsp_attach", { clear = true })
    vim.api.nvim_create_autocmd("LspAttach", {
        group = grp,
        callback = M.on_attach,
    })
end

return M
