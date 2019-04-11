""" Disply
"set number
set list
set pumheight=10
set title
set textwidth=0
set colorcolumn=80

""" Mute
set t_vb=
set novisualbell

""" Color
set t_Co=256
set cursorline
syntax on
highlight cursorline term=reverse cterm=none ctermbg=236
"colorscheme torte
"set colorcolumn=80


""" search
set incsearch
set ignorecase
set smartcase
set hlsearch

""" Escape
cnoremap <expr> / getcmdtype() == '/' ? '\/' : '/'
cnoremap <expr> ? getcmdtype() == '?' ? '\?' : '?'


" Editor
set shiftround          " '<'や'>'でインデントする際に'shiftwidth'の倍数に丸める
set infercase           " 補完時に大文字小文字を区別しない
"set virtualedit=all     " カーソルを文字が存在しない部分でも動けるようにする
set hidden              " バッファを閉じる代わりに隠す（Undo履歴を残すため）
set switchbuf=useopen   " 新しく開く代わりにすでに開いてあるバッファを開く
set showmatch           " 対応する括弧などをハイライト表示する
set matchtime=3         " 対応括弧のハイライト表示を3秒にする

""" Hilight brackets
set matchpairs& matchpairs+=<:>

""" Back space
"set backspace=indent,eol,start


""" Disable swap
set nowritebackup
set nobackup
set noswapfile


""" Tab to space
set listchars=tab:^\ ,trail:~
set expandtab
set shiftwidth=2
set softtabstop=2
nnoremap <Esc><Esc> :nohlsearch<CR><ESC>

""" Highlight Trailing Spaces
augroup HighlightTrailingSpaces
  autocmd!
  autocmd VimEnter,WinEnter,ColorScheme * highlight TrailingSpaces term=underline guibg=Red ctermbg=Red
  autocmd VimEnter,WinEnter * match TrailingSpaces /\s\+$/
augroup END
autocmd BufWinLeave ?* silent mkview
autocmd BufWinEnter ?* silent loadview
