"
"               ,---,        ,'  , `.,-.----.     ,----..
"       ,---.,`--.' |     ,-+-,.' _ |\    /  \   /   /   \
"      /__./||   :  :  ,-+-. ;   , ||;   :    \ |   :     :
" ,---.;  ; |:   |  ' ,--.'|'   |  ;||   | .\ : .   |  ;. /
"/___/ \  | ||   :  ||   |  ,', |  ':.   : |: | .   ; /--`
"\   ;  \ ' |'   '  ;|   | /  | |  |||   |  \ : ;   | ;
" \   \  \: ||   |  |'   | :  | :  |,|   : .  / |   : |
"  ;   \  ' .'   :  ;;   . |  ; |--' ;   | |  \ .   | '___
"   \   \   '|   |  '|   : |  | ,    |   | ;\  \'   ; : .'|
"    \   `  ;'   :  ||   : '  |/     :   ' | \.''   | '/  :
"     :   \ |;   |.' ;   | |`-'      :   : :-'  |   :    /
"      '---" '---'   |   ;/          |   |.'     \   \ .'
"                    '---'           `---'        `---`

"=======================================================================
"=== 1. Global variables ===============================================
"=======================================================================
"{{{
let g:python3_host_prog=expand('/usr/bin/python3.6')

let g:netrw_liststyle=1
let g:netrw_banner=0
let g:netrw_sizestyle='H'
let g:netrw_timefmt='%Y/%m/%d(%a) %H:%M:%S'
let g:netrw_preview=1

let g:vim_json_syntax_conceal = 0
let g:vim_markdown_conceal = 0
let g:indentLine_setConceal = 0

let g:pyls_my_config = {
\  'pyls': {
\      'plugins': {
\          'pydocstyle': {'enabled': v:true},
\          'pyls_black': {'enabled': v:true}
\      }
\  }
\}

"}}}

"=======================================================================
"=== 2. My Functions ======================================================
"=======================================================================
"{{{
function! s:Jq(...)
  if 0 == a:0
    let l:arg = '.'
  else
    let l:arg = a:1
  endif
  execute "%! jq \"" . l:arg . "\""
endfunction

function! s:cursor_moved() abort
  if exists('s:timer_id')
    call timer_stop(s:timer_id)
  endif
  let s:timer_id = timer_start(3000, function('s:enable_hover'))
endfunction

function! s:enable_hover(timer_id) abort
  :LspHover
endfunction

" debug mode
function! s:LspDebug() abort
  let g:lsp_log_verbose = 1
  let g:lsp_log_file = expand('~/vim-lsp.log')
  let g:asyncomplete_log_file = expand('~/asyncomplete.log')
endfunction

function! s:on_lsp_buffer_enabled() abort
  setlocal omnifunc=lsp#complete
  setlocal signcolumn=yes
  nmap <buffer> <f2> <plug>(lsp-rename)
endfunction

function! s:popup_terminal() abort
  let [w, h] = [80, 24]
  let bid = term_start(['bash'], { 'term_cols': w, 'term_rows': h, 'hidden': 1, 'term_finish': 'close' })
  let winid = popup_create(bid, { 'minwidth': w, 'minheight': h, 'title': 'bash', 'border': [] })
endfunction

function! s:popup_python_terminal() abort
  let [w, h] = [80, 24]
  let bid = term_start(['python3'], { 'term_cols': w, 'term_rows': h, 'hidden': 1, 'term_finish': 'close' })
  let winid = popup_create(bid, { 'minwidth': w, 'minheight': h, 'title': 'bash', 'border': [] })
endfunction
"}}}

"=======================================================================
"=== 3. My command =====================================================
"=======================================================================
"{{{
command! -nargs=? Jq call s:Jq(<f-args>)
command! LspDebug call s:LspDebug()
command! PopTerm call s:popup_terminal()
command! PopPyTerm call s:popup_python_terminal()
"}}}

"=======================================================================
"=== 4. Plugins ========================================================
"=======================================================================
"{{{
" if &compatible
"   set nocompatible               " Be iMproved
" endif

