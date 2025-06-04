return {
	"saghen/blink.cmp",
	dependencies = {
		"echasnovski/mini.nvim",
		"rafamadriz/friendly-snippets",
	},
	version = "*",
	---@module 'blink.cmp'
	---type blink.cmp.Config
	opts = {
		signature = {
			enabled = true,
		},
		appearance = {
			use_nvim_cmp_as_default = false,
			nerd_font_variant = "mono",
		},
		sources = {
			default = {
				"lsp",
				"path",
				"snippets",
				"buffer",
				"codecompanion",
			},
		},
		cmdline = {
			enabled = false,
		},
		completion = {
			keyword = {
				range = "full",
			},
			list = {
				selection = {
					preselect = true,
					auto_insert = true,
				},
			},
			accept = {
				auto_brackets = {
					enabled = true,
				},
			},
			menu = {
				auto_show = true,
				draw = {
					columns = {
						{
							"kind_icon",
							"kind",
						},
						{
							"label",
							"label_description",
							gap = 1,
						},
					},
					components = {
						kind_icon = {
							-- text = function(ctx)
							-- 	local kind_icon, _, _ = MiniIcons.get("lsp", ctx.kind)
							-- 	return kind_icon
							-- end,
							highlight = function(ctx)
								local _, hl, _ = MiniIcons.get("lsp", ctx.kind)
								return hl
							end,
						},
						kind = {
							highlight = function(ctx)
								local _, hl, _ = MiniIcons.get("lsp", ctx.kind)
								return hl
							end,
						},
					},
				},
			},
			documentation = {
				auto_show = false,
				auto_show_delay_ms = 500,
			},
			ghost_text = {
				enabled = false,
			},
		},
		keymap = {
			preset = "none",
			-- super tab
			["<C-space>"] = {
				"show",
				"show_documentation",
				"hide_documentation",
			},
			["<C-e>"] = {
				"hide",
				"fallback",
			},

			["<Tab>"] = {
				function(cmp)
					if cmp.snippet_active() then
						return cmp.accept()
					else
						return cmp.select_and_accept()
					end
				end,
				"snippet_forward",
				"fallback",
			},
			["<S-Tab>"] = { "snippet_backward", "fallback" },

			["<Up>"] = { "select_prev", "fallback" },
			["<Down>"] = { "select_next", "fallback" },
			["<C-p>"] = { "select_prev", "fallback_to_mappings" },
			["<C-n>"] = { "select_next", "fallback_to_mappings" },

			["<C-b>"] = { "scroll_documentation_up", "fallback" },
			["<C-f>"] = { "scroll_documentation_down", "fallback" },

			["<C-k>"] = { "show_signature", "hide_signature", "fallback" },
		},
	},
	opts_extend = { "sources.default" },
}
