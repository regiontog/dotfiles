augroup custom
  au!
  au FocusLost * :wa

  au VimResized * :wincmd =

  au BufWritePost .vimrc source $MYVIMRC
  au BufWritePost *.vim source $MYVIMRC

  let g:clean_whitespace = 1
  au BufWritePre *
        \ if g:clean_whitespace                     |
        \   call  functions#InPlace('%s/\s\+$//e')  |
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