let s:dein_path = expand('$HOME/.cache/dein')
let s:dein_repo_path = s:dein_path . '/repos/github.com/Shougo/dein.vim'

if &runtimepath !~# '/dein.vim'
  if !isdirectory(s:dein_repo_path)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_path
  endif
  execute 'set runtimepath^=' . fnamemodify(s:dein_repo_path, ':p')
endif

" Required:
if dein#load_state(s:dein_path)
  call dein#begin(s:dein_path)

  "let g:config_dir  = expand('$HOME/.cache/dein/plugins')
  "let s:toml        = g:config_dir . '/plugins.toml'
  "let s:lazy_toml   = g:config_dir . '/plugins_lazy.toml'

  "call dein#load_toml(s:toml,    {'lazy': 0})
  "call dein#load_toml(s:lazy_toml,    {'lazy': 1})

  " Call deoplete
  if ((has('nvim')  || has('timers')) && has('python3')) && system('pip3 show neovim') !=# ''
    " call dein#add('Shougo/deoplete.nvim')
    " call dein#add('Shougo/neco-vim')
    call dein#add('Shougo/neco-syntax')
    call dein#add('ujihisa/neco-look')
    if !has('nvim')
        call dein#add('roxma/nvim-yarp')
        call dein#add('roxma/vim-hug-neovim-rpc')
    endif
  endif
  call dein#add('Shougo/neco-vim')

  " let g:deoplete#enable_at_startup = 0

  " Let dein manage dein
  " Required:
  "call dein#add('/home/giraffe/.cache/dein/repos/github.com/Shougo/dein.vim')

  " Add or remove your plugins here like this:
  call dein#add('Shougo/neosnippet.vim')
  call dein#add('Shougo/neosnippet-snippets')
  let g:neosnippet#enable_snipmate_compatibility = 1
  let g:neosnippet#snippets_directory='~/.cache/dein/repos/github.com/Shougo/neosnippet-snippets/neosnippets'
  call dein#add('Shougo/vimproc.vim', {'build' : 'make'})

  " VisualPlug
  call dein#add('itchyny/lightline.vim') "edit status line
  call dein#add('thinca/vim-showtime') "slid display
  call dein#add('simeji/winresizer') "move window
  call dein#add('Yggdroot/indentLine') "display indent line
  call dein#add('elzr/vim-json') "json file plugin
  call dein#add('t9md/vim-quickhl') "Highlight multiple search

  " LSPPlug
  call dein#add('prabirshrestha/async.vim')
  call dein#add('prabirshrestha/vim-lsp')
  call dein#add('prabirshrestha/asyncomplete.vim')
  call dein#add('prabirshrestha/asyncomplete-lsp.vim')
  call dein#add('prabirshrestha/asyncomplete-necovim.vim')
  call dein#add('prabirshrestha/asyncomplete-neosnippet.vim')
  call dein#add('thomasfaingnaert/vim-lsp-snippets')
  call dein#add('thomasfaingnaert/vim-lsp-neosnippet')
  call dein#add('autozimu/LanguageClient-neovim', {'rev': 'next', 'build': 'bash install.sh'})
  call dein#add('ryanolsonx/vim-lsp-python')
  call dein#add('mattn/vim-lsp-settings')

  " ALEPlug
  if has('job') && has('channel') && has('timers')
    call dein#add('w0rp/ale') "ALE(Asynchronous Lint Engine)
  else
    call dein#add('vim-syntastic/syntastic')
  endif
  call dein#add('maximbaz/lightline-ale') "Provide ALE to Light line

  " EditorPlug
  call dein#add('cohama/lexima.vim') "Auto close parentheses and repeat by dot
  call dein#add('scrooloose/nerdtree') "Open file tree
  call dein#add('tomtom/tcomment_vim') "Auto comment out by gcc
  call dein#add('tpope/vim-surround') "Auto close parenthesis by S of when selecting  in visual mode
  " call dein#add('scrooloose/syntastic') "Check for syntax
  call dein#add('thinca/vim-quickrun') "Quickly executed for the opened file
  call dein#add('mattn/gist-vim') "Edit Gist on vim
  call dein#add('majutsushi/tagbar') "Tab jump
  call dein#add('mattn/vim-sonictemplate') "Template

  " Color Scheme
  call dein#add('sjl/badwolf')
  call dein#add('nanotech/jellybeans.vim')
  call dein#add('w0ng/vim-hybrid')

  " FileSearch
  call dein#add('junegunn/fzf', {'build': './install --all'})
  call dein#add('junegunn/fzf.vim')

  " GitPlug
  call dein#add('airblade/vim-gitgutter')
  call dein#add('tpope/vim-fugitive')

  " AnsibleVault plug
  call dein#add('thiagoalmeidasa/vim-ansible-vault')

  " Required:
  call dein#end()
  call dein#save_state()
