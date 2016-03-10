" Vim filetype plugin file
"
" Based on vimclojure's ftplugin file.

" Only do this when not done yet for this buffer
if exists("b:did_ftplugin")
    finish
endif
let b:did_ftplugin = 1

let s:cpo_save = &cpo
set cpo&vim

let b:undo_ftplugin = 'setlocal define< formatoptions< comments< commentstring<'

" There will be false positives, but this is better than missing the whole set
" of user-defined def* definitions.
setlocal define=\\v[(/]def(ault)@!\\S*

" Remove 't' from 'formatoptions' to avoid auto-wrapping code. The '+=croql'
" is standard ftplugin boilerplate, although it is arguably intrusive.
setlocal formatoptions-=t formatoptions+=croql

" Lisp comments are routinely nested (e.g. ;;; SECTION HEADING)
setlocal comments=n:;
setlocal commentstring=;\ %s

" Skip brackets in ignored syntax regions when using the % command
if exists('loaded_matchit')
    let b:match_words = &matchpairs
    let b:match_skip = 's:comment\|string\|regex\|character'
    let b:undo_ftplugin .= ' | unlet! b:match_words b:match_skip'
endif

let &cpo = s:cpo_save

unlet! s:cpo_save s:setting s:dir

" runtime! ftplugin/mal_eval.vim

" vim:sts=4 sw=4 et:
