let g:python_host_prog = '/Users/stewart/.pyenv/shims/python'"

call plug#begin()

"" Aesthetic
Plug 'crusoexia/vim-monokai'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'scrooloose/nerdtree'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'ryanoasis/vim-devicons'
Plug 'junegunn/goyo.vim'

"" Git Tools
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'airblade/vim-gitgutter'
Plug 'hotwatermorning/auto-git-diff'

"" Copy/Paste
Plug 'tpope/vim-repeat'
Plug 'svermeulen/vim-easyclip'

"" File Shortcuts
Plug 'mileszs/ack.vim'
Plug 'Shougo/vimproc.vim', {'do' : 'make'}
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'bogado/file-line'

"" Code Shortcuts
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'godlygeek/tabular'
Plug 'scrooloose/nerdcommenter'
Plug 'Valloric/YouCompleteMe', { 'do': './install.py' }
Plug 'justinmk/vim-sneak'

"" Syntax Plugs
Plug 'sheerun/vim-polyglot'
Plug 'pangloss/vim-javascript'
Plug 'jelera/vim-javascript-syntax'
Plug 'w0rp/ale'

"" Testing
Plug 'janko-m/vim-test'
Plug 'benmills/vimux'

"" GoLang
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

call plug#end()

tnoremap <Esc> <C-\><C-n>
source ~/.vimrc
