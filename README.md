
                       ██╗   ██╗██╗███╗   ███╗
                       ██║   ██║██║████╗ ████║
                       ██║   ██║██║██╔████╔██║
                       ╚██╗ ██╔╝██║██║╚██╔╝██║
                        ╚████╔╝ ██║██║ ╚═╝ ██║
                         ╚═══╝  ╚═╝╚═╝     ╚═╝

    ██████╗ ██╗ ██████╗████████╗██╗ ██████╗ ███╗   ██╗ █████╗ ██████╗ ██╗   ██╗
    ██╔══██╗██║██╔════╝╚══██╔══╝██║██╔═══██╗████╗  ██║██╔══██╗██╔══██╗╚██╗ ██╔╝
    ██║  ██║██║██║        ██║   ██║██║   ██║██╔██╗ ██║███████║██████╔╝ ╚████╔╝
    ██║  ██║██║██║        ██║   ██║██║   ██║██║╚██╗██║██╔══██║██╔══██╗  ╚██╔╝
    ██████╔╝██║╚██████╗   ██║   ██║╚██████╔╝██║ ╚████║██║  ██║██║  ██║   ██║
    ╚═════╝ ╚═╝ ╚═════╝   ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝

## Vim-dictionary
Definition of English word printed in a pop-up window.

## What does it do?
Looks up English word under cursor in the WordNet dictionary.  
Uses `dict`, a DICT protocol client.

![vim-dictionary](./media/vim-dictionary.gif)

## About
Vim-dictionary plugin was created out of author's need to quickly look up
definition of specific English words while reading a book or technical
documentation.

It provides a single function that does just that, and utilizes excellent DICT
protocol client `dict`.

As author exclusively uses Linux, current implementation is meant to work only
on that platform.
Users are free to try using it on Darwin or other platforms, but that has not
been tested.

## Installation
Prerequisites:
* `dict` binary:
  - Fedora: https://src.fedoraproject.org/rpms/dictd
  - Ubuntu: https://manpages.ubuntu.com/manpages/bionic/man1/dict.1.html
  - Arch:   https://archlinux.org/packages/?name=dictd
* Internet connection

Installation relies on vim-plug system:
* [vim-plug](https://github.com/junegunn/vim-plug)

Steps:
* Add following line to your `.vimrc` configuration file: 
```
Plug 'ajvn/vim-dictionary'
```
* Open Vim and execute:
```
:PlugInstall " Installs plugins defined in the .vimrc
or
:PlugUpdate  " Installs and/or updates plugins defined in .vimrc
```

## Usage
No mapping is provided, use function `:WordDefinition` to find under-cursor
word definition.

Alternatively, create mappings of your own liking.

Example:
```
" Enables plugin when working in text or markdown files:
$EDITOR .vimrc
    let mapleader=';'
    augroup word_definition
    :   autocmd!
    :   autocmd FileType markdown,text
            \ nmap <leader>wd :WordDefinition<CR>
    augroup END
```

In Vim normal mode use `<;-wd>` to get definition pop-up.

## Reference & Credit
Knowledge base which helped author of this plugin learn how to somewhat deal
with beast such as VimScript and general mentions:
* Authors of following plugins:
  - [vim-plug](https://github.com/junegunn/vim-plug)
  - [vim-go](https://github.com/fatih/vim-go)
* Author of following book on the topic of VimScript
  - [Learn VimScript The Hard Way](https://learnvimscriptthehardway.stevelosh.com)
* ASCII Font
  - ansishadow
