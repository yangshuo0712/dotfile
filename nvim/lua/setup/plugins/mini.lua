---@diagnostic disable: undefined-global
return {
	{
		"echasnovski/mini.nvim",
		version = false,
		config = function()
			require("mini.ai").setup()
			require("mini.pairs").setup()
			require("mini.surround").setup()
			require("mini.cursorword").setup()
			require("mini.bracketed").setup()
			require("mini.indentscope").setup()
			local hipatterns = require("mini.hipatterns")
			hipatterns.setup({
				highlighters = {
					fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
					hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
					todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
					note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },
					hex_color = hipatterns.gen_highlighter.hex_color(),
				},
			})

			local splitjoin_config = {
				detect = {
					separator = "[,;]",
				},
			}
			require("mini.splitjoin").setup(splitjoin_config)

			local move_config = {
				mappings = {
					-- Move visual selection in Visual mode. Defaults are Alt (Meta) + hjkl.
					left = "<M-h>",
					right = "<M-l>",
					down = "<M-j>",
					up = "<M-k>",

					-- Move current line in Normal mode
					line_left = "<M-H>",
					line_right = "<M-L>",
					line_down = "<M-J>",
					line_up = "<M-K>",
				},

				-- Options which control moving behavior
				options = {
					-- Automatically reindent selection during linewise vertical move
					reindent_linewise = true,
				},
			}
			require("mini.move").setup(move_config)

			local files_config = {
				options = {
					-- Whether to delete permanently or move into module-specific trash
					permanent_delete = true,
					-- Whether to use for editing directories
					use_as_default_explorer = true,
				},

				-- Customization of explorer windows
				windows = {
					-- Maximum number of windows to show side by side
					max_number = math.huge,
					-- Whether to show preview of file/directory under cursor
					preview = false,
					-- Width of focused window
					width_focus = 35,
					-- Width of non-focused window
					width_nofocus = 15,
					-- Width of preview window
					width_preview = 25,
				},
			}
			require("mini.files").setup(files_config)
			vim.keymap.set("n", "<leader>e", function()
				if not MiniFiles.close() then
					MiniFiles.open()
				end
			end, { desc = "Open MiniFiles" })
			local map_split = function(buf_id, lhs, direction)
				local rhs = function()
					-- Make new window and set it as target
					local cur_target = MiniFiles.get_explorer_state().target_window
					local new_target = vim.api.nvim_win_call(cur_target, function()
						vim.cmd(direction .. " split")
						return vim.api.nvim_get_current_win()
					end)

					MiniFiles.set_target_window(new_target)

					-- This intentionally doesn't act on file under cursor in favor of
					-- explicit "go in" action (`l` / `L`). To immediately open file,
					-- add appropriate `MiniFiles.go_in()` call instead of this comment.
				end

				-- Adding `desc` will result into `show_help` entries
				local desc = "Split " .. direction
				vim.keymap.set("n", lhs, rhs, { buffer = buf_id, desc = desc })
			end

            vim.api.nvim_create_autocmd("FileType", {
                pattern = {
                    "help",
                    "lazy",
                    "mason",
                    "trouble"
                },
                callback = function ()
                    vim.b.miniindentscope_disable = true
                end,
            })

			vim.api.nvim_create_autocmd("User", {
				pattern = "MiniFilesBufferCreate",
				callback = function(args)
					local buf_id = args.data.buf_id
					-- Tweak keys to your liking
					map_split(buf_id, "<C-s>", "belowright horizontal")
					map_split(buf_id, "<C-v>", "belowright vertical")
					map_split(buf_id, "<C-t>", "tab")
				end,
			})
			-- Custom MiniFileWindow
			vim.api.nvim_create_autocmd("User", {
				pattern = "MiniFilesWindowOpen",
				callback = function(args)
					local win_id = args.data.win_id

					-- Customize window-local settings
					-- vim.wo[win_id].winblend = 50
					local config = vim.api.nvim_win_get_config(win_id)
					config.border, config.title_pos = "single", "center"
					vim.api.nvim_win_set_config(win_id, config)
				end,
			})

			vim.api.nvim_create_autocmd("User", {
				pattern = "MiniFilesWindowUpdate",
				callback = function(args)
					local config = vim.api.nvim_win_get_config(args.data.win_id)

					-- Ensure fixed height
					-- config.height = 10

					-- Ensure no title padding
					local n = #config.title
					config.title[1][1] = config.title[1][1]:gsub("^ ", "")
					config.title[n][1] = config.title[n][1]:gsub(" $", "")

					vim.api.nvim_win_set_config(args.data.win_id, config)
				end,
			})
		end,
	},
	{
		"echasnovski/mini.icons",
		config = function()
			require("mini.icons").setup()
		end,
	},
}
