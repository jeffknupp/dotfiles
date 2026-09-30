--
-- Mappings. Everything here is either from your ~/.vimrc or a direct
-- replacement for a plugin mapping that moved (Gundo -> undotree).
--
local map = vim.keymap.set

-- Window navigation — ctrl-h/j/k/l, as in your vimrc
map('n', '<C-j>', '<C-w>j')
map('n', '<C-k>', '<C-w>k')
map('n', '<C-l>', '<C-w>l')
map('n', '<C-h>', '<C-w>h')

-- Quickfix
map('n', '<leader>c',  ':copen<CR>',  { desc = 'Open quickfix' })
map('n', '<leader>cc', ':cclose<CR>', { desc = 'Close quickfix' })

-- Housekeeping from your vimrc
map('n', '<leader>q', ':q<CR>',          { desc = 'Quit window' })
map('n', '<leader>.', ':lcd %:p:h<CR>',  { desc = 'cd to file dir' })
map('n', '<leader><space>', ':nohlsearch<CR>', { desc = 'Clear search highlight' })
map('n', '<leader>S', [[:%s/\s\+$//<CR>:let @/=''<CR>]], { desc = 'Strip trailing whitespace' })
map('n', '<leader>p', '"+p', { desc = 'Paste from system clipboard' })
map('v', '<leader>y', '"+y', { desc = 'Yank to system clipboard' })

-- Buffers (was <C-space> / <C-M-space>, which terminals mangle)
map('n', '<leader>n', ':bnext<CR>',     { desc = 'Next buffer' })
map('n', '<leader>N', ':bprevious<CR>', { desc = 'Previous buffer' })

-- sudo write — `:W!` in your vimrc, kept
vim.cmd([[command! -bang W w !sudo tee % >/dev/null]])

-- Reload config
map('n', '<leader>V', ':source $MYVIMRC<CR>', { desc = 'Reload init.lua' })

-- Diagnostics
map('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Line diagnostics' })
map('n', '<leader>d', function() vim.diagnostic.setloclist() end, { desc = 'Diagnostics to loclist' })
