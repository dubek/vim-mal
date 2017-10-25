" Vim syntax file
"
" Based on vimclojure synatx file

if version < 600
    syntax clear
elseif exists("b:current_syntax")
    finish
endif

setlocal iskeyword+=?,-,*,!,+,/,=,<,>,.,:,$

syntax keyword malConstant nil
syntax keyword malBoolean false true
syntax keyword malSpecial do fn* if let* quote quasiquote unquote splice-unquote
syntax keyword malException catch* throw try*
syntax keyword malCond cond
syntax keyword malRepeat map
syntax keyword malDefine def! defmacro!
syntax keyword malMacro -> ->> and cond or
syntax keyword malFunc * + - / = < <= > >= nil? true? false? symbol symbol? string? keyword keyword? number? fn? macro? pr-str str prn println readline read-string slurp eval list list? vector vector? hash-map map? assoc dissoc get contains? keys vals sequential? cons concat nth first rest empty? count apply map conj seq with-meta meta atom atom? deref reset! swap!
syntax keyword malVariable *ARGV*

" Keywords are symbols:
"   static Pattern symbolPat = Pattern.compile("[:]?([\\D&&[^/]].*/)?([\\D&&[^/]][^/]*)");
" But they:
"   * Must not end in a : or /
"   * Must not have two adjacent colons except at the beginning
"   * Must not contain any reader metacharacters except for ' and #
syntax match malKeyword "\v:{1,2}%([^ \n\r\t()\[\]{}";@^`~\\%/]+/)*[^ \n\r\t()\[\]{}";@^`~\\%/]+:@<!"

syntax region malString start=/L\="/ skip=/\\\\\|\\"/ end=/"/

let s:radixChars = "0123456789abcdefghijklmnopqrstuvwxyz"
for s:radix in range(2, 36)
    execute 'syntax match malNumber "\c\<-\?' . s:radix . 'r[' . strpart(s:radixChars, 0, s:radix) . ']\+\>"'
endfor
unlet! s:radixChars s:radix

syntax match malNumber "\<-\=[0-9]\+\(\.[0-9]*\)\=\(M\|\([eE][-+]\?[0-9]\+\)\)\?\>"
syntax match malNumber "\<-\=[0-9]\+N\?\>"
syntax match malNumber "\<-\=0x[0-9a-fA-F]\+\>"
syntax match malNumber "\<-\=[0-9]\+/[0-9]\+\>"

syntax match malVarArg "&"

syntax match malQuote "'"
syntax match malQuote "`"
syntax match malUnquote "\~"
syntax match malUnquote "\~@"
syntax match malMeta "\^"
syntax match malDeref "@"

syntax match malComment ";.*$" contains=malTodo,@Spell

syntax keyword malTodo contained FIXME XXX TODO FIXME: XXX: TODO:

syntax region malSexp   matchgroup=malParen start="("  matchgroup=malParen end=")"  contains=TOP,@Spell
syntax region malVector matchgroup=malParen start="\[" matchgroup=malParen end="\]" contains=TOP,@Spell
syntax region malMap    matchgroup=malParen start="{"  matchgroup=malParen end="}"  contains=TOP,@Spell

" Highlight superfluous closing parens, brackets and braces.
syntax match malError "]\|}\|)"

syntax sync fromstart

if version >= 600
    command -nargs=+ HiLink highlight default link <args>
else
    command -nargs=+ HiLink highlight link <args>
endif

HiLink malConstant  Constant
HiLink malBoolean   Boolean
HiLink malKeyword   Keyword
HiLink malNumber    Number
HiLink malString    String

HiLink malVariable  Identifier
HiLink malCond      Conditional
HiLink malDefine    Define
HiLink malException Exception
HiLink malFunc      Function
HiLink malMacro     Macro
HiLink malRepeat    Repeat

HiLink malSpecial   Special
HiLink malVarArg    Special
HiLink malQuote     SpecialChar
HiLink malUnquote   SpecialChar
HiLink malMeta      SpecialChar
HiLink malDeref     SpecialChar

HiLink malComment   Comment
HiLink malTodo      Todo

HiLink malError     Error

HiLink malParen     Delimiter

delcommand HiLink

let b:current_syntax = "mal"

" vim:sts=4 sw=4 et:
