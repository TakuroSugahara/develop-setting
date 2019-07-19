set encoding=utf-8
scriptencoding utf-8
filetype on

" neobundle settings {{{
if has('vim_starting')
    set nocompatible
    " neobundle をインストールしていない場合は自動インストール
    if !isdirectory(expand("~/.vim/bundle/neobundle.vim/"))
        echo "install neobundle..."
        " vim からコマンド呼び出しているだけ neobundle.vim のクローン
        :call system("git clone git://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim")
    endif
    " runtimepath の追加は必須
    set runtimepath+=~/.vim/bundle/neobundle.vim/
endif
call neobundle#begin(expand('~/.vim/bundle'))
let g:neobundle_default_git_protocol='https'

" neobundle#begin
NeoBundleFetch 'Shougo/neobundle.vim'
" color theme bobalt2
NeoBundle 'herrbischoff/cobalt2.vim'
" paste時にインデント崩れるのを防ぐ
NeoBundle 'ConradIrwin/vim-bracketed-paste'
" ctrlp ファイル検索
" NeoBundle "ctrlpvim/ctrlp.vim"
" fzf
NeoBundle 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
NeoBundle 'junegunn/fzf.vim', { 'depends': 'fzf' }
" gitが見やすい tig
NeoBundle 'iberianpig/tig-explorer.vim'
" ファイルツリー
NeoBundle 'scrooloose/nerdtree'
" コメントアウト機能
NeoBundle 'scrooloose/nerdcommenter'
" uniteなどの高速化
NeoBundle 'Shougo/vimproc', {
  \ 'build' : {
  \     'windows' : 'make -f make_mingw32.mak',
  \     'cygwin' : 'make -f make_cygwin.mak',
  \     'mac' : 'make -f make_mac.mak',
  \     'unix' : 'make -f make_unix.mak',
  \    },
  \ }
" 補完
if has('lua')
  " コードの自動補完
  NeoBundle 'Shougo/neocomplete.vim'
  NeoBundle 'Shougo/neocomplcache.vim'
  " スニペットの補完機能
  NeoBundle "Shougo/neosnippet"
  " スニペット集
  NeoBundle 'Shougo/neosnippet-snippets'
endif
" lint系ツール
NeoBundle 'w0rp/ale'
" 自動カッコ閉じ
NeoBundle 'Townk/vim-autoclose'
" 自動カッコ閉じ
NeoBundle 'osyo-manga/vim-over'
" ctrlpでgitignoreを無視する
" gitの表示をしてくれる
NeoBundle 'airblade/vim-gitgutter'
" gxでgoogle検索ができる
NeoBundle 'tyru/open-browser.vim'

" 言語系 {{{
" オールラウンダー(他の言語系のものがいらない可能性あり)
NeoBundle 'sheerun/vim-polyglot'
" firestoreのセキュリティルール
NeoBundle 'delphinus/vim-firestore'

" TSファイルでのESエラー回避
let g:syntastic_typescript_tsc_args = "--experimentalDecorators --target ES5"
" }}}

" nerdtree {{{
nmap <silent><C-n> :NERDTreeToggle<CR>
" }}}

" ale {{{
let g:ale_sign_column_always = 1
let g:ale_linters = {
      \ 'javascript': ['eslint'],
      \ }
let g:ale_fixers = {
	\ 'javascript': ['prettier', 'eslint'],
	\ 'python': ['autopep8', 'isort'],
	\ }
let g:ale_fix_on_save = 1
let g:ale_statusline_format = ['E%d', 'W%d', '']
" }}}

" 置換すぐに出す
nnoremap <S-s> :OverCommandLine<CR>%s/

" tig 設定 {{{
nnoremap <silent> gs :TigOpenCurrentFile<CR>
" }}}

" fzfでの全検索とファイル検索 {{{
nnoremap <S-f> :GGrep<Space>
nnoremap <C-p> :GFiles<CR>
" nnoremap <silent> gs :GFiles?<CR>
let g:fzf_layout = { 'up': '~40%' }
command! -bang -nargs=* GGrep
  \ call fzf#vim#grep(
  \   'git grep --line-number '.shellescape(<q-args>), 0,
  \   fzf#vim#with_preview({ 'dir': systemlist('git rev-parse --show-toplevel')[0] }), <bang>0)
