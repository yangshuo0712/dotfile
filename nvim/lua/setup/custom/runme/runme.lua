-- lua/setup/custom/runme/runme.lua
-- RunMe (fixed): Run current file / visual selection with toggleterm / terminal / REPL send
local M = {}

M.opts = {
	terminal_opts = {
		size = 15,
		open_mapping = nil,
		direction = "horizontal",
		shade_terminals = false,
		persist_size = true,
		close_on_exit = false,
		auto_scroll = true,
	},
	keymaps = {
		run_file = "<F5>",
		run_selection = "<leader>r",
		send_to_repl = "<leader>R",
	},
	tmp_dir = nil,
	use_toggleterm = true,
}

local function safe_require(name)
	local ok, mod = pcall(require, name)
	if not ok then
		return nil
	end
	return mod
end

local function shell_escape_single(s)
	if s == nil then
		return "''"
	end
	return "'" .. tostring(s):gsub("'", "'\\''") .. "'"
end

local function file_no_ext(path)
	return vim.fn.fnamemodify(path, ":r")
end
local function file_name_no_ext(path)
	return vim.fn.fnamemodify(path, ":t:r")
end
local function file_dir(path)
	return vim.fn.fnamemodify(path, ":h")
end

local function build_cmd_for_file(ft, fname, fnoext, dir)
	if ft == "python" then
		return string.format("python -u %s", shell_escape_single(fname))
	elseif ft == "c" then
		return string.format(
			"gcc -std=c11 %s -O2 -o %s && %s",
			shell_escape_single(fname),
			shell_escape_single(fnoext),
			shell_escape_single("./" .. vim.fn.fnamemodify(fnoext, ":t"))
		)
	elseif ft == "cpp" or ft == "c++" then
		return string.format(
			"g++ -std=c++17 %s -O2 -o %s && %s",
			shell_escape_single(fname),
			shell_escape_single(fnoext),
			shell_escape_single("./" .. vim.fn.fnamemodify(fnoext, ":t"))
		)
	elseif ft == "java" then
		local cls = file_name_no_ext(fname)
		return string.format(
			"cd %s && javac %s && java -cp %s %s",
			shell_escape_single(dir),
			shell_escape_single(fname),
			shell_escape_single(dir),
			shell_escape_single(cls)
		)
	elseif ft == "javascript" or ft == "javascriptreact" then
		return string.format("node %s", shell_escape_single(fname))
	elseif ft == "typescript" or ft == "typescriptreact" then
		return string.format("node %s", shell_escape_single(fname))
	elseif ft == "go" then
		return string.format("go run %s", shell_escape_single(fname))
	elseif ft == "rust" then
		return "cargo run"
	else
		return string.format("%s %s", vim.o.shell, shell_escape_single(fname))
	end
end

-- toggleterm detection
local function ensure_toggleterm()
	local tt = safe_require("toggleterm")
	local TerminalMod = safe_require("toggleterm.terminal")
	local TerminalClass = TerminalMod and TerminalMod.Terminal or nil
	return tt, TerminalClass
end

M.term = nil

local function create_shared_toggleterm(direction, close_on_exit)
	local tt, TerminalClass = ensure_toggleterm()
	if not tt or not TerminalClass then
		return nil
	end
	-- try to create an instance; some toggleterm versions use Terminal:new, some TerminalClass:new
	local ok, inst = pcall(function()
		return TerminalClass:new({
			hidden = true,
			direction = direction or "horizontal",
			close_on_exit = close_on_exit or false,
		})
	end)
	if not ok then
		-- try alternate constructor
		ok, inst = pcall(function()
			return TerminalClass({
				hidden = true,
				direction = direction or "horizontal",
				close_on_exit = close_on_exit or false,
			})
		end)
	end
	if ok and inst then
		M.term = inst
		return M.term
	end
	return nil
end

local function find_terminal_buf()
	for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_valid(bufnr) then
			local ok, bt = pcall(vim.api.nvim_buf_get_option, bufnr, "buftype")
			if ok and bt == "terminal" then
				return bufnr
			end
		end
	end
	return nil
end

local function send_to_terminal_buf(cmd, bufnr)
	bufnr = bufnr or find_terminal_buf()
	if not bufnr then
		return false, "no terminal buffer found"
	end
	local job_id = vim.b[bufnr].terminal_job_id
	if not job_id then
		return false, "terminal buffer has no job id"
	end
	vim.api.nvim_chan_send(job_id, cmd .. "\n")
	return true
end

