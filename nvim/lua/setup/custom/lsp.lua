vim.lsp.enable("lua_ls")
vim.lsp.enable("basedpyright")
vim.lsp.enable("clangd")
vim.lsp.enable("rust-analyzer")
vim.lsp.enable("gopls")

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
	callback = function(event)
		local client = vim.lsp.get_client_by_id(event.data.client_id)
		-- vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = event.buf, desc = "goto lsp definition" })
		-- vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = event.buf, desc = "goto lsp declaration" })
		vim.keymap.set(
			{ "n", "v" },
			"<leader>ca",
			vim.lsp.buf.code_action,
			{ buffer = event.buf, desc = "lsp code action" }
		)
		vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = event.buf, desc = "smart rename" })
		vim.keymap.set("n", "<A-d>", function()
			vim.diagnostic.open_float(nil, { border = "single" })
		end, { buffer = event.buf, desc = "show line diagnostics" })
		vim.keymap.set("n", "K", function()
			vim.lsp.buf.hover({ border = "single" })
		end, { buffer = event.buf, desc = "hover documentation" })
		vim.keymap.set("n", "<leader>rs", ":LspRestart<CR>", { buffer = event.buf, desc = "restart LSP" })

        -- diagnostics
		vim.diagnostic.config({
			virtual_lines = { current_line = true },
			-- virtual_text = true,
		})

        --inlayhints
        if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
            vim.keymap.set("n", "<leader>ih", function ()
                vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, { buffer = event.buf, desc = "toggle lsp inlay hints" })
        end

	end,
})
