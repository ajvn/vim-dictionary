" Title: vim-dictionary
" Description: Word definition lookup in a pop-up window
" Maintainer: Ivan <https://github.com/ajvn>
command WordDefinition call dictionary#dictionary#define()
command WordDefinitionOfflineDictionary call dictionary#dictionary#defineoffline()