endif

" Required:
filetype plugin indent on
syntax on

" If you want to install not installed plugins on startup.
if dein#check_install()
  call dein#install()
endif

" set deoplete
if dein#tap('deoplete.nvim')
  let g:deoplete#enable_at_startup = 1
endif
"}}}

"=======================================================================
"=== 5. Basic setting ==================================================
"=======================================================================
"{{{
" ----------------------------------------------------------------------
" --- 5.1 Encord setting
" ----------------------------------------------------------------------
"{{{
set encoding=utf-8
scriptencoding utf-8
"}}}

" ----------------------------------------------------------------------
" --- 5.2 Editor setting
" ----------------------------------------------------------------------
"{{{
set shiftround          " '<'や'>'でインデントする際に'shiftwidth'の倍数に丸める
set infercase           " 補完時に大文字小文字を区別しない
set virtualedit=block   " カーソルを文字が存在しない部分でも動けるようにする
"set hidden              " バッファを閉じる代わりに隠す（Undo履歴を残すため）
set switchbuf=useopen   " 新しく開く代わりにすでに開いてあるバッファを開く
set showmatch           " 対応する括弧などをハイライト表示する
set matchtime=3         " 対応括弧のハイライト表示を3秒にする

" Search
set incsearch
set ignorecase
set smartcase
set hlsearch

" Command mode
set wildmenu
set wildmode=full

" enable backspace
set backspace=indent,eol,start

" log level
set undolevels=1000

" Indent
set autoindent
set smartindent
set smarttab
set expandtab
set listchars=tab:>-,trail:~,eol:￬
set tabstop=2
set shiftwidth=2
set softtabstop=2
set conceallevel=0

augroup indentFiletype
  autocmd!
  filetype plugin on
  filetype indent on
  "sw=softtabstop, sts=shiftwidth, ts=tabstop, et=expandtab
  autocmd FileType c           setlocal sw=4 sts=4 ts=4 et
  autocmd FileType html        setlocal sw=4 sts=4 ts=4 et
  autocmd FileType ruby        setlocal sw=2 sts=2 ts=2 et
  autocmd FileType js          setlocal sw=4 sts=4 ts=4 et
  autocmd FileType vim         setlocal sw=2 sts=2 ts=2 et foldmethod=marker
  autocmd FileType sh          setlocal sw=2 sts=2 ts=2 et foldmethod=marker omnifunc=lsp#complete
  autocmd FileType zsh         setlocal sw=4 sts=4 ts=4 et
  autocmd FileType python      setlocal sw=4 sts=4 ts=4 et omnifunc=lsp#complete
  autocmd FileType go          setlocal sw=4 sts=4 ts=4 et omnifunc=lsp#complete
  autocmd FileType scala       setlocal sw=4 sts=4 ts=4 et
  autocmd FileType json        setlocal sw=4 sts=4 ts=4 et
  autocmd FileType xml         setlocal sw=4 sts=4 ts=4 et
  autocmd FileType css         setlocal sw=4 sts=4 ts=4 et
  autocmd FileType scss        setlocal sw=4 sts=4 ts=4 et
  autocmd FileType sass        setlocal sw=4 sts=4 ts=4 et
  autocmd FileType javascript  setlocal sw=4 sts=4 ts=4 et
  autocmd FileType groovy      setlocal sw=4 sts=4 ts=4 et
  autocmd FileType text        setlocal sw=2 sts=2 ts=2 et foldmethod=marker
