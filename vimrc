filetype on
filetype plugin on
filetype indent on

call plug#begin('~/.vim/bundle')
Plug 'altercation/vim-colors-solarized'
Plug 'bling/vim-airline'
Plug 'easymotion/vim-easymotion'
Plug 'jiangmiao/auto-pairs'
Plug 'jlanzarotta/bufexplorer'
Plug 'jwhitley/vim-matchit'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'kien/rainbow_parentheses.vim'
Plug 'klen/python-mode'
"Plug 'vim-scripts/taglist.vim'
Plug 'majutsushi/tagbar'
Plug 'mattn/emmet-vim'
Plug 'scrooloose/syntastic'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree',  { 'on': 'NERDTreeToggle'  }
Plug 'sickill/vim-monokai'
Plug 'terryma/vim-multiple-cursors'
Plug 'tomasr/molokai'
Plug 'tpope/vim-markdown'
Plug 'tpope/vim-fugitive'
Plug 'Valloric/YouCompleteMe'
Plug 'Yggdroot/indentLine'
call plug#end()

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
"set foldmethod=indent
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

"UI
"colors
set t_Co=256
syntax enable
"set background=dark
colorscheme molokai

"keymappings
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
map <leader>q :tabprevious<cr>
map <leader>w :tabnext<cr>
map <leader>e :tabnew<cr>

"easymotion
let g:EasyMotion_smartcase = 1
"vim-airline
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
"nerdtree
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
let g:ycm_autoclose_preview_window_after_completion=1
map <leader>g  :YcmCompleter GoToDefinitionElseDeclaration<CR>
"tagbar
nmap <Leader>tb :TagbarToggle<CR>
let g:tagbar_ctags_bin='/usr/bin/ctags'
let g:tagbar_width=30
autocmd BufReadPost *.cpp,*.c,*.h,*.hpp,*.cc,*.cxx call tagbar#autoopen()
"emmet-vim
let g:user_emmet_install_global = 0
autocmd FileType html,css EmmetInstall
"python-mode
let g:pymode_python = 'python'
let g:pymode_lint = 1
let g:pymode_lint_on_write = 1
let g:pymode_syntax = 1
let g:pymode_syntax_all = 1
let g:pymode_lint_on_fly = 0

"fix ctags on osx
if has("unix")
    let s:uname = system("uname -s")
    if s:uname == "Darwin\n"
        let g:tagbar_ctags_bin = "~/.scripts/ctags-osx"
    elseif s:uname == "Linux\n"
        let g:tagbar_ctags_bin = "~/.scripts/ctags-linux"
   endif
endif
