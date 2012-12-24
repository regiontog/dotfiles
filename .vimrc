set nocompatible

" Environment
set rtp=$XDG_CONFIG_HOME/vim,$XDG_CONFIG_HOME/vim/after,$VIMRUNTIME

" Source the config files
runtime! config/**/*.vim

" Look and feel
syntax on
filetype plugin indent on
colorscheme lucius

set mouse=
set t_Co=256
set number
set nowrap
set cursorline
set splitbelow
set ruler

set hidden
set showcmd
set visualbell
set noerrorbells
set ttyfast
set nottybuiltin

set cmdheight=1
set laststatus=2
set scrolloff=4
set sidescroll=4

set formatoptions=croqn
set linebreak showbreak=+>
set diffopt=filler,vertical,iwhite
set list listchars=tab:‣.,trail:.,extends:>,nbsp:.
set fillchars=vert:│

" Tabs and indentation
set expandtab
set softtabstop=4 tabstop=4 shiftwidth=4
set shiftround
set backspace=indent,eol,start
set autoindent
set copyindent
set smartindent
set switchbuf=useopen,usetab

" Search
set incsearch nohlsearch
set ignorecase smartcase
set infercase

" Saving
set backup
set undofile
set backupdir=~/.vim/tmp//,/tmp/vim//,/tmp//
set undodir=~/.vim/undodir//,/tmp/vimundo//,/tmp//
set undolevels=1000
set history=1000
set noswapfile
set viminfo=""


" Completion
set complete=.,w,b,u,t,i,kspell
set completeopt=menu,longest
set wildignore=*.swp,*.bak
set wildmenu
set wildmode=list:longest,full

" Files
set autoread autowrite
set encoding=utf-8
set fileformats=unix,dos,mac
