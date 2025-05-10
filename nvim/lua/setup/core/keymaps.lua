vim.g.mapleader = " "
local keymap = vim.keymap

-- insert mode
keymap.set("i", "jk", "<esc>")

-- visual mode
keymap.set("v", "H", "^") -- move cursor to line ending
keymap.set("v", "L", "$") -- move cursor to line begining
keymap.set("v", "<C-e>", "%")

-- normal mode
keymap.set("n", "<leader>ww", "<Cmd>w<CR>")
keymap.set("n", "<leader>wq", "<Cmd>wq<CR>")
keymap.set("n", "H", "^") -- move cursor to line ending
keymap.set("n", "L", "$") -- move cursor to line begining
keymap.set("n", "dL", "d$") -- delete text between cursor and line ending
keymap.set("n", "dH", "d^") -- delete text between cursor and line begining
keymap.set("n", "yL", "y$") -- copy text between cursor and line ending
keymap.set("n", "yH", "y^") -- copy text between cursor and line begining
keymap.set("n", "<C-e>", "%")
keymap.set("n", "<leader>nh", ":nohl<CR>") -- cancel highlight
-- change the height of window
keymap.set('n', '<A-h>', '<Cmd>vertical resize -2<CR>', {noremap = true, silent = true})
keymap.set('n', '<A-l>', '<Cmd>vertical resize +2<CR>', {noremap = true, silent = true})
-- change the weigth of window
keymap.set('n', '<A-j>', '<Cmd>resize -2<CR>', { noremap = true, silent = true })
keymap.set('n', '<A-k>', '<Cmd>resize +2<CR>', { noremap = true, silent = true })
-- switch the buffer
keymap.set('n', '[b', '<Cmd>bp<CR>', { noremap = true, silent = true })
keymap.set('n', ']b', '<Cmd>bn<CR>', { noremap = true, silent = true })
-- select the splited window
keymap.set('n', '<C-h>', '<C-w>h')
keymap.set('n', '<C-j>', '<C-w>j')
keymap.set('n', '<C-k>', '<C-w>k')
keymap.set('n', '<C-l>', '<C-w>l')
-- keymap.set("n", "<C-w>q", "<Cmd>bd<CR>")
-- terminal mode
-- NOTE: this doesn't work in terminal emulators/tmux/etc
-- Now just using <C-\><C-n> to exit terminal mode
-- keymap.set("t", "<esc><esc>", "<C-\\><C-n>", {noremap = true}) -- turn to normal mode in terminal
function _G.set_terminal_keymaps()
    local opts = {buffer = 0}
    vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
    -- vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
    vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
    vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
    vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
    vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
    vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
end
