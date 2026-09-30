--
-- Colorscheme, statusline, and the which-key popup.
-- lualine replaces vim-airline; powerline is gone entirely.
--
return {
  {
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 1000,            -- must load before anything that sets highlights
    opts = { style = 'night' },
    config = function(_, opts)
      require('tokyonight').setup(opts)
      vim.cmd.colorscheme('tokyonight-night')
    end,
  },

  {
    'nvim-lualine/lualine.nvim',
    event = 'VeryLazy',
    opts = {
      options = {
        theme = 'tokyonight',
        section_separators = '',
        component_separators = '|',
        globalstatus = true,
      },
      sections = {
        lualine_c = { { 'filename', path = 1 } },     -- path relative to cwd
        lualine_x = { 'diagnostics', 'filetype' },
      },
    },
  },

  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    opts = {
      preset = 'helix',
      -- Icons need mini.icons/nvim-web-devicons AND a Nerd Font in iTerm.
      -- Off until you want both; which-key still reports this in :checkhealth.
      icons = { mappings = false },
    },
  },
}
