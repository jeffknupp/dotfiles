--
-- gitsigns for the gutter and hunk operations; fugitive because you already
-- know it and nothing has really replaced :Git blame.
--
return {
  {
    'lewis6991/gitsigns.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {
      on_attach = function(bufnr)
        local gs = require('gitsigns')
        local function map(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
        end
        map('n', ']h', gs.next_hunk,    'Next hunk')
        map('n', '[h', gs.prev_hunk,    'Previous hunk')
        map('n', '<leader>hs', gs.stage_hunk,   'Stage hunk')
        map('n', '<leader>hr', gs.reset_hunk,   'Reset hunk')
        map('n', '<leader>hp', gs.preview_hunk, 'Preview hunk')
        map('n', '<leader>hb', function() gs.blame_line({ full = true }) end, 'Blame line')
      end,
    },
  },

  { 'tpope/vim-fugitive', cmd = { 'Git', 'G', 'Gdiffsplit', 'Gblame' } },
}