augroup END

function! s:is_view_available() abort " {{{
  if !&buflisted || &buftype !=# ''
    return 0
  elseif !filewritable(expand('%:p'))
    return 0
  endif
  return 1
endfunction " }}}
function! s:mkview() abort " {{{
  if s:is_view_available()
    silent! mkview
  endif
endfunction " }}}
function! s:loadview() abort " {{{
  if s:is_view_available()
    silent! loadview
  endif
endfunction " }}}
augroup foldSave
  autocmd!
  autocmd BufWinLeave ?* call s:mkview()
  autocmd BufReadPost ?* call s:loadview()
augroup END

" Undo,Redo
if has('persistent_undo')
  set undodir=~/.vim/undo
  set undofile
endif

" Highlight Trailing Spaces
augroup HighlightTrailingSpaces
  autocmd!
  autocmd VimEnter,WinEnter,ColorScheme * highlight TrailingSpaces term=underline guibg=Red ctermbg=Red
  autocmd VimEnter,WinEnter * match TrailingSpaces /\s\+$/
augroup END

" Paste
if &term =~? 'xterm'
    let &t_SI .= "\e[?2004h"
    let &t_EI .= "\e[?2004l"
    let &pastetoggle = "\e[201~"

    function XTermPasteBegin(ret)
        set paste
        return a:ret
    endfunction

    inoremap <special> <expr> <Esc>[200~ XTermPasteBegin("")
endif

" Buffer line
augroup vimrcEx
    au BufRead * if line("'\"") > 0 && line("'\"") <= line("$") |
      \ exe "normal g`\"" | endif
augroup END

" Template
augroup templates
  autocmd!
  autocmd BufNewFile *.py 0r ~/.vim/Templates/header.py
augroup END

"}}}

" ----------------------------------------------------------------------
" --- 5.3 Visual setting
" ----------------------------------------------------------------------
"{{{
set number                       " Display line number to left
set ambiwidth=double             " Adjust full width
set ruler                        " Display cursor line
set pumheight=10                 " Number of candidate displays for completion
set title                        " Display file name
set textwidth=0                  " Disable auto indention
set completeopt=menuone,preview  "Disply complete preview

set background=dark " Set background colors

" color scheme list
"colorscheme solarized
"colorscheme torte
" colorscheme molokai
" colorscheme badwolf
colorscheme jellybeans
" colorscheme hybrid

set cursorline " highlight cursor line
highlight cursorline term=reverse cterm=none ctermbg=236
" set colorcolumn=80

set laststatus=2 " Display status line
set noshowmode " Disable mode display for lightline
set signcolumn=yes

set t_ut=
if !has('gui_running')
  set t_Co=256
endif

" Mute
set t_vb=
set visualbell
set noerrorbells

" Hilight brackets
set matchpairs& matchpairs+=<:>

" Disable swap
set nowritebackup
set nobackup
set noswapfile

" Mouse
"set mouse=a
"set ttymouse=xterm2

" Window
set splitright
set splitbelow
"}}}

"}}}

"=======================================================================
"=== 6. Plugin setting =================================================
"=======================================================================
"{{{
" ----------------------------------------------------------------------
" --- 6.1 Language Server Protocol
" ----------------------------------------------------------------------
"{{{
augroup LanguageServer
  " Bash LSP conf
  if executable('bash-language-server')
    autocmd!
    autocmd User lsp_setup call lsp#register_server({
          \ 'name': 'bash-language-server',
          \ 'cmd': {server_info->[&shell, &shellcmdflag, 'bash-language-server start']},
          \ 'whitelist': ['sh'],
          \ })
  endif

  " Python LSP conf
  if executable('pyls')
    autocmd!
    autocmd User lsp_setup call lsp#register_server({
        \ 'name': 'pyls',
        \ 'cmd': {server_info->['pyls']},
        \ 'whitelist': ['python'],
        \ 'workspace_config': g:pyls_my_config
        \ })
  endif

  " Dockerfile LSP conf
  if executable('docker-langserver')
    autocmd!
    autocmd User lsp_setup call lsp#register_server({
        \ 'name': 'docker-langserver',
        \ 'cmd': {server_info->[&shell, &shellcmdflag, 'docker-langserver --stdio']},
        \ 'whitelist': ['dockerfile'],
        \ })
  endif

  " Vim LSP conf
  autocmd User lsp_setup call lsp#register_server({
        \ 'name': 'efm-langserver-vim',
        \ 'cmd': {server_info->['efm-langserver', '-stdin', &shell, &shellcmdflag, 'vint -']},
        \ 'whitelist': ['vim'],
        \ })

  " Go lang
  if executable('gopls')
    autocmd!
    autocmd User lsp_setup call lsp#register_server({
        \ 'name': 'gopls',
        \ 'cmd': {server_info->['gopls']},
        \ 'whitelist': ['go'],
        \ })
    autocmd BufWritePre *.go LspDocumentFormatSync
  endif

  " LSP Snippet
  call asyncomplete#register_source(asyncomplete#sources#neosnippet#get_source_options({
      \ 'name': 'neosnippet',
      \ 'whitelist': ['*'],
      \ 'completor': function('asyncomplete#sources#neosnippet#completor'),
      \ }))
augroup END

" Auto hover
" autocmd CursorMoved,CursorMovedI * call s:cursor_moved()

" set lsp
let g:lsp_diagnostics_enabled = 0
let g:lsp_diagnostics_echo_cursor = 0
let g:lsp_signs_error = {'text': '✗'}
let g:lsp_signs_warning = {'text': '‼', 'icon': '/path/to/some/icon'} " icons require GUI


augroup lsp_install
  au!
  " call s:on_lsp_buffer_enabled only for languages that has the server registered.
  autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END
"}}}

" ----------------------------------------------------------------------
" --- 6.2 Gitgutter
" ----------------------------------------------------------------------
"{{{
let g:gitgutter_sign_added = '✚'
let g:gitgutter_sign_modified = '➜'
let g:gitgutter_sign_removed = '✘'

"}}}

" ----------------------------------------------------------------------
" --- 6.3 Lightline
" ----------------------------------------------------------------------
"{{{
let g:lightline_delphinus_gitgutter_enable = 1

function! MyReadonly()
  return &filetype !~? 'help\|vimfiler\|gundo' && &readonly ? '' : ''
endfunction

" augroup AutoSyntastic
"   autocmd!
"   autocmd BufWritePost *.vim,*.sh,*.py call s:syntastic()
" augroup END
" function! s:syntastic()
"   SyntasticCheck
" endfunction

function! MyFugitive()
  try
    if &filetype !~? 'vimfiler\|gundo' && exists('*fugitive#head')
      let _ = fugitive#head()
      return strlen(_) ? ''._ : ''
    endif
  catch
  endtry
  return ''
endfunction

function! MyGitGutter()
  if ! exists('*GitGutterGetHunkSummary')
        \ || ! get(g:, 'gitgutter_enabled', 0)
        \ || winwidth('.') <= 90
    return ''
  endif
  let symbols = [
        \ g:gitgutter_sign_added . ' ',
        \ g:gitgutter_sign_modified . ' ',
        \ g:gitgutter_sign_removed . ' '
        \ ]
  let hunks = GitGutterGetHunkSummary()
  let ret = []
  for i in [0, 1, 2]
    if hunks[i] > 0
      call add(ret, symbols[i] . hunks[i])
    endif
  endfor
  return join(ret, ' ')
endfunction

function! LightlineLinterWarnings() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors
  return l:counts.total == 0 ? '' : printf('Hmmm..:%d', all_non_errors)
endfunction

function! LightlineLinterErrors() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors
  return l:counts.total == 0 ? '' : printf('Oh..:%d', all_errors)
endfunction

function! LightlineLinterOK() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors
  return l:counts.total == 0 ? 'GOOD!' : ''
endfunction

