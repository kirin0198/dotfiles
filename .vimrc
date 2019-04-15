"=== Specify character code ======================================================
set encoding=utf-8
scriptencoding utf-8

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
syntax on
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