function M.toggle_term()
	-- if we have a toggleterm instance, try to toggle it
	if M.term then
		-- prefer instance toggle if available
		if type(M.term.toggle) == "function" then
			pcall(function()
				M.term:toggle()
			end)
			return
		end
		if type(M.term.open) == "function" then
			-- open if closed
			pcall(function()
				M.term:open()
			end)
			return
		end
	end
	-- fallback: call toggleterm's global command if available
	if vim.fn.exists(":ToggleTerm") == 2 then
		pcall(vim.cmd, "ToggleTerm")
		return
	end
	-- final fallback: find terminal buffer and close its window (hide)
	local tb = (function()
		for _, b in ipairs(vim.api.nvim_list_bufs()) do
			if vim.api.nvim_buf_is_valid(b) and vim.api.nvim_buf_get_option(b, "buftype") == "terminal" then
				return b
			end
		end
		return nil
	end)()
	if tb then
		-- hide window showing that buffer (if any)
		for _, w in ipairs(vim.api.nvim_list_wins()) do
			if vim.api.nvim_win_get_buf(w) == tb then
				pcall(vim.api.nvim_win_close, w, true)
				return
			end
		end
	end
end

function M.run_cmd(cmd)
	pcall(vim.cmd, "write")
	local wrapped = string.format('bash -lc "%s"', tostring(cmd):gsub('"', '\\"'))

	if M.opts.use_toggleterm then
		local tt, TerminalClass = ensure_toggleterm()
		if tt and TerminalClass then
			if not M.term then
				create_shared_toggleterm(M.opts.terminal_opts.direction, M.opts.terminal_opts.close_on_exit)
			end

			if M.term then
				-- Preferred: if exec exists (some versions), use it
				if type(M.term.exec) == "function" then
					pcall(function()
						M.term:exec(wrapped, 1)
					end)
					return
				end

				-- Fallback: try toggle/open then send via terminal_job_id
				if type(M.term.toggle) == "function" then
					pcall(function()
						M.term:toggle()
					end)
				elseif type(M.term.open) == "function" then
					pcall(function()
						M.term:open()
					end)
				end

				-- after opening, try to find a terminal buffer and send the command
				local term_buf = find_terminal_buf()
				if term_buf then
					local ok, err = send_to_terminal_buf(wrapped, term_buf)
					if ok then
						return
					end
				end
				-- else fallthrough to split terminal fallback
			end
		end
	end

	-- Try reusing any existing terminal buffer
	local term_buf = find_terminal_buf()
	if term_buf then
		local ok, err = send_to_terminal_buf(wrapped, term_buf)
		if ok then
			return
		end
	end

	-- Final fallback: open a new terminal split and run the command
	local size = M.opts.terminal_opts.size or 15
	local cmdline =
		string.format('belowright split | resize %d | terminal bash -lc "%s"', size, tostring(cmd):gsub('"', '\\"'))
	pcall(vim.cmd, cmdline)
end

function M.run_async(cmd, on_stdout, on_exit)
	local job = vim.fn.jobstart({ "bash", "-lc", cmd }, {
		stdout_buffered = true,
		stderr_buffered = true,
		on_stdout = function(_, data, _)
			if on_stdout then
				on_stdout(data)
			end
		end,
		on_stderr = function(_, data, _)
			if on_stdout then
				on_stdout(data)
			end
		end,
		on_exit = function(_, code, _)
			if on_exit then
				on_exit(code)
			end
		end,
	})
	return job
end

function M.run_current()
	local bufname = vim.fn.expand("%:p")
	if bufname == "" then
		vim.notify("[runme] No file to run", vim.log.levels.WARN)
		return
	end
	local ft = vim.bo.filetype
	local fname = bufname
	local fnoext = file_no_ext(fname)
	local dir = file_dir(fname)
	local cmd = build_cmd_for_file(ft, fname, fnoext, dir)
	M.run_cmd(cmd)
end