let g:lightline = {
    \ 'colorscheme': 'jellybeans',
    \ 'active': {
    \     'left': [ [ 'mode', 'paste' ],
    \               [ 'fugitive', 'gitgutter', 'readonly', 'filename', 'modified' ],
    \               [ 'linter_checking', 'linter_errors', 'linter_warnings', 'linter_ok' ] ],
    \     'right': [ [ 'lineinfo' ],
    \                [ 'percent' ],
    \                [ 'fileencoding', 'filetype' ] ]
    \ },
    \ 'component': {
    \     'lineinfo': '%3l:%-2v',
    \ },
    \ 'component_function': {
    \     'readonly': 'MyReadonly',
    \     'fugitive': 'MyFugitive',
    \     'gitgutter': 'MyGitGutter'
    \ },
    \ 'component_type': {
    \     'linter_checking': 'left',
    \     'linter_warnings': 'warning',
    \     'linter_errors': 'error',
    \     'linter_ok': 'left'
    \ },
    \ 'component_expand': {
    \  'linter_checking': 'lightline#ale#checking',
    \  'linter_warnings': 'LightlineLinterWarnings',
    \  'linter_errors': 'LightlineLinterErrors',
    \  'linter_ok': 'LightlineLinterOK'
    \ }
    \ }
"}}}

" ----------------------------------------------------------------------
" --- 6.4 ALE
" ----------------------------------------------------------------------
"{{{
" Linter config
let g:ale_linters = {
\   'javascript': ['eslint', 'eslint-plugin-vue'],
\   'sh': ['language_server', 'shell', 'shellcheck'],
\   'python': ['pyls'],
\   'go': ['gopls'],
\   'ruby': ['rubocop'],
\   'tex': ['textlint'],
\   'vim': ['vint'],
\   'markdown': ['textlint'],
\   'yaml': ['yamllint'],
\   'json': ['jsonlint'],
\   'css': ['stylelint'],
\}

let g:ale_fixers = {
\  'python': ['black'],
\  'sh': ['shfmt'],
\}

let g:ale_python_pyls_config = g:pyls_my_config

" variable set
let g:ale_enabled = 1
let g:ale_lint_on_save = 1
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_insert_leave = 0
let g:ale_lint_on_enter = 1
" let g:ale_open_list = 1
let g:ale_sign_error = '>>'
let g:ale_sign_warning = '!!'
let g:ale_echo_msg_error_str = '[ERROR]' . ' '
let g:ale_echo_msg_warning_str = '[WARN]' . ' '
let g:ale_echo_msg_info_str = '[INFO]' . ' '
let g:ale_echo_msg_format = '%severity%  %linter% - %s'
let g:ale_sign_column_always = 1

"}}}

