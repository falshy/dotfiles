
if has('mac')
 "let g:vimproc_dll_path = $VIMRUNTIME. '/autoload/proc.so'
 let g:vimproc_dll_path = $VIMRUNTIME. '/autoload/vimproc_mac.so'
endif

" 全般設定
" ----------------
set nocompatible	" 必ず最初に書く
set viminfo='20,<50,s10,h,!	"YankRing用に!を追加
set shellslash		" Windowsでディレクトリパスの区切り文字に/を使えるようにする
set lazyredraw		" マクロなどを実行中は描画を中断
set number
set ruler
set cmdheight=2
set laststatus=2
set statusline=%<%f\ %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=%l,%c%V%8P
set title
set wildmenu
set linespace=0
set showcmd

" タブページの切り替えをWindowsのように
" CTRL+Tab SHIFT+Tabで行うようにする
if v:version >= 700
  nnoremap <C-Tab>   gt
  nnoremap <C-S-Tab> gT
endif


" コマンド補完
" ----------------
set wildmenu		" コマンド補完を強化
set wildmode=list:full	" リスト表示、最長マッチ
autocmd FileType * setlocal formatoptions-=ro 	" 改行時にコメントを自動挿入しない

"syntax color
" ----------------
syntax on
highlight LineNr ctermfg=darkgray

" search
" ----------------
set ignorecase		" 大文字小文字無視
set smartcase		" 大文字ではじめたら大文字小文字無視しない
set wrapscan		" 最後まで検索したら先頭へ戻る
set hlsearch		" 検索文字をハイライト

" edit
" ----------------
set autoindent
set cindent
set showmatch		" 括弧の対応をハイライト
set backspace=indent,eol,start
set clipboard=unnamed
set pastetoggle=<F12>
set guioptions+=a

" tab
" ----------------
set tabstop=4		" tabstopはTab文字を画面上で何文字分に展開するか
set smarttab
set shiftwidth=4
set shiftround
set nowrap

" backup
" ----------------
"set backup
"set backupdir=~/vim_backup
"set swapfile
"set directory=~/vim_swap
set nobackup		" バックアップ取らない
set autoread		" 他で書き換えられたら自動で読み直す
set noswapfile		" スワップファイル作らない
"set hidden		" 編集中でも他のファイルを開けるようにする

" doc
" ----------------
"helptags ~/.vim/doc

" 文字コードの自動認識
if &encoding !=# 'utf-8'
  set encoding=japan
  set fileencoding=japan
endif
if has('iconv')
  let s:enc_euc = 'euc-jp'
  let s:enc_jis = 'iso-2022-jp'
  " iconvがeucJP-msに対応しているかをチェック
  if iconv("\x87\x64\x87\x6a", 'cp932', 'eucjp-ms') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'eucjp-ms'
    let s:enc_jis = 'iso-2022-jp-3'
  " iconvがJISX0213に対応しているかをチェック
  elseif iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'euc-jisx0213'
    let s:enc_jis = 'iso-2022-jp-3'
  endif
  " fileencodingsを構築
  if &encoding ==# 'utf-8'
    let s:fileencodings_default = &fileencodings
    let &fileencodings = s:enc_jis .','. s:enc_euc .',cp932'
    let &fileencodings = &fileencodings .','. s:fileencodings_default
    unlet s:fileencodings_default
  else
    let &fileencodings = &fileencodings .','. s:enc_jis
    set fileencodings+=utf-8,ucs-2le,ucs-2
    if &encoding =~# '^\(euc-jp\|euc-jisx0213\|eucjp-ms\)$'
      set fileencodings+=cp932
      set fileencodings-=euc-jp
      set fileencodings-=euc-jisx0213
      set fileencodings-=eucjp-ms
      let &encoding = s:enc_euc
      let &fileencoding = s:enc_euc
    else
      let &fileencodings = &fileencodings .','. s:enc_euc
    endif
  endif
  " 定数を処分
  unlet s:enc_euc
  unlet s:enc_jis
endif
" 日本語を含まない場合は fileencoding に encoding を使うようにする
if has('autocmd')
  function! AU_ReCheck_FENC()
    if &fileencoding =~# 'iso-2022-jp' && search("[^\x01-\x7e]", 'n') == 0
      let &fileencoding=&encoding
    endif
  endfunction
  autocmd BufReadPost * call AU_ReCheck_FENC()
endif
" 改行コードの自動認識
set fileformats=unix,dos,mac
" □とか○の文字があってもカーソル位置がずれないようにする
if exists('&ambiwidth')
  set ambiwidth=double
endif

" 括弧入力後に←に移動
" imap {} {}<Left>
" imap [] []<Left>
" imap () ()<Left>
" imap "" ""<Left>
" imap '' ''<Left>
" imap <> <><Left>Left

" plugin
" ----------------
" neobundle.vim
set nocompatible
filetype off

if has('vim_starting')
 "set runtimepath+=~/.vim/neobundle.vim.git
 set runtimepath+=~/dotfiles/vimfiles/neobundle.git
 call neobundle#rc()
endif

NeoBundle 'git://github.com/Shougo/neobundle.vim.git'
NeoBundle 'git://github.com/Shougo/vimshell.git'
NeoBundle 'git://github.com/Shougo/neocomplcache.git'
NeoBundle 'git://github.com/Shougo/unite.vim.git'
NeoBundle 'git://github.com/thinca/vim-quickrun.git'
NeoBundle 'git://github.com/Shougo/vimproc.git'
NeoBundle 'git://github.com/scrooloose/nerdtree.git'
NeoBundle 'git://github.com/kana/vim-smartinput.git'

filetype plugin on
filetype indent on

" vim-quickrun
" 横分割をするようにする
let g:quickrun_config={'*': {'split': ''}}
" 横分割時は下へ､ 縦分割時は右へ新しいウィンドウが開くようにする
set splitbelow
set splitright


""""""""""""""""""""""""""""""
"挿入モード時、ステータスラインの色を変更
""""""""""""""""""""""""""""""
let g:hi_insert = 'highlight StatusLine guifg=darkblue guibg=darkyellow gui=none ctermfg=blue ctermbg=yellow cterm=none'

if has('syntax')
  augroup InsertHook
    autocmd!
    autocmd InsertEnter * call s:StatusLine('Enter')
    autocmd InsertLeave * call s:StatusLine('Leave')
  augroup END
endif

let s:slhlcmd = ''
function! s:StatusLine(mode)
  if a:mode == 'Enter'
    silent! let s:slhlcmd = 'highlight ' . s:GetHighlight('StatusLine')
    silent exec g:hi_insert
  else
    highlight clear StatusLine
    silent exec s:slhlcmd
  endif
endfunction

function! s:GetHighlight(hi)
  redir => hl
  exec 'highlight '.a:hi
  redir END
  let hl = substitute(hl, '[\r\n]', '', 'g')
  let hl = substitute(hl, 'xxx', '', '')
  return hl
endfunction

" --- ファイラーを起動 ---
nnoremap <silent><Space>o    :Explore<CR>
