filetype indent plugin on

syntax on

set hidden

set wildmenu

set showcmd
set showmatch

set incsearch
set hlsearch

set ignorecase
set smartcase

set backspace=indent,eol,start

set autoindent
set ruler
set laststatus=2
set confirm
set visualbell
set mouse=a
set cmdheight=2

set number

set pastetoggle=<F11>
set clipboard=unnamed

set shiftwidth=4
set softtabstop=4
set expandtab

let &t_SI = "\<Esc>]50;CursorShape=1\x7"
let &t_EI = "\<Esc>]50;CursorShape=0\x7"

map ^[[D <left>
map ^[[A <up>
map ^[[B <down>
map ^[[C <right>

map Y y$

nnoremap <C-L> :nohl<CR><C-L>
