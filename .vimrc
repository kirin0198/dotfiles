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
"=== Specify character code ============================================
"=======================================================================
"{{{
set encoding=utf-8
scriptencoding utf-8

let g:python3_host_prog=expand('/usr/bin/python3.6')
"}}}

"=======================================================================
"=== dein ==============================================================
"=======================================================================
"{{{
if &compatible
  set nocompatible               " Be iMproved
endif

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
    call dein#add('Shougo/neco-vim')
    call dein#add('Shougo/neco-syntax')
    call dein#add('ujihisa/neco-look')
    if !has('nvim')
        call dein#add('roxma/nvim-yarp')
        call dein#add('roxma/vim-hug-neovim-rpc')
    endif
  endif

  " let g:deoplete#enable_at_startup = 0

  " Let dein manage dein
  " Required:
  "call dein#add('/home/giraffe/.cache/dein/repos/github.com/Shougo/dein.vim')

  " Add or remove your plugins here like this:
  call dein#add('Shougo/neosnippet.vim')
  call dein#add('Shougo/neosnippet-snippets')
  let g:neosnippet#enable_snipmate_compatibility = 1
  let g:neosnippet#snippets_directory='~/.vim/dein/vim-snippets/snippets'

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
  call dein#add('autozimu/LanguageClient-neovim', {'rev': 'next', 'build': 'bash install.sh'})

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
syntax enable

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
"=== Language Server Protcol (Complement) ===================================================
"=======================================================================
"{{{
" Bash LSP conf
let g:LanguageClient_serverCommands = {
    \ 'sh': ['bash-language-server', 'start']
    \ }
" Python LSP conf
if executable('pyls')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'pyls',
        \ 'cmd': {server_info->['pyls']},
        \ 'whitelist': ['python'],
        \ })
endif
"}}}

"=======================================================================
"=== Editor ============================================================
"=======================================================================
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

" Undo,Redo
if has('persistent_undo')
  set undodir=~/.vim/undo
  set undofile
endif
" log level
set undolevels=1000
" fzf variables
let g:fzf_action = {
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }
" set ale
let g:ale_linters = {
\   'javascript': ['eslint', 'eslint-plugin-vue'],
\   'sh': ['shell'],
\   'python': ['pyflakes', 'pep8'],
\   'json': ['jsonlint'],
\   'ruby': ['rubocop'],
\   'tex': ['textlint'],
\   'markdown': ['textlint'],
\   'css': ['stylelint'],
\}
let g:ale_lint_on_save = 1
let g:ale_lint_on_text_changed = 0
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 1
let g:ale_echo_msg_error_str = nr2char(0xf421) . ' '
let g:ale_echo_msg_warning_str = nr2char(0xf420) . ' '
let g:ale_echo_msg_info_str = nr2char(0xf05a) . ' '
let g:ale_echo_msg_format = '%severity%  %linter% - %s'
let g:ale_sign_column_always = 1
let g:ale_sign_error = g:ale_echo_msg_error_str
let g:ale_sign_warning = g:ale_echo_msg_warning_str
let g:ale_statusline_format = [
      \ g:ale_echo_msg_error_str . ' %d',
      \ g:ale_echo_msg_warning_str . ' %d',
      \ nr2char(0xf4a1) . '  ']
let g:lightline_delphinus_gitgutter_enable = 1
" set syntastic
" let g:syntastic_mode_map = {
"   \ 'mode': 'passive',
"   \ 'active_filetypes': ['sh', 'py', 'vim' ]
"   \ }

command! -nargs=? Jq call s:Jq(<f-args>)
function! s:Jq(...)
  if 0 == a:0
    let l:arg = "."
  else
    let l:arg = a:1
  endif
  execute "%! jq \"" . l:arg . "\""
endfunction

"}}}

"=======================================================================
"=== Visual ============================================================
"=======================================================================
"{{{
set number
"set list
set ambiwidth=double
set ruler
set pumheight=10
set title
set textwidth=0
set completeopt=menu,preview "Disply complete preview

