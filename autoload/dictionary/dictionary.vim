" Title: vim-dictionary
" Description: Word definition lookup in a pop-up window
" Maintainer: Ivan <https://github.com/ajvn>
if exists("g:loaded_dictionary")
    finish
endif

let g:loaded_dictionary = 1

function s:popwin(def) abort
    call popup_clear()
    call popup_atcursor(split(a:def, '\n'), {
                \ 'padding': [1,1,1,1],
                \ 'border': [1,1,1,1],
                \ })
endfunction

function dictionary#dictionary#define() abort
    let l:cursor = expand("<cword>")
    if exists("b:word_dictionary")
        let l:comm = "dict -d " . b:word_dictionary . " "
        let l:definition = system(l:comm . l:cursor)
    else
        let l:definition = system("dict -d wn " . l:cursor)
    endif
    call s:popwin(l:definition)
endfunction

function dictionary#dictionary#defineoffline() abort
    let l:cursor = expand("<cword>")
    let l:definition = system("dict -h localhost " . l:cursor)
    call s:popwin(l:definition)
endfunction
