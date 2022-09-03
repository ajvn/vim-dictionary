" Title: vim-dictionary
" Description: Word definition lookup in a pop-up window
" Maintainer: Ivan <https://github.com/ajvn>
if exists("g:loaded_dictionary")
    finish
endif

let g:loaded_dictionary = 1

function dictionary#dictionary#define() abort
    let l:cursor = expand("<cword>")
    let l:definition = system("dict -d wn " . l:cursor)
    call popup_clear()
    call popup_atcursor(split(l:definition, '\n'), {
                \ 'padding': [1,1,1,1],
                \ 'border': [1,1,1,1],
                \ })
endfunction