" }}}


" NERDCommenter vue の設定 {{{
let g:ft = ''
function! NERDCommenter_before()
  if &ft == 'vue'
    let g:ft = 'vue'
    let stack = synstack(line('.'), col('.'))
    if len(stack) > 0
      let syn = synIDattr((stack)[0], 'name')
      if len(syn) > 0
        exe 'setf ' . substitute(tolower(syn), '^vue_', '', '')
      endif
    endif
  endif
endfunction
function! NERDCommenter_after()
  if g:ft == 'vue'
    setf vue
    let g:ft = ''
  endif
endfunction
" }}}

" airblade/vim-gitgutterの設定 {{{
set updatetime=250
highlight GitGutterAdd ctermfg=lightgreen
highlight GitGutterChangeLine ctermfg=darkblue
highlight GitGutterDeleteLine ctermfg=lightred
" }}}

" open-browser.vim {{{
" 1. Vim でファイルを開いて、ノーマルモードで URL 文字列にカーソルを置く。
" 2. ノーマルモードで ‘gx’ とタイプすると URL がブラウザで開かれる。
" 3. URL ではない文字列にカーソルを置いて ‘gx’ と打つと、検索エンジンでカーソル上の文字列を検索した結果が表示される。
" 4. 上手く開けない場合は、URL や検索したい文字列をビジュアルモードで選択後に ‘gx’ と打つ。
let g:netrw_nogx = 1 " disable netrw's gx mapping.
nmap gx <Plug>(openbrowser-search)
vmap gx <Plug>(openbrowser-search)
"}}}

" neocomplete {{{
if neobundle#is_installed('neocomplete.vim')
    " Vim起動時にneocompleteを有効にする
    let g:neocomplete#enable_at_startup = 1
    " smartcase有効化. 大文字が入力されるまで大文字小文字の区別を無視する
    let g:neocomplete#enable_smart_case = 1
    " 3文字以上の単語に対して補完を有効にする
    let g:neocomplete#min_keyword_length = 3
    " 区切り文字まで補完する
    let g:neocomplete#enable_auto_delimiter = 1
    " 1文字目の入力から補完のポップアップを表示
    let g:neocomplete#auto_completion_start_length = 1
    " バックスペースで補完のポップアップを閉じる
    inoremap <expr><BS> neocomplete#smart_close_popup()."<C-h>"

    " エンターキーで補完候補の確定. スニペットの展開もエンターキーで確定・・・・・・②
    imap <expr><CR> neosnippet#expandable() ? "<Plug>(neosnippet_expand_or_jump)" : pumvisible() ? "<C-y>" : "<CR>"
    " タブキーで補完候補の選択. スニペット内のジャンプもタブキーでジャンプ・・・・・・③
    imap <expr><TAB> pumvisible() ? "<C-n>" : neosnippet#jumpable() ? "<Plug>(neosnippet_expand_or_jump)" : "<TAB>"
endif
" 最初の補完候補を選択状態にする
set completeopt+=noinsert
" }}}

" NERD Commenter でコメント後に空白を空ける
let g:NERDSpaceDelims=1

" vimrc に記述されたプラグインでインストールされていないものがないかチェックする
NeoBundleCheck
call neobundle#end()
filetype plugin indent on

set fileencoding=utf-8 " 保存時の文字コード
set fileencodings=ucs-boms,utf-8,euc-jp,cp932 " 読み込み時の文字コードの自動判別. 左側が優先される
set fileformats=unix,dos,mac " 改行コードの自動判別. 左側が優先される
set ambiwidth=double "□や○文字が崩れる問題を解決

set laststatus=2 " ステータスラインを常に表示
set showmode " 現在のモードを表示
set showcmd " 打ったコマンドをステータスラインの下に表示
set ruler " ステータスラインの右側にカーソルの位置を表示する

set wildmenu " コマンドモードの補完
set history=5000 " 保存するコマンド履歴の数

set expandtab " タブ入力を複数の空白入力に置き換える
set tabstop< " 画面上でタブ文字が占める幅
set softtabstop=2 " 連続した空白に対してタブキーやバックスペースキーでカーソルが動く幅
set shiftwidth=2 " smartindentで増減する幅
set autoindent " 改行時に前の行のインデントを継続する
set smartindent " 改行時に前の行の構文をチェックし次の行のインデントを増減する

