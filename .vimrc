" ==========================================================
" ~/.vimrc — classic vim, kept as a lightweight fallback.
"
" Neovim is the daily driver now: see ~/.config/nvim/.
" This file is deliberately small — plugins here are only the ones that
" still work well in vim 9 and that you actually had installed.
"
" Removed, and why:
"   YouCompleteMe   declared but never installed (needs a compile step);
"                   nvim's LSP replaces it
"   powerline       second statusline fighting vim-airline
"   Command-T       your checkout is the Lua build, which is neovim-only
"   vcscommand.vim  last commit 2013; fugitive covers it
"   solarized /
"   distinguished   installed but never declared; molokai is the one you set
"   syntastic cfg   the g:syntastic_* block had no plugin behind it
"
" Repos changed to their maintained forks: ctrlp, vim-markdown, gundo->mundo.
" `git@github.com:` remotes are gone too, so :PluginUpdate no longer needs an
" SSH key loaded.
" ==========================================================

set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'vim-airline/vim-airline'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-repeat'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'preservim/vim-markdown'
Plugin 'simnalamburt/vim-mundo'
Plugin 'ekalinin/Dockerfile.vim'
Plugin 'rust-lang/rust.vim'
Plugin 'fatih/vim-go'
Plugin 'reedes/vim-wordy'
Plugin 'tomasr/molokai'
Plugin 'nanotech/jellybeans.vim'

call vundle#end()
filetype plugin indent on

" ==========================================================
" Shortcuts
" ==========================================================
let mapleader=","

" sudo write this
cmap W! w !sudo tee % >/dev/null

" Reload vimrc
map <silent> <leader>V :source ~/.vimrc<CR>:filetype detect<CR>:exe ":echo 'vimrc reloaded'"<CR>

" open/close the quickfix window
nmap <leader>c :copen<CR>
nmap <leader>cc :cclose<CR>

" ctrl-hjkl to navigate between split buffers
map <c-j> <c-w>j
map <c-k> <c-w>k
map <c-l> <c-w>l
map <c-h> <c-w>h
imap <C-W> <C-O><C-W>

" Undo tree (mundo is the maintained gundo fork; same mapping)
map <leader>g :MundoToggle<CR>

" Set working directory to directory of file being edited
nnoremap <leader>. :lcd %:p:h<CR>

" Paste from system clipboard
map <leader>p "+p

" Quit window
nnoremap <leader>q :q<CR>

" Hide search matches
nnoremap <leader><space> :nohlsearch<cr>

" Remove trailing whitespace
nnoremap <leader>S :%s/\s\+$//<cr>:let @/=''<CR>

" Select the item in the completion list with enter
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Cycle through open buffers
nnoremap <leader>n :bnext<CR>
nnoremap <leader>N :bprevious<CR>

" ==========================================================
" Basic Settings
" ==========================================================
syntax on
set number
set title
set wildmenu
set wildmode=full

set noerrorbells
set vb t_vb=

set wildignore+=*.o,*.obj,.git,*.pyc
set wildignore+=eggs/**
set wildignore+=*.egg-info/**

""" Moving Around/Editing
set cursorline
set ruler
set nostartofline
set virtualedit=block
set scrolloff=3
set backspace=2
set showmatch
set wrap
set linebreak
set autoindent
set smartindent
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set shiftround
set formatoptions=tcroql
set linespace=3

"""" Reading/Writing
set autowrite
set autowriteall
set noautoread
set modeline
set modelines=5
set nofoldenable

"""" Messages, Info, Status
set ls=2
set showcmd
set report=0
set shortmess+=a
set laststatus=2

""" Searching and Patterns
set ignorecase
set smartcase
set hlsearch
set incsearch

" Colors
set background=dark
silent! colorscheme molokai
if !exists('g:colors_name') | colorscheme slate | endif

" No swapfiles; persistent undo in one place
set noswapfile
if exists("+undofile")
  if isdirectory($HOME . '/.vim/undo') == 0
    silent !mkdir -p ~/.vim/undo > /dev/null 2>&1
  endif
  set undodir=~/.vim/undo//
  set undofile
endif

" Make diffs really obvious
hi DiffText gui=underline guibg=red guifg=black

" ctrlp: search by full path, ignore the usual noise
let g:ctrlp_by_filename = 0
let g:ctrlp_custom_ignore = '\v[\/](\.git|node_modules|__pycache__|\.venv|target)$'
if executable('rg')
  let g:ctrlp_user_command = 'rg %s --files --color=never --glob ""'
  let g:ctrlp_use_caching = 0
endif

" Preview Markdown files with QuickLook
map <Leader>v :write<cr>:sil !/usr/bin/qlmanage -p % > /dev/null &<cr>:redraw!<cr>

set guifont=Source\ Code\ Pro:h14
