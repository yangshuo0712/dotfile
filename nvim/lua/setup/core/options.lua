local opt = vim.opt
opt.encoding = "utf-8"
opt.fileencoding = "utf-8"
-- opt.ambiwidth = "double"
opt.termguicolors = true
opt.relativenumber = true --line number
opt.number = true

opt.tabstop = 4 --indent
opt.shiftwidth = 4
opt.expandtab = true
opt.autoindent = true

opt.wrap = false --prevent warpping
opt.cursorline = true --open cursorline
opt.mouse = "a" --allow using mouse
opt.clipboard = "unnamedplus" --system clipboard

opt.splitright = true --pos of new window
opt.splitbelow = true

opt.ignorecase = true --search
opt.smartcase = true

opt.cmdheight = 1
opt.showmode = true
opt.laststatus = 3

-- opt.fillchars = "vert: ,horiz: "
opt.langmenu = 'en_US.UTF-8'
vim.cmd('language messages en_US.UTF-8')

vim.diagnostic.config({
    virtual_lines = { current_line = true },
    -- virtual_text = true,
})
