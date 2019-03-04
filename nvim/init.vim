""" Plugins
"""" Dein-begin
if &runtimepath !~# '/dein.vim'
  let s:dein_dir = expand('~/.cache/dein/repos/github.com/Shougo/dein.vim')

  if !isdirectory(s:dein_dir)
    call system('git clone https://github.com/Shougo/dein.vim ' . shellescape(s:dein_dir))
  endif

  execute 'set runtimepath^=' . s:dein_dir
endif

call dein#begin(expand('~/.cache/dein'))

"""" Plugin manager
call dein#add('Shougo/dein.vim')
call dein#add('haya14busa/dein-command.vim')

"""" Look & feel
call dein#add('tomasr/molokai')
call dein#add('itchyny/lightline.vim')
call dein#add('mgee/lightline-bufferline')
call dein#add('maximbaz/lightline-trailing-whitespace')
call dein#add('maximbaz/lightline-ale')
call dein#add('gcavallanti/vim-noscrollbar')
call dein#add('cskeeters/vim-smooth-scroll')
call dein#add('scrooloose/nerdtree')

"""" Format code
call dein#add('tpope/vim-sleuth')
call dein#add('sbdchd/neoformat')
call dein#add('dhruvasagar/vim-table-mode')

"""" Manipulate code
call dein#add('terryma/vim-multiple-cursors')
call dein#add('tpope/vim-repeat')
call dein#add('vim-scripts/visualrepeat')
call dein#add('machakann/vim-sandwich')
call dein#add('tpope/vim-abolish')
call dein#add('Raimondi/delimitMate')
call dein#add('vim-scripts/VisIncr')
call dein#add('junegunn/vim-easy-align')
call dein#add('scrooloose/nerdcommenter')
call dein#add('tpope/vim-endwise')
call dein#add('alvan/vim-closetag')
call dein#add('matze/vim-move')

"""" Navigate code
call dein#add('osyo-manga/vim-anzu')
call dein#add('t9md/vim-smalls')

"""" Navigate files, buffers and panes
call dein#add('airblade/vim-rooter')
call dein#add('benizi/vim-automkdir')

"""" Autocomplete
call dein#add('honza/vim-snippets')
call dein#add('neoclide/coc.nvim', {
        \'build': 'yarn install',
        \})

"""" Git
call dein#add('tpope/vim-fugitive')
call dein#add('airblade/vim-gitgutter')

"""" Render code
call dein#add('sheerun/vim-polyglot')
call dein#add('ap/vim-css-color')

"""" Lint code
call dein#add('w0rp/ale')

"""" Language-specific
""""" Go
call dein#add('fatih/vim-go')

"""" Dein-end
call dein#end()

if dein#check_install()
  call dein#install()
endif

""" Environment
"""" General
filetype plugin indent on
syntax on
let &fillchars="vert:|,fold: ,diff: "
set cursorline
set diffopt+=iwhite
set expandtab
set formatoptions+=l
set formatoptions+=n
set formatoptions+=o
set formatoptions+=r
set formatoptions-=c
set formatoptions-=t
set hidden
set cmdheight=2
set ignorecase
set lazyredraw
set linebreak
set list
set listchars=tab:»·,trail:·,nbsp:·
"set mouse=a
set noshowmode
set nostartofline
set noswapfile
set nrformats=
set relativenumber
set report=0
set scrolloff=3
set shiftround
set shiftwidth=2
set shortmess+=I
set shortmess+=c
set signcolumn=yes
set showcmd
set showtabline=2
set sidescrolloff=3
set smartcase
set spelllang=en,da,ru
set splitbelow
set splitright
set tabstop=2
set title
set updatetime=100
set wildmode=longest,list,full

"""" Theme
"set termguicolors
"set background=dark
colorscheme molokai
set guioptions+=c
set guioptions-=T
set guioptions-=m
set guicursor=n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20
hi Normal ctermbg=NONE guibg=NONE

""" Keyboard shortcuts
"""" Leader
let mapleader = ","
nmap <Space> <Leader>
vmap <Space> <Leader>

"""" Write buffer
nnoremap <Leader>w :w<CR>

"""" Better redo
nnoremap U <C-R>

"""" Remove annoyance
nnoremap <Del> <nop>
vnoremap <Del> <nop>
nnoremap <Backspace> <nop>
vnoremap <Backspace> <nop>
nnoremap Q <nop>

"""" Copy to system clipboard
nnoremap <Leader>y "+y
vnoremap <Leader>y "+y

"""" Paste from system clipboard
nnoremap <Leader>p "+p
vnoremap <Leader>p "+p
nnoremap <Leader>P "+P
vnoremap <Leader>P "+P

"""" Delete, not cut
nnoremap <Leader>d "_d
vnoremap <Leader>d "_d