if has("autocmd")
  "ファイルタイプの検索を有効にする
  filetype plugin on
  "ファイルタイプに合わせたインデントを利用
  filetype indent on
  "sw=softtabstop, sts=shiftwidth, ts=tabstop, et=expandtabの略
  autocmd FileType c           setlocal sw=4 sts=4 ts=4 et
  autocmd FileType html        setlocal sw=2 sts=2 ts=2 et
  autocmd FileType ruby        setlocal sw=2 sts=2 ts=2 et
  autocmd FileType js          setlocal sw=2 sts=2 ts=2 et
  autocmd FileType javascript  setlocal sw=2 sts=2 ts=2 et
  autocmd FileType ts          setlocal sw=2 sts=2 ts=2 et
  autocmd FileType typescript  setlocal sw=2 sts=2 ts=2 et
  autocmd FileType zsh         setlocal sw=4 sts=4 ts=4 et
  autocmd FileType python      setlocal sw=4 sts=4 ts=4 et
  autocmd FileType scala       setlocal sw=4 sts=4 ts=4 et
  autocmd FileType json        setlocal sw=2 sts=2 ts=2 et
  autocmd FileType css         setlocal sw=2 sts=2 ts=2 et
  autocmd FileType scss        setlocal sw=2 sts=2 ts=2 et
  autocmd FileType sass        setlocal sw=2 sts=2 ts=2 et
endif

set incsearch " インクリメンタルサーチ. １文字入力毎に検索を行う
set ignorecase " 検索パターンに大文字小文字を区別しない
set smartcase " 検索パターンに大文字を含んでいたら大文字小文字を区別する
set hlsearch " 検索結果をハイライト

set number " 行番号を表示

" パフォーマンスを上げる
set nocursorline "これをオンにするとjkでの移動でCPUがかなり食われるので明示的に避ける
set synmaxcol=200 "ハイライトの範囲を指定

" 行が折り返し表示されていた場合、行単位ではなく表示行単位でカーソルを移動する
nmap j gj
nmap k gk
nmap <down> gj
nmap <up> gk

nmap O :<C-u>call append(expand('.'), '')<Cr>j

" バックスペースキーの有効化
set backspace=indent,eol,start

set showmatch " 括弧の対応関係を一瞬表示する
source $VIMRUNTIME/macros/matchit.vim " Vimの「%」を拡張する

"----------------------------------------------------------
" マウスでカーソル移動とスクロール
"----------------------------------------------------------
if has('mouse')
    set mouse=a
    if has('mouse_sgr')
        set ttymouse=sgr
    elseif v:version > 703 || v:version is 703 && has('patch632')
        set ttymouse=sgr
    else
        set ttymouse=xterm2
    endif
endif

" 挿入モードでクリップボードからペーストする時に自動でインデントさせないようにする
if &term =~ "xterm"
    let &t_SI .= "\e[?2004h"
    let &t_EI .= "\e[?2004l"
    let &pastetoggle = "\e[201~"

    function _XTermPasteBegin(ret)
        set paste
        return a:ret
    endfunction

    imap <special> <expr> <Esc>[200~ _XTermPasteBegin("")
endif

" swapファイルを作らない
set noswapfile
set nobackup
set nowrap

" 自動でコメントをつけない
au FileType * setlocal formatoptions-=ro

"vimgrep をする時に早く表示する
autocmd QuickFixCmdPost vimgrep cwindow

" クリップボードとvimを連携コピペが簡単になる
set clipboard+=unnamed

" ショートカットキー
nmap <space> :
nmap / /\v
nmap f *
nnoremap x "_x
noremap <S-h>   ^
noremap <S-j>   L
noremap <S-k>   H
noremap <S-l>   $
map m  %
nmap ; :
nmap <C-_> <Plug>NERDCommenterToggle
vmap <C-_> <Plug>NERDCommenterToggle
map! <C-V> <C-r>0

" color scheme
autocmd ColorScheme * highlight Normal ctermbg=none
autocmd ColorScheme * highlight NonText ctermbg=none

syntax enable
colorscheme cobalt2

" 検索のカラー cobalt2の検索カラーがないので
hi Search ctermbg=DarkYellow

