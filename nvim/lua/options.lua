--
-- Settings ported from ~/.vimrc, minus the things neovim already does by
-- default (syntax on, filetype plugin indent on, incsearch, wildmenu,
-- backspace=2, laststatus=2, autoindent, ttyfast, encoding=utf-8).
--
local opt = vim.opt

-- Display
opt.number = true
opt.cursorline = true
opt.title = true
opt.scrolloff = 3
opt.virtualedit = 'block'
opt.startofline = false
opt.wrap = true
opt.linebreak = true
opt.linespace = 3
opt.showmatch = true
opt.signcolumn = 'yes'          -- stops the gutter jittering when diagnostics appear
opt.termguicolors = true

-- Indentation — 4 spaces, as in your vimrc
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.expandtab = true
opt.shiftround = true
opt.smartindent = true

-- Searching
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true

-- Files
opt.swapfile = false
opt.undofile = true             -- undodir defaults to ~/.local/state/nvim/undo
opt.autowrite = true
opt.autowriteall = true
opt.autoread = false            -- you had noautoread; keeping that
opt.modeline = true
opt.modelines = 5

-- Completion / messages
opt.completeopt = { 'menu', 'menuone', 'noselect' }
opt.shortmess:append('a')
opt.report = 0
opt.wildmode = 'full'
opt.wildignore:append({ '*.o', '*.obj', '.git', '*.pyc', 'eggs/**', '*.egg-info/**' })

-- No bells of any kind
opt.errorbells = false
opt.visualbell = false

-- Splits open where you expect
opt.splitright = true
opt.splitbelow = true

opt.clipboard = ''              -- deliberate: system clipboard stays on "+ only

-- Neovim defaults to mouse=nvi, which captures drags as visual-mode selections
-- inside nvim, so iTerm never sees a selection and cmd-c copies nothing.
-- Classic vim (with your vimrc) left the mouse to the terminal. Match that.
-- Want nvim mouse support back? Set 'a' and use <leader>y to copy.
opt.mouse = ''

-- Trailing whitespace is visible rather than a surprise
opt.list = true
opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Diagnostics: inline text is noisy on wide code; keep signs and the float.
vim.diagnostic.config({
  virtual_text = { spacing = 2, prefix = '●' },
  severity_sort = true,
  float = { border = 'rounded', source = true },
})

-- Go templates: gopls handles them, but Neovim has no built-in filetype for
-- them (the "Unknown filetype 'gotmpl'" health warning).
vim.filetype.add({ extension = { gotmpl = 'gotmpl', gohtml = 'gotmpl' } })