"""" Navigate through autocompletion
inoremap <C-j> <C-n>
inoremap <C-k> <C-p>

""""" Navigate through location list
nmap <C-n> <Plug>(qf_loc_next)<bar><Plug>(qf_qf_next)
nmap <C-p> <Plug>(qf_loc_previous)<bar><Plug>(qf_qf_previous)

"""" Scroll command history
cnoremap <C-j> <Down>
cnoremap <C-k> <Up>

"""" Write with sudo
cnoremap w!! w !sudo tee > /dev/null %

"""" Navigate through visual lines
"nnoremap <expr> j v:count ? 'j' : 'gj'
"nnoremap <expr> k v:count ? 'k' : 'gk'
nnoremap j gj
nnoremap k gk

"""" Indent / unindent
nnoremap <S-Tab> <<
nnoremap <Tab> >>
xnoremap <Tab> >gv
xnoremap <S-Tab> <gv

"""" Scroll by half of the screen
nmap <PageDown> <C-d>
nmap <PageUp> <C-u>
nmap <C-e> <C-u>

"""" Change tab size
nnoremap <silent><Leader>cst :setlocal ts=4 sts=4 noet <bar> retab! <bar> setlocal ts=2 sts=2 et <bar> retab<CR>

""""
nnoremap ; :
inoremap jj <ESC>
map <leader>tq :tabprevious<cr>
map <leader>tw :tabnext<cr>
map <leader>te :tabnew<cr>
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

""" Plugins configuration
"""" ALE
let g:ale_open_list = 0
let g:ale_loclist_msg_format='%linter%: %code: %%s'

let g:ale_linters = {
      \ 'go': ['golint', 'go vet', 'go build', 'gometalinter'],
      \ 'python': ["flake8"],
      \ }
let g:ale_go_gometalinter_lint_package = 1

"""" Lightline
let g:lightline = {
      \   'colorscheme': 'wombat',
      \   'active': {
      \     'left': [ [ 'mode' ],
      \               [ 'pwd' ],
      \               [ 'linter_ok', 'linter_checking', 'linter_errors', 'linter_warnings'] ],
      \     'right': [ [ 'trailing' ],
      \                [ 'lineinfo' ],
      \                [ 'fileinfo' ],
      \                [ 'scrollbar' ] ],
      \   },
      \   'inactive': {
      \     'left': [ [ 'pwd' ] ],
      \     'right': [ [ 'lineinfo' ], [ 'fileinfo' ], [ 'scrollbar' ] ],
      \   },
      \   'tabline': {
      \     'left': [ [ 'buffers' ] ],
      \     'right': [ [ 'close' ] ],
      \   },
      \   'separator': { 'left': '', 'right': '' },
      \   'subseparator': { 'left': '', 'right': '' },
      \   'mode_map': {
      \     'n' : 'N',
      \     'i' : 'I',
      \     'R' : 'R',
      \     'v' : 'V',
      \     'V' : 'V-LINE',
      \     "\<C-v>": 'V-BLOCK',
      \     'c' : 'C',
      \     's' : 'S',
      \     'S' : 'S-LINE',
      \     "\<C-s>": 'S-BLOCK',
      \     't': '󰀣 ',
      \   },
      \   'component': {
      \     'lineinfo': '%l:%-v',
      \   },
      \   'component_expand': {
      \     'buffers': 'lightline#bufferline#buffers',
      \     'trailing': 'lightline#trailing_whitespace#component',
      \     'linter_ok': 'lightline#ale#ok',
      \     'linter_checking': 'lightline#ale#checking',
      \     'linter_warnings': 'lightline#ale#warnings',
      \     'linter_errors': 'lightline#ale#errors',
      \   },
      \   'component_function': {
      \     'pwd': 'LightlineWorkingDirectory',
      \     'scrollbar': 'LightlineScrollbar',
      \     'fileinfo': 'LightlineFileinfo',
      \   },
      \   'component_type': {
      \     'buffers': 'tabsel',
      \     'trailing': 'error',
      \     'linter_ok': 'left',
      \     'linter_checking': 'left',
      \     'linter_warnings': 'warning',
      \     'linter_errors': 'error',
      \   },
      \ }

""""" Custom components
function! LightlineScrollbar()
  let top_line = str2nr(line('w0'))
  let bottom_line = str2nr(line('w$'))
  let lines_count = str2nr(line('$'))

  if bottom_line - top_line + 1 >= lines_count
    return ''
  endif

  let window_width = winwidth(0)
  if window_width < 90
    let scrollbar_width = 6
  elseif window_width < 120
    let scrollbar_width = 9
  else
    let scrollbar_width = 12
  endif

  return noscrollbar#statusline(scrollbar_width, '-', '#')
endfunction

function! LightlineFileinfo()
  if winwidth(0) < 90
    return ''
  endif

  let encoding = &fenc !=# "" ? &fenc : &enc
  let format = &ff
  let type = &ft !=# "" ? &ft : "no ft"
  return type . ' | ' . format . ' | ' . encoding
endfunction

function! LightlineWorkingDirectory()
  return &ft =~ 'help\|qf' ? '' : fnamemodify(getcwd(), ":~:.")
endfunction

"""" lightline-bufferline
let g:lightline#bufferline#filename_modifier = ':~:.'
let g:lightline#bufferline#unicode_symbols = 1
let g:lightline#bufferline#unnamed = '[No Name]'
let g:lightline#bufferline#shorten_path = 0