function M.run_selection()
	local mode = vim.fn.mode()
	local lines = nil
	if mode == "v" or mode == "V" or mode == "\22" then
		local s_pos = vim.fn.getpos("'<")
		local e_pos = vim.fn.getpos("'>")
		local s_row = s_pos[2]
		local e_row = e_pos[2]
		local bufnr = vim.api.nvim_get_current_buf()
		lines = vim.api.nvim_buf_get_lines(bufnr, s_row - 1, e_row, false)
	else
		local choice = vim.fn.input("[runme] Not in visual mode. Run whole file? (y/N): ")
		if choice:lower() == "y" then
			return M.run_current()
		else
			vim.notify("[runme] canceled", vim.log.levels.INFO)
			return
		end
	end

	local ft = vim.bo.filetype
	local ext = ".tmp"
	if ft == "python" then
		ext = ".py"
	end
	if ft == "javascript" or ft == "javascriptreact" then
		ext = ".js"
	end
	if ft == "typescript" or ft == "typescriptreact" then
		ext = ".ts"
	end
	if ft == "c" then
		ext = ".c"
	end
	if ft == "cpp" or ft == "c++" then
		ext = ".cpp"
	end
	if ft == "lua" then
		ext = ".lua"
	end
	if ft == "sh" or ft == "bash" then
		ext = ".sh"
	end

	local tmp = (M.opts.tmp_dir and M.opts.tmp_dir ~= "")
			and (M.opts.tmp_dir .. "/runme_" .. tostring(math.random(1, 100000)) .. ext)
		or (vim.fn.tempname() .. ext)

	vim.fn.writefile(lines, tmp)
	local cmd = build_cmd_for_file(ft, tmp, file_no_ext(tmp), file_dir(tmp))
	M.run_cmd(cmd)
end

function M.send_to_repl()
	local mode = vim.fn.mode()
	if mode == "v" or mode == "V" or mode == "\22" then
		local s_pos = vim.fn.getpos("'<")
		local e_pos = vim.fn.getpos("'>")
		local s_row = s_pos[2]
		local e_row = e_pos[2]
		local bufnr = vim.api.nvim_get_current_buf()
		local lines = vim.api.nvim_buf_get_lines(bufnr, s_row - 1, e_row, false)

		local term_buf = find_terminal_buf()
		if not term_buf then
			pcall(vim.cmd, "belowright split | resize " .. (M.opts.terminal_opts.size or 15) .. " | terminal")
			term_buf = find_terminal_buf()
			vim.cmd("startinsert")
		end

		local ok, err = send_to_terminal_buf(table.concat(lines, "\n"), term_buf)
		if not ok then
			vim.notify("[runme] send_to_repl failed: " .. tostring(err), vim.log.levels.WARN)
		end
		return
	else
		local bufname = vim.fn.expand("%:p")
		if bufname == "" then
			vim.notify("[runme] no file", vim.log.levels.WARN)
			return
		end
		local ft = vim.bo.filetype
		local cmd = build_cmd_for_file(ft, bufname, file_no_ext(bufname), file_dir(bufname))
		local term_buf = find_terminal_buf()
		if not term_buf then
			pcall(
				vim.cmd,
				"belowright split | resize "
					.. (M.opts.terminal_opts.size or 15)
					.. ' | terminal bash -lc "'
					.. cmd:gsub('"', '\\"')
					.. '"'
			)
			return
		end
		local ok, err = send_to_terminal_buf(cmd, term_buf)
		if not ok then
			vim.notify("[runme] send_to_repl failed: " .. tostring(err), vim.log.levels.WARN)
		end
	end
end

