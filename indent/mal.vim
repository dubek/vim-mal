" Vim indent file
"
" Based on (=copied from) vimclojure indent file

" Only load this indent file when no other was loaded.
if exists("b:did_indent")
    finish
endif
let b:did_indent = 1

let s:save_cpo = &cpo
set cpo&vim

let b:undo_indent = 'setlocal autoindent< smartindent< lispwords< expandtab< softtabstop< shiftwidth< indentexpr< indentkeys<'

setlocal noautoindent nosmartindent
setlocal softtabstop=2 shiftwidth=2 expandtab
setlocal indentkeys=!,o,O

if exists("*searchpairpos")

    if !exists('g:mal_match_maxlines')
        let g:mal_match_maxlines = 100
    endif

    function! s:SynIdName()
        return synIDattr(synID(line("."), col("."), 0), "name")
    endfunction

    function! s:CurrentChar()
        return getline('.')[col('.')-1]
    endfunction

    function! s:CurrentWord()
        return getline('.')[col('.')-1 : searchpos('\v>', 'n', line('.'))[1]-2]
    endfunction

    function! s:IsParen()
        return s:CurrentChar() =~ '\v[\(\)\[\]\{\}]' &&
             \ s:SynIdName() !~? '\vstring|comment'
    endfunction

    function! s:MatchPairs(open, close, stopat)
        " Stop only on vector and map [ resp. {. Ignore the ones in strings and
        " comments.
        if a:stopat == 0
            let stopat = max([line(".") - g:mal_match_maxlines, 0])
        else
            let stopat = a:stopat
        endif

        let pos = searchpairpos(a:open, '', a:close, 'bWn', "!s:IsParen()", stopat)
        return [pos[0], virtcol(pos)]
    endfunction

    function! GetMalIndent()
        " Get rid of special case.
        if line(".") == 1
            return 0
        endif

        call cursor(0, 1)

        " Find the next enclosing [ or {. We can limit the second search
        " to the line, where the [ was found. If no [ was there this is
        " zero and we search for an enclosing {.
        let paren = s:MatchPairs('(', ')', 0)
        let bracket = s:MatchPairs('\[', '\]', paren[0])
        let curly = s:MatchPairs('{', '}', bracket[0])

        " In case the curly brace is on a line later then the [ or - in
        " case they are on the same line - in a higher column, we take the
        " curly indent.
        if curly[0] > bracket[0] || curly[1] > bracket[1]
            if curly[0] > paren[0] || curly[1] > paren[1]
                return curly[1]
            endif
        endif

        " If the curly was not chosen, we take the bracket indent - if
        " there was one.
        if bracket[0] > paren[0] || bracket[1] > paren[1]
            return bracket[1]
        endif

        " There are neither { nor [ nor (, ie. we are at the toplevel.
        if paren == [0, 0]
            return 0
        endif

        " Now we have to reimplement lispindent. This is surprisingly easy, as
        " soon as one has access to syntax items.
        "
        " - Get the next keyword after the (.
        " - If its first character is also a (, we have another sexp and align
        "   one column to the right of the unmatched (.
        " - In case it is in lispwords, we indent the next line to the column of
        "   the ( + sw.
        " - If not, we check whether it is last word in the line. In that case
        "   we again use ( + sw for indent.
        " - In any other case we use the column of the end of the word + 2.
        call cursor(paren)

        " In case we are at the last character, we use the paren position.
        if col("$") - 1 == paren[1]
            return paren[1]
        endif

        " In case after the paren is a whitespace, we search for the next word.
        normal! l
        if s:CurrentChar() == ' '
            normal! w
        endif

        " If we moved to another line, there is no word after the (. We
        " use the ( position for indent.
        if line(".") > paren[0]
            return paren[1]
        endif

        " We still have to check, whether the keyword starts with a (, [ or {.
        " In that case we use the ( position for indent.
        let w = s:CurrentWord()
        if stridx('([{', w[0]) > -1
            return paren[1]
        endif

        if &lispwords =~ '\V\<' . w . '\>'
            return paren[1] + &shiftwidth - 1
        endif

        normal! W
        if paren[0] < line(".")
            return paren[1] + &shiftwidth - 1
        endif

        normal! ge
        return virtcol(".") + 1
    endfunction

    setlocal indentexpr=GetMalIndent()

else

    " In case we have searchpairpos not available we fall back to
    " normal lisp indenting.
    setlocal indentexpr=
    setlocal lisp
    let b:undo_indent .= '| setlocal lisp<'

endif

setlocal lispwords=
setlocal lispwords+=def!
setlocal lispwords+=defmacro!
setlocal lispwords+=fn*
setlocal lispwords+=let*
setlocal lispwords+=cond
setlocal lispwords+=if
setlocal lispwords+=catch*
setlocal lispwords+=try*

let &cpo = s:save_cpo
unlet! s:save_cpo

" vim:sts=4 sw=4 et:
