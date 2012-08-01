""""""""""""""""""" PLUGINS
set nocompatible 
filetype off

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'gmarik/vundle'
Bundle 'tsaleh/vim-matchit'
Bundle 'The-NERD-Commenter'
Bundle 'scrooloose/nerdtree'
Bundle 'Lokaltog/vim-powerline'
Bundle 'vim-scripts/Wombat'

"""""""""""""""""""" GLOBAL
" Misc
syntax on
filetype plugin indent on

let mapleader=","
colorscheme wombat

set backup
set backupdir=/tmp/vim,/tmp
set noswapfile
set undofile
set undolevels=1000
set undodir=~/.vim/undodir,/tmp
au FocusLost * :wa

set encoding=utf-8
set hidden
set showcmd

set mouse=
set history=1000
set visualbell
set noerrorbells
set ttyfast
set fileformats=unix,dos,mac
set laststatus=2
set scrolloff=4

" Look
set number
set nowrap
set cursorline 
set ruler
set list listchars=tab:>.,trail:.,extends:#,nbsp:.

" Tabs and indentation
set expandtab
set softtabstop=2 tabstop=2 shiftwidth=2
set shiftround
set backspace=indent,eol,start
set autoindent
set copyindent
set smartindent

" Search
set incsearch
set hlsearch
set ignorecase smartcase
set infercase

" Completion
set dictionary-=/usr/share/dict/words dictionary+=/usr/share/dict/words
set complete-=k complete+=k
set wildignore=*.swp,*.bak
set wildmode=longest,list


"""""""""""""""""""" KEYBINDINGS
inoremap <Left>  <NOP>
inoremap <Right> <NOP>
inoremap <Up>    <NOP>
inoremap <Down>  <NOP>
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>

inoremap () ()<Left>
inoremap [] []<Left>
inoremap '' ''<Left>
inoremap "" ""<Left>
inoremap {} {}<Left>

inoremap jj <ESC>
inoremap jk <ESC>
nnoremap ; :

map cc <leader>c<space>
map  <F6> :setlocal spell! spelllang=en<CR>
cmap w!! w !sudo tee % >/dev/null<CR>:e!<CR><CR>
nmap <c-b> :NERDTreeToggle<cr>

"""""""""""""""""""" PLUGINS
let g:Powerline_symbols = 'fancy'
let g:NERDTreeWinPos = "right"
let NERDChristmasTree = 1
let NERDTreeSortOrder = ['\/$', '\.js*', '\.cpp$', '\.h$', '*']

"""""""""""""""""""" CUSTOM FUNCTIONS
""" Toggle relative/absolute numbering
function! NumberToggle()
  if(&relativenumber == 1)
    set number
  else
    set relativenumber
  endif
endfunc
nnoremap <F10> :call NumberToggle()<cr>


""" Autocomplete on tab
function! Tab_Or_Complete()
  if col('.')>1 && strpart( getline('.'), col('.')-2, 3 ) =~ '^\w'
    return "\<C-N>"
  else
    return "\<Tab>"
  endif
endfunc
inoremap <tab> <C-R>=Tab_Or_Complete()<CR>
inoremap <s-tab> <c-p>
