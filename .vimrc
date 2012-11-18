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
Bundle 'vim-scripts/Lucius'

"""""""""""""""""""" GLOBAL
" Misc
syntax on
filetype plugin indent on

let mapleader=","
colorscheme andrew

" Look and feel
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
set list listchars=tab:>.,trail:.,extends:#,nbsp:.

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
set backupdir=~/.vim/backup,/tmp/vim,/tmp
set undodir=~/.vim/undodir,/tmp/vimundo,/tmp
set undolevels=1000
set history=1000
set noswapfile
set viminfo+=!

" Completion
set complete=.,w,b,k
set completeopt=menuone,longest
set wildignore=*.swp,*.bak
set wildmenu
set wildmode=list:longest,full

" Files
set autoread autowrite
set encoding=utf-8
set fileformats=unix,dos,mac


"""""""""""""""""""" KEYBINDINGS
nmap ; :

imap jj <ESC>
imap jk <ESC>

inoremap <Left>  <NOP>
inoremap <Right> <NOP>
inoremap <Up>    <NOP>
inoremap <Down>  <NOP>

nnoremap <Up>    <NOP>
nnoremap <Down>  <NOP>
nnoremap <Left>  <NOP>
nnoremap <Right> <NOP>

inoremap () ()<Left>
inoremap [] []<Left>
inoremap '' ''<Left>
inoremap "" ""<Left>
inoremap {} {}<Left>

nnoremap gh <C-w>h
nnoremap gj <C-w>j
nnoremap gk <C-w>k
nnoremap gl <C-w>l

nmap J 5j
nmap K 5k
xmap J 5j
xmap K 5k

nnoremap <C-l> gt
nnoremap <C-h> gT

nnoremap 0 ^

nnoremap ! :Run<cr>
xnoremap ! :Run<cr>

map cc <leader>c<space>
map <F6> :setlocal spell! spelllang=en<CR>
cmap w!! w !sudo tee % >/dev/null<CR>:e!<CR><CR>
nmap <c-b> :NERDTreeToggle<cr>

command! CleanWhitespace call lib#InPlace('%s/\s\+$//e')

"""""""""""""""""""" AUTOCOMMANDS
augroup custom
  au!
  au FocusLost * :wa

  let g:clean_whitespace = 1
  au BufWritePre *
        \ if g:clean_whitespace   |
        \   exe "CleanWhitespace" |
        \ endif

  au BufEnter *.c    compiler gcc
  au BufEnter *.cpp  compiler gcc
  au BufEnter *.php  compiler php
  au BufEnter *.html compiler tidy
  au BufEnter *.xml  compiler eclim_xmllint
  au BufEnter *.js   compiler jsl

  au BufEnter *.hsc  set filetype=haskell
  au BufEnter *.tags set filetype=tags
augroup END

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
inoremap <Tab> <C-R>=Tab_Or_Complete()<CR>
inoremap <S-Tab> <C-p>
