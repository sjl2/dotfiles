" https://neovim.io/doc/user/provider.html
let g:loaded_python_provider = 0 " disable python 2
let g:python_host_prog = '/Users/stewart/.pyenv/shims/python' " use pyenv shim

call plug#begin()

"" File System Navigation
Plug 'scrooloose/nerdtree'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight' " nerdtree icons
Plug 'Xuyuanp/nerdtree-git-plugin' " file git status
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

"" Git Tools
Plug 'airblade/vim-gitgutter' " git status for individual lines & hunks
Plug 'hotwatermorning/auto-git-diff' " displays commit diffs for interative rebases

"" Status Bar
Plug 'vim-airline/vim-airline' " bottom status bar
Plug 'vim-airline/vim-airline-themes' " visual themes

" Unix Shell Commands
Plug 'tpope/vim-eunuch'

" Open files to specfic lines
Plug 'bogado/file-line' " nv index.html:20

"" Aesthetic
Plug 'crusoexia/vim-monokai'
Plug 'ryanoasis/vim-devicons'

"" Copy/Paste
Plug 'tpope/vim-repeat'
Plug 'svermeulen/vim-easyclip'

"" Code Shortcuts

" VSCode like Plugins
let g:coc_global_extensions = [
\ 'coc-css',
\ 'coc-html',
\ 'coc-json',
\ 'coc-python',
\ 'coc-tsserver',
\ 'coc-yaml',
\ ]

if isdirectory('./node_modules') && isdirectory('./node_modules/prettier')
  let g:coc_global_extensions += ['coc-prettier']
endif

if isdirectory('./node_modules') && isdirectory('./node_modules/eslint')
  let g:coc_global_extensions += ['coc-eslint']
endif

Plug 'neoclide/coc.nvim', {'branch': 'release'}

Plug 'scrooloose/nerdcommenter'

"" Better Character Movement
Plug 'justinmk/vim-sneak'
let g:sneak#s_next = 1
let g:sneak#use_ic_scs = 1

"" Syntax Highlighting
Plug 'sheerun/vim-polyglot'

"" Auto-formatter
Plug 'sbdchd/neoformat' " TODO: set-up as needed

"" Testing
Plug 'janko-m/vim-test' " edit -> test shortcuts TODO: fix for lab
Plug 'benmills/vimux' " runs test in tmux pane

"" GoLang
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' } " TODO: replace with coc?

call plug#end()

" Open init.vim
nnoremap <leader>ev :vsplit $MYVIMRC<cr>

" Source init.vim
nnoremap <leader>sv :source $MYVIMRC<cr>

""" My Theme
syntax on
colorscheme monokai " crusoexia/vim-monokai Theme
set t_Co=256 " https://vim.fandom.com/wiki/256_colors_in_vim

" basic config
set number
set ruler
set autoread             " auto read edits from outside
set clipboard=unnamed    " necessary for using OS clipboard
set undodir=~/.vim/undo/
set undofile

" line formats
set textwidth=120
set formatoptions-=t
set colorcolumn=121

" fonts and icons
set encoding=utf-8
set guifont=Droid\ Sans\ Mono\ for\ Powerline\ Plus\ Nerd\ File\ Types:h11

" window options
set showmode
set showcmd
set ruler
set ttyfast
set backspace=indent,eol,start
set laststatus=2

tnoremap <Esc> <C-\><C-n>


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

""" fzf Mappings
" find/switch files
nnoremap <C-p> :Files<CR>
" find/switch buffers
nnoremap <Leader>b :Buffers<CR>
"nnoremap <Leader>r :Tags<CR> TODO: use tags?

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

"" Tabs/Indents
" Default
set shiftwidth=2
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
let test#strategy = 'vimux' " plug above; opens test in tmux pane

nmap <silent> <leader>t :TestNearest<CR>
nmap <silent> <leader>f :TestFile<CR>
nmap <silent> <leader>s :TestSuite<CR>

" Airline Config
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1

" leave showtabline as default (for now)
set showtabline=1

"" Search & Replace
set incsearch
set showcmd
set ignorecase
set smartcase
set hlsearch
highlight ColorColumn ctermbg=2

" vim-gitgutter
set updatetime=200

" escape search highlighting by hitting return
nnoremap <CR> :noh<CR><CR>

" remove any trailing whitespace that is in the file
autocmd BufRead,BufWrite * if ! &bin | silent! %s/\s\+$//ge | endif

" lists invisible chars
"set list listchars=tab:❘-,trail:·,extends:»,precedes:«,nbsp:×

" multiple cursor settings
let g:multi_cursor_exit_from_visual_mode=0

" keep at least 5 lines below the cursor
set scrolloff=5

" enable mouse support
set mouse=a

" close buffer when tab is closed
set nohidden

" Vim Test Options
let g:test#runner_commands = ['Exunit', 'Lab', 'Minitest', 'Mocha']

" deprecated (lob specific)
" let @j = 'cc[ENG-####](https://lobsters.atlassian.net/browse/ENG-####)jk' " copy in md hyperlink for jira tickets

""" Distraction free writing
" https://gist.github.com/jeffcasavant/c32978fbc23522286821df5f35e659fa#file-vimrc-L109
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

""" justinmk/vim-sneak' settings
let g:sneak#s_next = 1
let g:sneak#use_ic_scs = 1

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

" Add Prettier Format Command
command! -nargs=0 Prettier :CocCommand prettier.formatFile

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
" source: https://github.com/neoclide/coc.nvim#example-vim-configuration
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
