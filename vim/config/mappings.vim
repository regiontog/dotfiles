" Leader
let mapleader=","

" Commands
cmap w!! w !sudo tee % >/dev/null<CR>:e!<CR><CR>

" Normal mode
nnoremap ; :
nnoremap : ;

nnoremap gh <C-w>h
nnoremap gj <C-w>j
nnoremap gk <C-w>k
nnoremap gl <C-w>l
nnoremap ss <C-w>s
nnoremap vv <C-w>v

nnoremap 0 ^

nnoremap J 5j
nnoremap K 5k
nnoremap H ^
nnoremap L $

nnoremap t m`o<Esc>``
nnoremap T m`O<Esc>``

nnoremap <C-l> gt
nnoremap <C-h> gT

nnoremap <leader>bd  :ls<CR>:bd<Space>
nnoremap <leader>bs  :ls<CR>:b<Space>
nnoremap <leader>p   :set paste!<CR>
nnoremap <leader>sc  :setlocal spell! spelllang=en<CR>
nnoremap <leader>rn  :call functions#NumberToggle()<CR>

nnoremap <silent> <Left>  <<
nnoremap <silent> <Right> >>
nnoremap <silent> <Up>    <Esc>:call functions#MoveLineUp()<CR>
nnoremap <silent> <Down>  <Esc>:call functions#MoveLineDown()<CR>

"Clear anoying whitespace
nnoremap <leader>W  :call functions#InPlace('%s/\s\+$//e')<CR>


" Visual mode
vnoremap J 5j
vnoremap K 5k
vnoremap H ^
vnoremap L $

vnoremap <silent> <Left>  <gv
vnoremap <silent> <Right> >gv
vnoremap <silent> <Up>    <Esc>:call functions#MoveVisualUp()<CR>
vnoremap <silent> <Down>  <Esc>:call functions#MoveVisualDown()<CR>


" Insert mode
inoremap jj <ESC>
inoremap jk <ESC>

inoremap <silent> <Left>  <C-D>
inoremap <silent> <Right> <C-T>
inoremap <silent> <Up>    <C-O>:call functions#MoveLineUp()<CR>
inoremap <silent> <Down>  <C-O>:call functions#MoveLineDown()<CR>
