function! functions#NumberToggle()
  if(&relativenumber == 1)
    set number
  else
    set relativenumber
  endif
endfunc

" Execute a command, leaving the cursor on the current line
function! functions#InPlace(command)
  let saved_view = winsaveview()
  exe a:command
  call winrestview(saved_view)
endfunction

" Move lines
function! functions#MoveLineUp()
    call <SID>MoveLineOrVisualUp(".", "")
endfunction

function! functions#MoveLineDown()
    call <SID>MoveLineOrVisualDown(".", "")
endfunction

function! functions#MoveVisualUp()
    call <SID>MoveLineOrVisualUp("'<", "'<,'>")
    normal gv
endfunction

function! functions#MoveVisualDown()
    call <SID>MoveLineOrVisualDown("'>", "'<,'>")
    normal gv
endfunction

function! s:MoveLineOrVisualUp(line_getter, range)
    let l_num = line(a:line_getter)
    if l_num - v:count1 - 1 < 0
        let move_arg = "0"
    else
        let move_arg = a:line_getter." -".(v:count1 + 1)
    endif
    call <SID>MoveLineOrVisualUpOrDown(a:range."move ".move_arg)
endfunction

function! s:MoveLineOrVisualDown(line_getter, range)
    let l_num = line(a:line_getter)
    if l_num + v:count1 > line("$")
        let move_arg = "$"
    else
        let move_arg = a:line_getter." +".v:count1
    endif
    call <SID>MoveLineOrVisualUpOrDown(a:range."move ".move_arg)
endfunction

function! s:MoveLineOrVisualUpOrDown(move_arg)
    let col_num = virtcol(".")
    execute "silent! ".a:move_arg
    execute "normal! ".col_num."|"
endfunction
