
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
Looks up English word under cursor in the dictionary.
Uses `dict`, a DICT protocol client.

![vim-dictionary](./media/vim-dictionary.gif)

## About
Vim-dictionary plugin was created out of the need to quickly look up definition
of specific English words while reading a book or technical documentation.

It uses WordNet dictionary by default, however this option is configurable.

Current implementation has been tested on various Linux distributions and
MacOS.

## Installation
Prerequisites:
* `dict` binary:
  - Fedora: https://src.fedoraproject.org/rpms/dictd
  - Ubuntu: https://manpages.ubuntu.com/manpages/bionic/man1/dict.1.html
  - Arch:   https://archlinux.org/packages/?name=dictd
* Internet connection (steps are available for
[offline dictionary setup](#offline-dictionary))

Installation relies on `vim-plug` system:
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

#### Offline dictionary
It is possible to setup offline dictionary, depending on your platform this
might be more or less straightforward. Focus in these examples is on WordNet
dictionary, but you are free to use any others you might like better.

Support relies on `dictd` package which provides local (or publicly exposed
self-hosted server if that's something you'd like to host) `dict` server.

* Use `WordDefinitionOfflineDictionary` function to use offline dictionary
running on your machine.

###### Ubuntu
* Install `dictd` package:
```bash
$ sudo apt install dictd
```
* Install WordNet dictionary:
```bash
$ sudo apt install dict-wn
```
* Check if `dictd.service` is running:
```bash
$ systemctl status dictd.service
```
* (Optional) Test if `dict` works properly:
```bash
$ dict dictionary
1 definition found

From WordNet (r) 3.0 (2006) [wn]:

  dictionary
      n 1: a reference book containing an alphabetical list of words
           with information about them [syn: {dictionary}, {lexicon}]
```
* (Optional) Disable internet connection and try searching for word definition
in Vim.

###### Fedora
Fedora doesn't provide dictionaries that can be used by `dict` via package
manager. This means you'll have to download dictionaries you want, package them
in format `dict` understands and configure `dictd` to serve database and index.

Approach taken in this example uses `.deb` package downloaded on Ubuntu box,
extracted via `dpkg-deb` and copied on Fedora box.

If you decide to package dictionaries yourself, take a look into options that
`dictfmt` and `dictzip` provide.

* (Ubuntu box) Download `dict-wn` package:
```bash
$ apt update && apt download dict-wn
```
* (Ubuntu box) Extract `.deb` package (package version you download may be
different):
```bash
$ mkdir -p /tmp/dict && dpkg-deb -R dict-wn_1%3a3.0-36_all.deb /tmp/dict
```
* (Ubuntu box) Copy extracted files to Fedora box, namely:
  - `/tmp/dict/usr/share/dictd/wn.dict.dz`
  - `/tmp/dict/usr/share/dictd/wn.index`
* (Fedora box) Install `dictd` package:
```bash
$ sudo dnf install dictd-server
```
* (Fedora box) Create directory in which you wish to save dictionary files:
```bash
$ sudo mkdir -p /usr/lib/dict
```
* (Fedora box) Copy files and change ownership to `dictd` user/group:
```bash
$ sudo cp <source>/wn.* /usr/lib/dict
$ sudo chown -R dictd:dictd /usr/lib/dict
```
* (Fedora box) Make sure files are readable:
```bash
$ sudo chmod 0644 /usr/lib/dict/wn.*
```
* (Fedora box) Set SELinux file context map definition for all of the
dictionary files you might have:
```bash
$ cd /usr/lib/dict
$ sudo semanage fcontext -a -t dictd_etc_t 'wn.dict.dz' && \
      sudo restorecon -v 'wn.dict.dz'
$ sudo semanage fcontext -a -t dictd_etc_t 'wn.index' && \
      sudo restorecon -v 'wn.index'
$ cd -
```
* (Fedora box) Adjust `dictd` configuration to point to dictionary files:
```bash
$ sudo $EDITOR /etc/dictd.conf
global {
   listen_to 127.0.0.1
}

database wnoffline {
   data "/usr/lib/dict/wn.dict.dz"
   index "/usr/lib/dict/wn.index"
}
```
* (Fedora box) Start `dictd` service and check if it's running properly:
```bash
$ sudo systemctl start dictd.service
$ systemctl status dictd.service
```
* (Fedora box) (Optional) Enable service at startup:
```bash
$ sudo systemctl enable dictd.service
```
* (Fedora box) (Optional) Test if `dict` works properly:
```bash
$ dict -h localhost dictionary
1 definition found

From WordNet (r) 3.0 (2006) [wnoffline]:

  dictionary
      n 1: a reference book containing an alphabetical list of words
           with information about them [syn: {dictionary}, {lexicon}]

```
* (Optional) Disable internet connection and try searching for word definition
in Vim.

## Usage
There are two functions, one that looks up words in dictionaries hosted on the
internet, and other which supports offline dictionaries, running on a local
instance of `dictd` server.

* `WordDefinition` - this function uses public dict.org instance (depending on
the platform and configuration).
* `WordDefinitionOfflineDictionary` - this function uses local `dictd` instance.

WordNet dictionary is used by default when using online approach, but this is
configurable by using `b:word_dictionary` variable.

Example:
```
$ $EDITOR ~/.vim/ftplugin/text.vim
set colorcolumn=80
let b:word_dictionary="gcide"
nmap <leader>wd :WordDefinition<CR><ESC>
```

With offline approach, plugin will use whichever dictionary or dictionaries
user setup on their `dictd` instance.

No mappings are set by default, if you'd like to use some, here is additional
example:
```
" Enables plugin when working in text or markdown files:
$ $EDITOR .vimrc
let mapleader=';'
augroup word_definition
:   autocmd!
:   autocmd FileType markdown,text
        \ nmap <leader>wd :WordDefinition<CR>
augroup END
```
Use `<;-wd>` in Vim normal mode to get definition pop-up.

Alternatively, use `~/.vim/ftplugin` approach.

## Reference & Credit
Knowledge base which somewhat helped in dealing with beast such as VimScript,
plus some general mentions:
* Authors of following plugins:
  - [vim-plug](https://github.com/junegunn/vim-plug)
  - [vim-go](https://github.com/fatih/vim-go)
* Author of the following book on topic of VimScript
  - [Learn VimScript The Hard Way](https://learnvimscriptthehardway.stevelosh.com)
* ASCII Font
  - ansishadow
* Debian/Ubuntu package maintainers
* Authors of `DICT` protocol, `dict` and `dictd` programs
* Authors of [WordNet](https://wordnet.princeton.edu/) lexical database
