"=== Specify character code ======================================================
set encoding=utf-8
scriptencoding utf-8

"=== dein =====================================================
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
"set runtimepath+=/home/giraffe/.cache/dein/repos/github.com/Shougo/dein.vim

" Required:
if dein#load_state(s:dein_path)
  call dein#begin(s:dein_path)

  let g:config_dir  = expand('$HOME/.cache/dein/plugins')
  let s:toml        = g:config_dir . '/plugins.toml'
  let s:lazy_toml   = g:config_dir . '/plugins_lazy.toml'

  call dein#load_toml(s:toml,    {'lazy': 0})
  call dein#load_toml(s:lazy_toml,    {'lazy': 1})

  " Let dein manage dein
  " Required:
  "call dein#add('/home/giraffe/.cache/dein/repos/github.com/Shougo/dein.vim')

  " Add or remove your plugins here like this:
  "call dein#add('Shougo/neosnippet.vim')
  "call dein#add('Shougo/neosnippet-snippets')

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


"=== Disply ======================================================
"set number
"set list
set ruler
set pumheight=10
set title
set textwidth=0

"=== Mute ======================================================
set t_vb=
set visualbell
set noerrorbells

"=== Color ======================================================
set t_Co=256
set background=dark

"--- color scheme list
"colorscheme solarized
colorscheme molokai
"colorscheme torte

"--- highlight cursor line for gray
set cursorline
highlight cursorline term=reverse cterm=none ctermbg=238
" set colorcolumn=80


"=== Search ======================================================
set incsearch
set ignorecase
set smartcase
set hlsearch

"=== Escape ======================================================
cnoremap <expr> / getcmdtype() == '/' ? '\/' : '/'
cnoremap <expr> ? getcmdtype() == '?' ? '\?' : '?'


"=== Editor ======================================================
set shiftround          " '<'や'>'でインデントする際に'shiftwidth'の倍数に丸める
set infercase           " 補完時に大文字小文字を区別しない
"set virtualedit=all     " カーソルを文字が存在しない部分でも動けるようにする
set hidden              " バッファを閉じる代わりに隠す（Undo履歴を残すため）
set switchbuf=useopen   " 新しく開く代わりにすでに開いてあるバッファを開く
set showmatch           " 対応する括弧などをハイライト表示する
set matchtime=3         " 対応括弧のハイライト表示を3秒にする

"=== Hilight brackets ======================================================
set matchpairs& matchpairs+=<:>

"=== Back space ======================================================
"set backspace=indent,eol,start


"=== Disable swap ======================================================
set nowritebackup
set nobackup
set noswapfile


"=== Tab to space ======================================================
set listchars=tab:^\ ,trail:~
set expandtab
set shiftwidth=2
set softtabstop=2
nnoremap <Esc><Esc> :nohlsearch<CR><ESC>

"=== Mouse ========================================================
"set mouse=a
"set ttymouse=xterm2

"=== Highlight Trailing Spaces ======================================================
augroup HighlightTrailingSpaces
  autocmd!
  autocmd VimEnter,WinEnter,ColorScheme * highlight TrailingSpaces term=underline guibg=Red ctermbg=Red
  autocmd VimEnter,WinEnter * match TrailingSpaces /\s\+$/
augroup END

"=== Buffer Windows ======================================================
"autocmd BufWinLeave ?* silent mkview
"autocmd BufWinEnter ?* silent loadview


"=== Debug ======================================================
" set verbosefile=/tmp/vim.log
" set verbose=20
