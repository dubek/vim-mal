nnoremap <buffer> <leader>m :MalEvalRangeAdd<cr>
vnoremap <buffer> <leader>m :MalEvalRangeAdd<cr>

" Continue defining the Mal commands if not yet loaded
if exists("g:did_mal_eval_ftplugin")
    finish
endif
let g:did_mal_eval_ftplugin = 1

runtime! ftplugin/interpreter/stepA_mal.vim

" Copied from xolox's answer: http://stackoverflow.com/a/6271254/884 (public domain)
function! s:get_visual_selection()
  " Why is this not a built-in Vim script function?!
  let [lnumv, colv] = getpos("v")[1:2]
  let [lnum1, col1] = getpos("'<")[1:2]
  let [lnum2, col2] = getpos("'>")[1:2]
  if (lnum1 == 0 && lnum2 == 0) || (lnumv != lnum1)
    return -1
  endif
  let lines = getline(lnum1, lnum2)
  let lines[-1] = lines[-1][: col2 - (&selection == 'inclusive' ? 1 : 2)]
  let lines[0] = lines[0][col1 - 1:]
  return join(lines, "\n")
endfunction

function! MalEvalStr(str)
  try
    return(REP(a:str, g:Repl_env))
  catch
    return("Error: " . v:exception)
  endtry
endfunction

function! MalEvalExpr(str)
  echo MalEvalStr(a:str)
endfunction
command! -nargs=1 MalEvalExpr call MalEvalExpr(<q-args>)

function! MalEvalRange(line1, line2)
  let vis_text = s:get_visual_selection()
  if vis_text == -1
    let vis_text = join(getline(a:line1, a:line2), "\n")
  endif
  call MalEvalExpr(vis_text)
endfunction
command! -range MalEvalRange call MalEvalRange(<line1>, <line2>)

function! MalEvalRangeAdd(line1, line2)
  let vis_text = s:get_visual_selection()
  if vis_text == -1
    let vis_text = join(getline(a:line1, a:line2), "\n")
  endif
  call cursor(a:line2, 0)
  put =(';=>' . MalEvalStr(vis_text))
endfunction
command! -range MalEvalRangeAdd call MalEvalRangeAdd(<line1>, <line2>)
