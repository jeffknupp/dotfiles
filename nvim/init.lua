--
-- ~/.config/nvim/init.lua
--
-- Layout:
--   lua/options.lua   vim settings, ported from ~/.vimrc
--   lua/keymaps.lua   the mappings you already have muscle memory for
--   lua/plugins/*     one file per area, loaded by lazy.nvim
--
-- Language servers are installed by dotfiles/vim/install-lsp.sh, not by mason,
-- so what nvim uses is the same binary your terminal uses.
--

vim.g.mapleader = ','
vim.g.maplocalleader = ','

-- Remote-plugin providers. Every plugin here is Lua, so none of these are
-- used; disabling them skips the startup probes and the :checkhealth noise.
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

require('options')
require('keymaps')

-- lazy.nvim bootstrap ------------------------------------------------------
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    'git', 'clone', '--filter=blob:none', '--branch=stable',
    'https://github.com/folke/lazy.nvim.git', lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup('plugins', {
  change_detection = { notify = false },
  rocks = { enabled = false },                    -- no plugin here needs luarocks
  checker = { enabled = true, notify = false },   -- background update check, quiet
})