let g:netrw_liststyle=1
let g:netrw_banner=0
let g:netrw_sizestyle="H"
let g:netrw_timefmt="%Y/%m/%d(%a) %H:%M:%S"
let g:netrw_preview=1

" Colors
set background=dark

" color scheme list
"colorscheme solarized
colorscheme molokai
"colorscheme torte

" highlight cursor line for gray
set cursorline
highlight cursorline term=reverse cterm=none ctermbg=236
" set colorcolumn=80

set laststatus=2

" GitGutter
let g:gitgutter_sign_added = '✚'
let g:gitgutter_sign_modified = '➜'
let g:gitgutter_sign_removed = '✘'

" airline setting (need powerline)
"let g:airline_powerline_fonts = 1
"let g:airline_theme = 'molokai'
"let g:airline#extensions#tabline#enabled = 1
"let g:airline#extensions#tabline#formatter = 'unique_tail'

" lightline setting
set noshowmode

if !has('gui_running')
  set t_Co=256
endif

function! MyReadonly()
  return &ft !~? 'help\|vimfiler\|gundo' && &readonly ? '' : ''
endfunction

" augroup AutoSyntastic
"   autocmd!
"   autocmd BufWritePost *.vim,*.sh,*.py call s:syntastic()
" augroup END
" function! s:syntastic()
"   SyntasticCheck
"   call lightline#update()
" endfunction