" ----------------------------------------------------------------------
" --- 6.5 FZF
" ----------------------------------------------------------------------
"{{{
let g:fzf_action = {
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

"}}}

" ----------------------------------------------------------------------
" --- 6.6 Quickrun
" ----------------------------------------------------------------------
"{{{
" let g:quickrun_config = {
"       \ '*': {'runner': 'remote/vimproc'},
"       \ }
"}}}

"}}}

"=======================================================================
"=== 7. Key mapping =======================================================
"=======================================================================
"{{{
let mapleader="\<Space>" " Set leader key

" ----------------------------------------------------------------------
" --- 7.1 Moving key
" ----------------------------------------------------------------------
"{{{
" move line top
map H ^
" move line end
map L $

" Move display line
noremap j gj
noremap k gk

" Shift-j,Shift-k,jump to blank line
nnoremap <S-j> }
nnoremap <S-k> {

" Move screen
nnoremap <Leader>sw <C-w>w
nnoremap <Leader>sl <C-w>l
nnoremap <Leader>sh <C-w>h
nnoremap <Leader>sk <C-w>k
nnoremap <Leader>sj <C-w>j

nnoremap <Tab> %
nnoremap <S-Tab> %

" Insert mode keymap
"inoremap <C-j> <Down>
"inoremap <C-k> <Up>
" inoremap <C-h> <Left>
" inoremap <C-l> <Right>
" inoremap <C-c> <Esc>

"}}}

" ----------------------------------------------------------------------
" --- 7.2 File control key
" ----------------------------------------------------------------------
"{{{
" open .vimrc
nnoremap <Leader>. :vs ~/.vimrc<CR>

" File
nnoremap <silent>qq :q<CR>
nnoremap <Leader>q1 :q!<CR>
nnoremap <Leader>ww :w<CR>
nnoremap <Leader>wq :wq<CR>
nnoremap <Leader>vs :vs<CR>

"}}}

" ----------------------------------------------------------------------
" --- 7.3 Editor key map
" ----------------------------------------------------------------------
"{{{
" Show relative lines
nnoremap <silent> <Leader>n :set relativenumber!<CR>

" replace strings shortcut
nnoremap <Leader>re :%s;<C-R><C-W>;g<Left><Left>;

nnoremap <silent> <Esc><Esc> :nohlsearch<CR><ESC>

" Tab
nnoremap <Leader>tn :tabnew<CR>

nnoremap <Leader>p "0p
nnoremap <Leader>P "0P

" Search
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz
nnoremap g* g*zz
nnoremap g# g#zz

" jq keymap
nnoremap <Leader>jq :Jq<CR>

" inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
" inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
" inoremap <expr> <cr>    pumvisible() ? "\<C-y>" : "\<cr>"

" terminal mode keymap
tnoremap <C-o> <C-w>

" Open terminal with popup
nnoremap <silent> <Leader>pt :PopTerm<CR>

" Auto escape
cnoremap <expr> / getcmdtype() == '/' ? '\/' : '/'
cnoremap <expr> ? getcmdtype() == '?' ? '\?' : '?'

" Set
nnoremap <Plug>(my-switch) <Nop>
nmap <Leader>, <Plug>(my-switch)
nnoremap <silent> <Plug>(my-switch)s :<C-u>setl spell! spell?<CR>
nnoremap <silent> <Plug>(my-switch)l :<C-u>setl list! list?<CR>

"}}}

" ----------------------------------------------------------------------
" --- 7.4 Plugin key map
" ----------------------------------------------------------------------
"{{{
" Gitgutter
nnoremap <silent> <Leader>gf :GFiles<CR>
nnoremap <silent> <Leader>gs :GFiles?<CR>
nnoremap <silent> <Leader>gd :Gdiff<CR>
nnoremap <silent> <Leader>gb :Gblame<CR>
nnoremap <silent> <Leader>g] :GitGutterNextHunk<CR>
nnoremap <silent> <Leader>g[ :GitGutterPrevHunk<CR>

" Tagbar
nnoremap <silent> <F8> :TagbarToggle<CR>

" LSP
nnoremap <Leader>ld :LspDefinition<CR>
nnoremap <Leader>lh :LspHover<CR>
nnoremap <Leader>lr :LspReferences<CR>
nnoremap <Leader>ln :LspRename<CR>
nnoremap <Leader>lf :LspDocumentFormat<CR>

" Quickhighlight
nmap <Leader>m <Plug>(quickhl-manual-this)
xmap <Leader>m <Plug>(quickhl-manual-this)
nmap <Leader>M <Plug>(quickhl-manual-reset)
xmap <Leader>M <Plug>(quickhl-manual-reset)

" vim-surround
onoremap 9 i(
onoremap " i"
onoremap ' i'
onoremap ` i`
onoremap [ i[
onoremap { i{

" FZF
nnoremap <Leader>o :Files<CR>
nnoremap <Leader>b :Buffers<CR>

" NeoSnippet map
imap <C-k> <Plug>(neosnippet_expand_or_jump)
smap <C-k> <Plug>(neosnippet_expand_or_jump)
xmap <C-k> <Plug>(neosnippet_expand_target)

" NERDTree
nnoremap <silent><Leader>tf :NERDTreeToggle<CR>
let NERDTreeShowHidden = 1 " Disply hidden file

"}}}

"}}}

"=======================================================================
"=== 8. Other options =====================================================
"=======================================================================
"{{{
" For Hyper tereminal config
syntax on
"}}}