"""" Lightline trailing whitespace
let g:lightline#trailing_whitespace#indicator = '•'

"""" DelimitMate
let delimitMate_expand_cr = 2
let delimitMate_expand_space = 1
let delimitMate_nesting_quotes = ['"', '`']
let delimitMate_excluded_regions = ""
let delimitMate_balance_matchpairs = 1

"""" vim-move
let g:move_key_modifier = 'C-S'

"""" coc
let g:coc_global_extensions = ['coc-json', 'coc-tsserver', 'coc-tslint', 'coc-eslint', 'coc-html', 'coc-css', 'coc-jest', 'coc-emoji', 'coc-prettier', 'coc-wxml', 'coc-yaml', 'coc-pyls', 'coc-highlight', 'coc-dictionary', 'coc-tag', 'coc-lists', 'coc-yank']

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

"""""  Use <c-space> for trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

"""""  Use <cr> for confirm completion, `<C-g>u` means break undo chain at current position.
"""""  Coc only does snippet and additional edit on confirm.
""""" inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

"""""  Use `[c` and `]c` for navigate diagnostics
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)

"""""  Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

"""""  Use K for show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if &filetype == 'vim'
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

"""""  Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

"""""  Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

"""""  Remap for format selected region
vmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

"""""  Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
vmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

"""""  Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)
"""""  Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

"""""  Use `:Format` for format current buffer
command! -nargs=0 Format :call CocAction('format')

"""""  Use `:Fold` for fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

"""""  Using CocList
"""""  Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
"""""  Manage extensions
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
"""""  Show commands
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
"""""  Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
"""""  Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
"""""  Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
"""""  Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
"""""  Resume latest coc list
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>

"""" EasyAlign
nmap <Leader>= <Plug>(EasyAlign)
xmap <Leader>= <Plug>(EasyAlign)

"""" GitGutter
let g:gitgutter_map_keys = 0

nmap ]c <Plug>GitGutterNextHunk<Plug>GitGutterPreviewHunk<Bar>zv
nmap [c <Plug>GitGutterPrevHunk<Plug>GitGutterPreviewHunk<Bar>zv
nmap <Leader>ga <Plug>GitGutterStageHunk
nmap <Leader>gu <Plug>GitGutterUndoHunk
nmap <Leader>gp <Plug>GitGutterPreviewHunk

"""" Go
let g:go_fmt_autosave = 0
let g:go_auto_type_info = 1
let g:go_highlight_build_constraints = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_generate_tags = 1
let g:go_highlight_methods = 1
let g:go_highlight_operators = 1
let g:go_highlight_types = 1

"""" Smalls
let g:smalls_auto_jump = 1
nmap s <Plug>(smalls)
xmap s <Plug>(smalls)
omap s <Plug>(smalls)

"""" coc-snippets
imap <C-l> <Plug>(coc-snippets-expand)
vmap <C-j> <Plug>(coc-snippets-select)
let g:coc_snippet_next = '<c-j>'
let g:coc_snippet_prev = '<c-k>'

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#rpc#request('doKeymap', ['snippets-expand', "\<TAB>"])

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" nerdtree
let NERDTreeShowHidden=1
map <leader>nn :NERDTreeToggle<cr>
map <leader>nb :NERDTreeFromBookmark
map <leader>nf :NERDTreeFind<cr>
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") &&b:NERDTreeType == "primary") | q | endif

"""" vim-rooter
let g:rooter_use_lcd = 1
let g:rooter_silent_chdir = 1
let g:rooter_resolve_links = 1

"""" vim-smooth-scroll
let g:ms_per_line=2

"""" vim-table-mode
let g:table_mode_verbose = 0
let g:table_mode_corner = '|'
let g:table_mode_auto_align = 1

""" Functions
"""" Removes trailing whitespace
function! RemoveTrailingSpaces()
  let l = line(".")
  let c = col(".")
  %s/\s\+$//e
  call cursor(l, c)
endfunction

nnoremap <silent> <F10> :call RemoveTrailingSpaces()<CR>

"""" Repeat macro over visual selection
function! ExecuteMacroOverVisualRange()
  echo "@".getcmdline()
  execute ":'<,'>normal @".nr2char(getchar())
endfunction

"" vim:foldmethod=expr:foldlevel=0
"" vim:foldexpr=getline(v\:lnum)=~'^""'?'>'.(matchend(getline(v\:lnum),'""*')-2)\:'='
