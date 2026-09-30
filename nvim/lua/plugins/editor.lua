--
-- Finding things, moving around, editing.
--   telescope  replaces ctrlp and Command-T  (<C-p> is mapped the same as before)
--   undotree   replaces gundo.vim
--   surround   is the one tpope binding you didn't already have
--
return {
  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    },
    cmd = 'Telescope',
    keys = {
      { '<C-p>',      function() require('telescope.builtin').find_files() end,  desc = 'Find files' },
      { '<leader>ff', function() require('telescope.builtin').find_files() end,  desc = 'Find files' },
      { '<leader>fg', function() require('telescope.builtin').live_grep() end,   desc = 'Grep (ripgrep)' },
      { '<leader>fb', function() require('telescope.builtin').buffers() end,     desc = 'Buffers' },
      { '<leader>fh', function() require('telescope.builtin').help_tags() end,   desc = 'Help tags' },
      { '<leader>fr', function() require('telescope.builtin').oldfiles() end,    desc = 'Recent files' },
      { '<leader>fs', function() require('telescope.builtin').lsp_document_symbols() end, desc = 'Document symbols' },
    },
    opts = {
      defaults = {
        layout_strategy = 'flex',
        path_display = { 'truncate' },
        file_ignore_patterns = { '%.git/', 'node_modules/', '%.venv/', '__pycache__/' },
      },
      pickers = {
        find_files = { hidden = true },
      },
    },
    config = function(_, opts)
      local telescope = require('telescope')
      telescope.setup(opts)
      pcall(telescope.load_extension, 'fzf')
    end,
  },

  {
    'mbbill/undotree',
    keys = { { '<leader>g', vim.cmd.UndotreeToggle, desc = 'Undo tree' } },
  },

  {
    'kylechui/nvim-surround',
    event = 'VeryLazy',
    opts = {},
  },
}
