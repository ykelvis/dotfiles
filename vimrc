syntax enable
filetype on
filetype plugin on
filetype indent on

" {{{ plugin
call plug#begin('~/.vim/bundle') 
Plug 'rust-lang/rust.vim'
Plug 'Raimondi/delimitMate'
Plug 'altercation/vim-colors-solarized'
Plug 'bling/vim-airline'
Plug 'davidhalter/jedi-vim'
Plug 'easymotion/vim-easymotion'
Plug 'jiangmiao/auto-pairs'
"Plug 'jlanzarotta/bufexplorer'
Plug 'jwhitley/vim-matchit'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'kien/rainbow_parentheses.vim'
"Plug 'klen/python-mode'
"Plug 'vim-scripts/taglist.vim'
Plug 'majutsushi/tagbar'
Plug 'w0rp/ale'
Plug 'mattn/emmet-vim'
"Plug 'scrooloose/syntastic'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree',  { 'on': 'NERDTreeToggle'  }
Plug 'sickill/vim-monokai'
Plug 'terryma/vim-multiple-cursors'
Plug 'tomasr/molokai'
Plug 'tpope/vim-markdown'
Plug 'tpope/vim-fugitive'
"Plug 'Valloric/YouCompleteMe'
Plug 'Yggdroot/indentLine'
call plug#end()
" }}}

" settings {{{
set lazyredraw
set tags=tags
set completeopt=longest,menu
set nocompatible
set nobackup
set nowritebackup
set nowb
set guifont=Sauce\ Code\ Powerline:h11
set noswapfile
set ffs=unix,dos,mac
"set modeline
set guiheadroom=0
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set encoding=utf-8
set fenc=utf-8
set fencs=utf-8,gbk,gb18030,gb2312,cp936,usc-bom,euc-jp
set enc=utf-8
set scrolloff=10
set autoread
set autoindent
set smartindent
set foldmethod=indent
set foldenable
set showmode
set showcmd
set hidden
set wildmenu
set wildmode=list:longest
set visualbell
set cursorline
"set cursorcolumn
set ttyfast
set ruler
set backspace=indent,eol,start
set laststatus=2
set relativenumber
set ignorecase
set autochdir
set smartcase
set smarttab
set gdefault
set incsearch
set magic
set mat=2
set showmatch
set hlsearch
set wrap
set textwidth=79
set formatoptions=qrn1
set colorcolumn=85
set laststatus=2
set runtimepath+=$HOME/.vim/
" }}}

" {{{ colors
set t_Co=256
"set background=dark
colorscheme molokai
" }}}

" keymappings {{{
let mapleader = ","
nnoremap / /\v
vnoremap / /\v
nnoremap <tab> %
vnoremap <tab> %

"nnoremap <up> <nop>
"#nnoremap <down> <nop>
"#nnoremap <left> <nop>
"#nnoremap <right> <nop>
"#inoremap <up> <nop>
"#inoremap <down> <nop>
"#inoremap <left> <nop>
"#inoremap <right> <nop>
nnoremap j gj
nnoremap k gk
inoremap <F1> <ESC>
nnoremap <F1> <ESC>
vnoremap <F1> <ESC>
nnoremap ; :
inoremap jj <ESC>
map <leader>tq :tabprevious<cr>
map <leader>tw :tabnext<cr>
map <leader>te :tabnew<cr>

map <leader>hc :nohl<cr>
map 0 ^
map <leader>4 $
map <leader>6 ^

map <leader>ww <C-W>w
map <leader>wr <C-W>r
map <leader>wc <C-W>c
map <leader>wq <C-W>q
map <Leader>wj <C-W>j
map <Leader>wk <C-W>k
map <Leader>wh <C-W>h
map <Leader>wl <C-W>l
map <Leader>wv <C-W>v
map <Leader>ws <C-W>s

nnoremap <leader>bf :b<space>
nnoremap <Leader>bb :bnext<CR>
nnoremap <Leader>q :bprevious<CR>
nnoremap <Leader>w :bnext<CR>
nnoremap <leader>bp :bprevious<CR>
nnoremap <leader>bn :bnext<CR>
nnoremap <leader>bd :bd<CR>
nnoremap <leader>bw :bw<CR>
nnoremap <leader>b1 :b1<CR>
nnoremap <leader>b2 :b2<CR>
nnoremap <leader>b3 :b3<CR>
nnoremap <leader>b4 :b4<CR>
nnoremap <leader>b5 :b5<CR>
nnoremap <leader>b6 :b6<CR>
nnoremap <leader>b7 :b7<CR>
nnoremap <leader>b8 :b8<CR>
nnoremap <leader>b9 :b9<CR>
" }}}

" plugin-settings {{{
"easymotion
let g:EasyMotion_smartcase = 1
let g:EasyMotion_skipfoldedline=0
nmap s <Plug>(easymotion-overwin-f2)
" " <Leader><Leader>w : word down
" " <Leader><Leader>b : word up
" " <Leader><Leader>s : search up and down
" " <leader><Leader>f : forward
" " <Leader><Leader>j : line head down
" " <Leader><Leader>k : line head up

"vim-airline
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFllg()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
"nerdtree
let NERDTreeShowHidden=1
map <leader>nn :NERDTreeToggle<cr>
map <leader>nb :NERDTreeFromBookmark
map <leader>nf :NERDTreeFind<cr>
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") &&b:NERDTreeType == "primary") | q | endif
"rainbow parenthese
au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces
"taglist
"nmap <Leader>tt :TlistToggle(CR)
"YouCompleteMe
"let g:ycm_autoclose_preview_window_after_completion=1
"map <leader>g  :YcmCompleter GoToDefinitionElseDeclaration<CR>
"tagbar
nmap <Leader>tb :TagbarToggle<CR>
let g:tagbar_ctags_bin='/usr/bin/ctags'
let g:tagbar_width=30
autocmd BufReadPost *.cpp,*.c,*.h,*.hpp,*.cc,*.cxx call tagbar#autoopen()
"emmet-vim
let g:user_emmet_install_global = 0
autocmd FileType html,css EmmetInstall
"ale
let g:ale_linters = {
\   'python': ["flake8"],
\}
"python-mode
let g:pymode_python = 'python'
let g:pymode_lint = 1
let g:pymode_lint_on_write = 1
let g:pymode_syntax = 1
let g:pymode_syntax_all = 1
let g:pymode_lint_on_fly = 0
"rust.vim
let g:rustfmt_autosave = 1

"jedi-vim
let g:jedi#goto_command = "<leader>d"
let g:jedi#goto_assignments_command = "<leader>g"
let g:jedi#goto_definitions_command = ""
let g:jedi#documentation_command = "K"
let g:jedi#usages_command = "<leader>n"
let g:jedi#completions_command = ",<tab>"
let g:jedi#rename_command = "<leader>r"
let g:jedi#popup_select_first = 1
"doc in tab not buffer
let g:jedi#use_tabs_not_buffers = 0 
" }}}

" misc {{{
if has("autocmd")
    au BufRead * normal zR
endif

if has("unix")
    let s:uname = system("uname -s")
    if s:uname == "Darwin\n"
        let g:tagbar_ctags_bin = "~/.scripts/ctags-osx"
    elseif s:uname == "Linux\n"
        let g:tagbar_ctags_bin = "~/.scripts/ctags-linux"
   endif
endif
" }}}

" vim:foldmethod=marker:foldlevel=0
