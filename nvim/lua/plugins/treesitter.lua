--
-- Syntax highlighting and indentation via tree-sitter parsers.
-- Pinned to the master branch: the `main` rewrite uses a different API.
--
return {
  'nvim-treesitter/nvim-treesitter',
  branch = 'master',
  build = ':TSUpdate',
  event = { 'BufReadPost', 'BufNewFile' },
  main = 'nvim-treesitter.configs',
  opts = {
    ensure_installed = {
      'python', 'go', 'gomod', 'rust', 'typescript', 'javascript', 'tsx',
      'lua', 'vim', 'vimdoc', 'bash', 'json', 'yaml', 'toml', 'markdown',
      'markdown_inline', 'dockerfile', 'sql', 'c', 'cpp', 'html', 'css',
    },
    auto_install = true,
    highlight = { enable = true },
    indent = { enable = true },
  },
}