function M.setup(user_opts)
	user_opts = user_opts or {}
	M.opts = vim.tbl_deep_extend("force", M.opts, user_opts)

	if M.opts.use_toggleterm then
		local tt, TerminalClass = ensure_toggleterm()
		if tt and TerminalClass then
			pcall(function()
				local topts = vim.tbl_deep_extend("force", {}, M.opts.terminal_opts)

				topts.shade_terminals = false

				topts.open_mapping = nil

				topts.on_open = function(term)
					pcall(function()
						local win = term and (term.window or term.win or nil)
						if win and vim.api.nvim_win_is_valid(win) then
							vim.api.nvim_win_set_option(
								win,
								"winhighlight",
								"Normal:Normal,NormalNC:Normal,StatusLine:CustomStatusLineNormal,StatusLineNC:CustomStatusLineNormal"
							)
						end
						pcall(vim.cmd, "redrawstatus")
					end)
				end

				topts.on_close = function(term)
					pcall(function()
						pcall(vim.cmd, "redrawstatus")
					end)
				end

				tt.setup(topts)
			end)
			create_shared_toggleterm(M.opts.terminal_opts.direction, M.opts.terminal_opts.close_on_exit)
		else
			vim.notify("[runme] toggleterm not available, falling back to builtin terminal", vim.log.levels.INFO)
		end
	end

	local run_file_k = M.opts.keymaps.run_file or "<F5>"
	local run_sel_k = M.opts.keymaps.run_selection or "<leader>r"
	local send_repl_k = M.opts.keymaps.send_to_repl or "<leader>R"

	vim.keymap.set("n", run_file_k, function()
		M.run_current()
	end, { noremap = true, silent = true, desc = "Run current file (runme)" })
	vim.keymap.set("v", run_sel_k, function()
		M.run_selection()
	end, { noremap = true, silent = true, desc = "Run selection (runme)" })
	vim.keymap.set({ "n", "v" }, send_repl_k, function()
		M.send_to_repl()
	end, { noremap = true, silent = true, desc = "Send selection/file to REPL (runme)" })

	vim.keymap.set({ "n", "i", "v", "x", "t" }, "<C-\\>", function()
		local tt, TerminalClass = ensure_toggleterm()
		if tt and TerminalClass and not M.term then
			pcall(function()
				local topts = vim.tbl_deep_extend("force", {}, M.opts.terminal_opts)
				topts.open_mapping = nil
				topts.shade_terminals = false
				tt.setup(topts)
			end)
			create_shared_toggleterm(M.opts.terminal_opts.direction, M.opts.terminal_opts.close_on_exit)
		end

		local mode = vim.api.nvim_get_mode().mode

		if mode == "t" or mode == "i" then
			pcall(vim.cmd, "stopinsert")
		end

		vim.schedule(function()
			if M.term and type(M.term.toggle) == "function" then
				pcall(function()
					M.term:toggle()
				end)
			elseif vim.fn.exists(":ToggleTerm") == 2 then
				pcall(vim.cmd, "ToggleTerm")
			else
				local found = false
				for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
					if vim.api.nvim_buf_is_valid(bufnr) then
						local ok, bt = pcall(vim.api.nvim_buf_get_option, bufnr, "buftype")
						if ok and bt == "terminal" then
							for _, w in ipairs(vim.api.nvim_list_wins()) do
								if vim.api.nvim_win_get_buf(w) == bufnr then
									vim.api.nvim_set_current_win(w)
									pcall(vim.cmd, "startinsert")
									found = true
									break
								end
							end
							if found then
								break
							end
						end
					end
				end
				if not found then
					local size = M.opts.terminal_opts.size or 15
					pcall(vim.cmd, "belowright split | resize " .. size .. " | terminal")
					vim.schedule(function()
						local tb = find_terminal_buf()
						if tb then
							for _, w in ipairs(vim.api.nvim_list_wins()) do
								if vim.api.nvim_win_get_buf(w) == tb then
									vim.api.nvim_set_current_win(w)
									pcall(vim.cmd, "startinsert")
									return
								end
							end
						end
					end)
				end
			end

			local tb = find_terminal_buf()
			if tb then
				for _, w in ipairs(vim.api.nvim_list_wins()) do
					if vim.api.nvim_win_get_buf(w) == tb then
						pcall(vim.api.nvim_set_current_win, w)
						pcall(vim.cmd, "startinsert")
						return
					end
				end
			end
		end)
	end, { noremap = true, silent = true, desc = "Toggle shared terminal (runme/Global <C-\\>)" })

	vim.api.nvim_create_autocmd("TermOpen", {
		callback = function(args)
			pcall(function()
				local win = vim.fn.bufwinid(args.buf)
				if win and win >= 0 and vim.api.nvim_win_is_valid(win) then
					pcall(
						vim.api.nvim_win_set_option,
						win,
						"winhighlight",
						"Normal:Normal,NormalNC:Normal,StatusLine:CustomStatusLineNormal,StatusLineNC:CustomStatusLineNormal"
					)
				else
					vim.schedule(function()
						local w2 = vim.fn.bufwinid(args.buf)
						if w2 and w2 >= 0 and vim.api.nvim_win_is_valid(w2) then
							pcall(
								vim.api.nvim_win_set_option,
								w2,
								"winhighlight",
								"Normal:Normal,NormalNC:Normal,StatusLine:CustomStatusLineNormal,StatusLineNC:CustomStatusLineNormal"
							)
						end
					end)
				end
				pcall(vim.cmd, "redrawstatus")
			end)
		end,
	})

	pcall(function()
		vim.cmd([[
          hi def link CustomStatusLineNormal StatusLine
          hi def link CustomStatusLineError Error
          hi def link CustomStatusLineWarning WarningMsg
          hi def link CustomStatusLineInfo Identifier
          hi def link CustomStatusLineHint Comment
        ]])
	end)

	vim.api.nvim_create_user_command("RunFile", function()
		M.run_current()
	end, { desc = "Run current file (runme)" })
	vim.api.nvim_create_user_command("RunSelection", function()
		M.run_selection()
	end, { desc = "Run visual selection (runme)" })

	vim.notify("[runme] setup complete", vim.log.levels.INFO)
end

return M
