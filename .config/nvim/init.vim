" Must be set before ALE is loaded
let g:ale_completion_enabled = 1

call plug#begin()
Plug 'machakann/vim-highlightedyank'
Plug 'tpope/vim-commentary'
Plug 'tommcdo/vim-exchange'
Plug 'vim-scripts/argtextobj.vim'
Plug 'tpope/vim-surround'
Plug 'dense-analysis/ale'
call plug#end()

" ALE
" https://github.com/dense-analysis/ale
" Trigger completion manually with <C-x><C-o>
set omnifunc=ale#completion#OmniFunc
" /ALE

" Make the current working directory follow the active buffer
set autochdir

set scrolloff=5
set incsearch
set shiftwidth=2 smarttab

" Use spaces instead of tabs for auo-indentation
set expandtab

" Lets you use the mouse
set mouse=a

set number relativenumber