function! MyFugitive()
  try
    if &ft !~? 'vimfiler\|gundo' && exists('*fugitive#head')
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
    \ 'colorscheme': 'seoul256',
    \ 'active': {
    \     'left': [ [ 'mode', 'paste' ],
    \               [ 'fugitive', 'gitgutter', 'readonly', 'filename', 'modified' ],
    \               [ 'linter_checking', 'linter_errors', 'linter_warnings', 'linter_ok' ] ],
    \     'right': [ [ 'lineinfo' ],
    \                [ 'percent' ],
    \                [ 'fileformat', 'fileencoding', 'filetype' ] ]
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

" Update and show lightline but only if it's visible
function! s:MaybeUpdateLightline()
  if exists('#lightline')
    call lightline#update()
  end
endfunction

" Update the lightline scheme from the colorscheme. Hopefully.
function! s:UpdateLightlineColorScheme()
  let g:lightline.colorscheme = g:colors_name
  call lightline#init()
endfunction

augroup _lightline
  autocmd!
  autocmd User ALELint call s:MaybeUpdateLightline()
  autocmd ColorScheme * call s:UpdateLightlineColorScheme()
augroup END

"}}}

"=======================================================================
"=== key mapping =======================================================
"=======================================================================
"{{{
" Set leader key
let mapleader="\<Space>"

" General keymap
" move line top
map H ^
" move line end
map L $

" Nomal mode keymap
" Move display line
noremap j gj
noremap k gk
" open .vimrc
nnoremap <Leader>. :vs ~/.vimrc<CR>
"nnoremap <Leader>, :split ~/.cache/dein/plugins/plugins.toml<CR>

" Shift-j,Shift-k,jump to blank line
nnoremap <S-j> }
nnoremap <S-k> {

" Show relative lines
nnoremap <silent> <Leader>n :set relativenumber!<CR>

" replace strings shortcut
nnoremap <Leader>re :%s;<C-R><C-W>;g<Left><Left>;

nnoremap <Esc><Esc> :nohlsearch<CR><ESC>

" Directory Tree for NERDTree
nnoremap <silent><Leader>t :NERDTreeToggle<CR>
let NERDTreeShowHidden = 1 " Disply hidden file

" Tab
nnoremap <Leader>tn :tabnew<CR>
nnoremap <Tab> gt
nnoremap <S-Tab> gT

" Move screen
nnoremap <Leader>sw <C-w>w
nnoremap <Leader>sl <C-w>l
nnoremap <Leader>sh <C-w>h
nnoremap <Leader>sk <C-w>k
nnoremap <Leader>sj <C-w>j

" Open terminal
nnoremap <silent> <Leader>te :terminal<CR>

" Git keymap
nnoremap <silent> <Leader>gf :GFiles<CR>
nnoremap <silent> <Leader>gs :GFiles?<CR>
nnoremap <silent> <Leader>gd :Gdiff<CR>
nnoremap <silent> <Leader>gb :Gblame<CR>
nnoremap <silent> <Leader>g] :GitGutterNextHunk<CR>
nnoremap <silent> <Leader>g[ :GitGutterPrevHunk<CR>

" File
nnoremap <Leader>fo :Files<CR>
nnoremap qq :q<CR>
nnoremap <Leader>q1 :q!<CR>
nnoremap <Leader>ww :w<CR>
nnoremap <Leader>wq :wq<CR>
nnoremap <Leader>vs :vs<CR>
nnoremap <Leader>bn :bn<CR>

nnoremap <Leader>p "0p
nnoremap <Leader>P "0P

" jq keymap
nnoremap <Leader>jq :Jq<CR>

" QuickhighlightPlug
nmap <Leader>m <Plug>(quickhl-manual-this)
xmap <Leader>m <Plug>(quickhl-manual-this)
nmap <Leader>M <Plug>(quickhl-manual-reset)
xmap <Leader>M <Plug>(quickhl-manual-reset)

" Insert mode keymap
"inoremap <C-j> <Down>
"inoremap <C-k> <Up>
inoremap <C-h> <Left>
inoremap <C-l> <Right>
inoremap <C-c> <Esc>

" terminal mode keymap
tnoremap <C-o> <C-w>

" Operator mode keymap
onoremap 9 i(
onoremap " i"
onoremap ' i'
onoremap ` i`
onoremap [ i[
onoremap { i{

" Command mode keymap
cnoremap <expr> / getcmdtype() == '/' ? '\/' : '/'
cnoremap <expr> ? getcmdtype() == '?' ? '\?' : '?'

" NeoSnippet map
imap <C-k> <Plug>(neosnippet_expand_or_jump)
smap <C-k> <Plug>(neosnippet_expand_or_jump)
xmap <C-k> <Plug>(neosnippet_expand_target)

"}}}

"=======================================================================
"=== Other options =====================================================
"=======================================================================
"{{{
" Indent
set autoindent
set smartindent
set smarttab
set expandtab
set listchars=tab:^\ ,trail:~
set tabstop=2
set shiftwidth=2
set softtabstop=2
set conceallevel=0
let g:vim_json_syntax_conceal = 0

if has("autocmd")
  filetype plugin on
  filetype indent on
  "sw=softtabstop, sts=shiftwidth, ts=tabstop, et=expandtab
  autocmd FileType c           setlocal sw=4 sts=4 ts=4 et
  autocmd FileType html        setlocal sw=4 sts=4 ts=4 et
  autocmd FileType ruby        setlocal sw=2 sts=2 ts=2 et
  autocmd FileType js          setlocal sw=4 sts=4 ts=4 et
  autocmd FileType vim         setlocal sw=2 sts=2 ts=2 et
  autocmd FileType sh          setlocal sw=2 sts=2 ts=2 et
  autocmd FileType zsh         setlocal sw=4 sts=4 ts=4 et
  autocmd FileType python      setlocal sw=4 sts=4 ts=4 et
  autocmd FileType scala       setlocal sw=4 sts=4 ts=4 et
  autocmd FileType json        setlocal sw=4 sts=4 ts=4 et
  autocmd FileType html        setlocal sw=4 sts=4 ts=4 et
  autocmd FileType css         setlocal sw=4 sts=4 ts=4 et
  autocmd FileType scss        setlocal sw=4 sts=4 ts=4 et
  autocmd FileType sass        setlocal sw=4 sts=4 ts=4 et
  autocmd FileType javascript  setlocal sw=4 sts=4 ts=4 et
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

" Marker
au FileType text,markdown,vim setlocal foldmethod=marker

" Highlight Trailing Spaces
augroup HighlightTrailingSpaces
  autocmd!
  autocmd VimEnter,WinEnter,ColorScheme * highlight TrailingSpaces term=underline guibg=Red ctermbg=Red
  autocmd VimEnter,WinEnter * match TrailingSpaces /\s\+$/
augroup END

" Paste
if &term =~ "xterm"
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

"}}}

