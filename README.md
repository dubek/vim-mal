# vim-mal

[Mal](https://github.com/kanaka/mal) (Make-a-Lisp) support for Vim.


## Features

* Syntax highlighting
* Auto indentation
* Mal code evaluation inside Vim (using the Vimscript Mal implementation)


## Installation

Like any other vim plugin (use your favourite plugin manager).


## Usage

Files with `.mal` extension will be automatically syntax-highlighted for Mal
(`filtype=mal`), get the Mal indentation rules and the Mal code evaluation
commands.


### Mal code evaluation

#### Evaluate an expression on the command line

Use the `:MalEvalExpr EXPR` command to evaluate an expression in the Vim
command line.  The result will be displayed in the command line area as well:

    :MalEvalExpr (* 5 (+ 2 4))

will display `30`.


#### Evaluate an expression from the buffer

Move the cursor to the line you wish to evaluate, or mark a visual block with
the expression you wish to evaluate, and type `:MalEvalRange`.  The result will
be displayed in the command line area.


#### Evaluate one line in the buffer and add result in the buffer

Move the cursor to the line you wish to evaluate, and press `\m` (`<leader>m`)
to run the `:MalEvalRangeAdd` command.  A line with the result will be added
below the cursor:

    (* 5 (+ 2 4))   ; Cursor on this run when pressing \m
    ;=>30           ; This line is added by vim-mal


#### Evaluate a visual block in the buffer and add result in the buffer

Mark a visual block with the Mal expression you wish to evaluate, and press
`\m` (`<leader>m`) to run the `:MalEvalRangeAdd` command.  A line with the
result will be added below the visual block:

    (let* [a (* 2 4)      ; Mark these three
           b (+ a 10)]    ; lines as a
      (+ a b))            ; visual block
    ;=>26                 ; This line is added by vim-mal


## Credits

* Joel Martin for the Mal project.
* Authors of the vimclojure plugin; vim-mal is heavily based on (= copied from)
  vimclojure.


## License

vim-mal is licensed under the MPL 2.0 (Mozilla Public License 2.0). See
`LICENSE` for more details.
