return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"saghen/blink.cmp",
	},
	config = function()
		local lspconfig = require("lspconfig")
		local capabilities = require("blink.cmp").get_lsp_capabilities()
		local keymap = vim.keymap
		local opts = { noremap = true, silent = true }

		local signs = {
			Error = " ",
			Warn = " ",
			Hint = "󰠠 ",
			Info = " ",
		}

		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
		end

		-- Keymap setup for LSP
		local function setup_lsp_keymaps(bufnr)
			local buf_opts = vim.tbl_extend("force", opts, { buffer = bufnr })

			keymap.set(
				"n",
				"gD",
				vim.lsp.buf.declaration,
				vim.tbl_extend("force", buf_opts, { desc = "Go to declaration" })
			)
			keymap.set(
				{ "n", "v" },
				"<leader>ca",
				vim.lsp.buf.code_action,
				vim.tbl_extend("force", buf_opts, { desc = "See available code actions" })
			)
			keymap.set(
				"n",
				"<leader>rn",
				vim.lsp.buf.rename,
				vim.tbl_extend("force", buf_opts, { desc = "Smart rename" })
			)
			keymap.set("n", "<A-d>", function()
				vim.diagnostic.open_float(nil, { border = "single" })
			end, vim.tbl_extend("force", buf_opts, { desc = "Show line diagnostics" }))
			keymap.set("n", "K", function()
				vim.lsp.buf.hover({ border = "single" })
			end, vim.tbl_extend("force", buf_opts, { desc = "Hover documentation" }))
			-- keymap.set(
			-- 	"n",
			-- 	"]d",
			-- 	vim.diagnostic.goto_next,
			-- 	vim.tbl_extend("force", buf_opts, { desc = "Next diagnostic" })
			-- )
			-- keymap.set(
			-- 	"n",
			-- 	"[d",
			-- 	vim.diagnostic.goto_prev,
			-- 	vim.tbl_extend("force", buf_opts, { desc = "Previous diagnostic" })
			-- )
			keymap.set(
				"n",
				"<leader>rs",
				":LspRestart<CR>",
				vim.tbl_extend("force", buf_opts, { desc = "Restart LSP" })
			)
			vim.keymap.set("n", "<leader>ih", function()
				local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
				vim.lsp.inlay_hint.enable(not enabled, { bufnr = bufnr })
                vim.notify("Inlay hints " .. (not enabled and "enabled" or "disabled"))
			end, { desc = "Toggle Inlay Hints" })
		end

		local function on_attach(_, bufnr)
			setup_lsp_keymaps(bufnr)
		end

		-- Setup each language server
		lspconfig.pyright.setup({
			cmd = { "pyright-langserver", "--stdio" },
			capabilities = capabilities,
			on_attach = on_attach,
			root_dir = function(fname)
				return lspconfig.util.root_pattern("pyrightconfig.json", ".git")(fname) or vim.fn.getcwd()
			end,
			settings = {
				python = {
					analysis = {
						useLibraryCodeForTypes = true,
					},
				},
			},
		})

		lspconfig.clangd.setup({
			capabilities = capabilities,
			on_attach = on_attach,
		})

		lspconfig.lua_ls.setup({
			capabilities = capabilities,
			on_attach = on_attach,
			settings = {
				Lua = {
					diagnostics = {
						globals = { "vim" },
					},
					workspace = {
						library = {
							[vim.fn.expand("$VIMRUNTIME/lua")] = true,
							[vim.fn.stdpath("config") .. "/lua"] = true,
						},
					},
				},
			},
		})

		lspconfig.rust_analyzer.setup({
			capabilities = capabilities,
			on_attach = on_attach,
			settings = {
				["rust-analyzer"] = {
					diagnostics = {
						enable = false,
					},
					checkOnSave = true,
                    check = {
                        command = "clippy",
                    },
					inlayHints = {
						typeHints = true,
						chainingHints = true,
						parameterHints = false,
					},
				},
			},
		})
	end,
}
