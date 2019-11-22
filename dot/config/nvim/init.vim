let g:python_host_prog = '/Users/stewart/.pyenv/shims/python' " Python 2
let g:python_host_prog3 = '/Users/stewart/.pyenv/shims/python3' " Python 3

set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath

tnoremap <Esc> <C-\><C-n>
source ~/.vimrc
