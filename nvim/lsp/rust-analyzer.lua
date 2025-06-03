return {
	cmd = { "rust-analyzer" },
	filetypes = { "rust" },
	capabilities = {
		experimental = {
			serverStatusNotification = true,
		},
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
	},
}
