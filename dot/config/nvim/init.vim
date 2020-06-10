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
Plug 'sbdchd/neoformat'
Plug 'neomake/neomake'

"" Testing
Plug 'janko-m/vim-test'
Plug 'benmills/vimux'

"" GoLang
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

call plug#end()

tnoremap <Esc> <C-\><C-n>
source ~/.vimrc

" Open init.vim
nnoremap <leader>ev :vsplit $MYVIMRC<cr>

" Source init.vim
nnoremap <leader>sv :source $MYVIMRC<cr>

" basic config
set number
set ruler
set autoread             " auto read edits from outside
set clipboard=unnamed    " necessary for using OS clipboard
set undodir=~/.vim/undo/
set undofile

" line
set textwidth=120
set formatoptions-=t
set colorcolumn=121


"""" Visuals
" crusoexia/vim-monokai Theme
syntax on
colorscheme monokai
set t_Co=256

" JSON Comment Highlighting
autocmd FileType json syntax match Comment +\/\/.\+$+

" fonts and icons
set encoding=utf-8
set guifont=Droid\ Sans\ Mono\ for\ Powerline\ Plus\ Nerd\ File\ Types:h11

"""" Movement

" jk for leaving normal mode
inoremap jk <Esc>
inoremap kj <Esc>

" Visually moves up and down (for wrapped lines)
nnoremap k gk
nnoremap j gj

" Have left and right movement wrap lines
set whichwrap+=<,>,h,l,[,]

" Jump to beginning and end of lines
nnoremap H 0
vnoremap H 0
nnoremap L $
vnoremap L $

" better moving between windows
noremap <C-j> <C-W>j
noremap <C-k> <C-W>k
noremap <C-h> <C-W>h
noremap <C-l> <C-W>l

" Move between buffers with tab and shift-tab
nnoremap <Tab> :bnext<CR>
nnoremap <S-Tab> :bprevious<CR>

" fzf Buffers
nnoremap <Leader>b :Buffers<CR>
nnoremap <C-p> :Files<CR>
"nnoremap <Leader>r :Tags<CR>

"" Tabs/Indents
" Default
set shiftwidth=2   "
set softtabstop=2
filetype plugin on " required
filetype indent on " change indent based on file type
set autoindent
set smarttab
set expandtab

" Go Tabs
au FileType go set noexpandtab
au FileType go set shiftwidth=4
au FileType go set softtabstop=4
au FileType go set tabstop=4

" Makefile Tabs
autocmd FileType make set noexpandtab shiftwidth=8 softtabstop=0

" change split opening to below and right
set splitbelow
set splitright

" disable backups
set nobackup
set nowritebackup
set noswapfile

" vim-test
let test#strategy = 'vimux'

nmap <silent> <leader>t :TestNearest<CR>
nmap <silent> <leader>f :TestFile<CR>
nmap <silent> <leader>s :TestSuite<CR>

" nerdtree
"autocmd FileType nerdtree setlocal nolist

" auto start NERDTree
"autocmd vimenter * NERDTree

" Airline Config
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1

" YouCompleteMe Config
if !exists('g:ycm_semantic_triggers')
  let g:ycm_semantic_triggers = {}
endif
let g:ycm_semantic_triggers['typescript'] = ['.']
let g:ycm_autoclose_preview_window_after_completion = 1

" leave showtabline as default (for now)
set showtabline=1

"" Search & Replace
set incsearch
set showcmd
set ignorecase
set smartcase
set hlsearch
highlight ColorColumn ctermbg=2

"""" justinmk/vim-sneak
let g:sneak#s_next = 1
let g:sneak#use_ic_scs = 1

" 2-character Sneak (default)
nmap S <Plug>Sneak_S
nmap s <Plug>Sneak_s
omap S <Plug>Sneak_S
omap s <Plug>Sneak_s
xmap S <Plug>Sneak_S
xmap s <Plug>Sneak_s

" replace 'f' with 1-char Sneak
nmap F <Plug>Sneak_F
nmap f <Plug>Sneak_f
omap F <Plug>Sneak_F
omap f <Plug>Sneak_f
xmap F <Plug>Sneak_F
xmap f <Plug>Sneak_f

" replace 't' with 1-char Sneak
nmap T <Plug>Sneak_T
nmap t <Plug>Sneak_t
omap T <Plug>Sneak_T
omap t <Plug>Sneak_t
xmap T <Plug>Sneak_T
xmap t <Plug>Sneak_t
""""

" window options
set showmode
set showcmd
set ruler
set ttyfast
set backspace=indent,eol,start
set laststatus=2

" vim-gitgutter
set updatetime=200

" escape search highlighting by hitting return
nnoremap <CR> :noh<CR><CR>

" remove any trailing whitespace that is in the file
autocmd BufRead,BufWrite * if ! &bin | silent! %s/\s\+$//ge | endif

" lists invisible chars
"set list listchars=tab:❘-,trail:·,extends:»,precedes:«,nbsp:×

" tabular key bindings
nmap <leader>t= :Tabularize /=<CR>
vmap <leader>t= :Tabularize /=<CR>
nmap <leader>t: :Tabularize /:\zs<CR>
vmap <leader>t: :Tabularize /:\zs<CR>
nmap <leader>t, :Tabularize /,\zs<CR>
vmap <leader>t, :Tabularize /,\zs<CR>

" multiple cursor settings
let g:multi_cursor_exit_from_visual_mode=0

" fix aligned chains in javascript
let g:javascript_opfirst=1

" keep at least 5 lines below the cursor
set scrolloff=5

" enable mouse support
set mouse=a

" close buffer when tab is closed
set nohidden

" close vim if all tabs are closed
"autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

" Vim Test Options
let g:test#runner_commands = ['Exunit', 'Lab', 'Minitest', 'Mocha']

let @j = 'cc[ENG-####](https://lobsters.atlassian.net/browse/ENG-####)jk'

function! ProseMode()
  call goyo#execute(0, [])
  set spell noci nosi noai nolist noshowmode noshowcmd
  set complete+=s
  set bg=light
endfunction

command! ProseMode call ProseMode()
nmap \p :ProseMode<CR>

set exrc
set secure

" https://github.com/neomake/neomake#setup
call neomake#configure#automake('rw', 1000)

"" Copy/Paste (svermeulen/vim-easyclip)
" remap add mark
nnoremap gm m
nmap M <Plug>MoveMotionEndOfLinePlug

""""" GoLang

"" Syntax Highlighting
let g:go_highlight_build_constraints = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_operators = 1
let g:go_highlight_structs = 1
let g:go_highlight_types = 1

let g:go_auto_sameids = 1

"" vim-go Shortcuts
let g:go_echo_command_info = 0
let g:go_fmt_command = "goimports"

autocmd FileType go nmap <leader>b  <Plug>(go-build)
autocmd FileType go nmap <leader>r  <Plug>(go-run)

au FileType go nnoremap <Leader>gd <Plug>(go-def)
au FileType go nmap <Leader>gp <Plug>(go-def-pop)

au FileType go nnoremap <Leader>gv <Plug>(go-doc-vertical)
" or open in a browser...
au FileType go nnoremap <Leader>gb <Plug>(go-doc-browser)

au FileType go nnoremap <Leader>s <Plug>(go-implements)
au FileType go nnoremap <Leader>i <Plug>(go-info)
au FileType go nnoremap <Leader>gl <Plug>(go-metalinter)
au FileType go nnoremap <Leader>gc <Plug>(go-callers)
