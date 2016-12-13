" vim: foldmethod=marker
set nocompatible                " use vim defaults {{{1
set t_RV=                       " http://bugs.debian.org/608242
" set runtimepath=$VIMRUNTIME     " turn off user scripts,
" https://github.com/igrigorik/vimgolf/issues/129

syntax on                       " turn syntax highlighting on by default
filetype on                     " detect type of file

set encoding=utf-8
set fileencodings=utf-8,gb2312,gb18030,gbk,ucs-bom,cp936,latin1 " 如果你要打开的文件编码不在此列，那就添加进去
set termencoding=utf-8 "

set nobackup                    " do not keep a backup file
set novisualbell                " turn off visual bell
set visualbell t_vb=            " turn off error beep/flash

set ruler                       " show the current row and column
set number                      " show line numbers
set showcmd                     " display incomplete commands
set showmode                    " display current modes

set scrolloff=8                 " keep 3 lines when scrolling
set backspace=indent,eol,start  " make that backspace key work the way it should
set showmatch                   " jump to matches when entering parentheses
set matchtime=1                 " tenths of a second to show the matching parenthesis

set hlsearch                    " highlight searches
set incsearch                   " do incremental searching
set ignorecase                  " ignore case when searching
set smartcase                   " no ignorecase if Uppercase char present

set timeout timeoutlen=5000 ttimeoutlen=100 " the solution -> Delay before 'O'

" Default indenting options
set expandtab smarttab
set autoindent smartindent shiftround
set ts=2 sts=2 sw=2 expandtab

set wildmode=list " auto-complete mode

function! ChangeToStyles()
  :%s/;//g | :%s/ \?{//g | :%s/}//g
endfunction

" Only do this part when compiled with support for autocommands
if has("autocmd") "{{{1
  " Enable file type detection

  " Customisations based on house-style (arbitrary)
  autocmd Filetype gitcommit setlocal spell textwidth=72

  " Treat .rss files as XML

  autocmd BufNewFile,BufRead *.md set ts=4 sts=4 sw=4 noexpandtab
  autocmd BufNewFile,BufRead *.js set ts=2 sts=2 sw=2 expandtab
  autocmd BufNewFile,BufRead *.h set filetype=c
  autocmd BufNewFile,BufReadPost *.md set filetype=markdown
  autocmd BufNewFile,BufRead *.rss setfiletype xml
  autocmd BufWritePre *.py,*.js :call <SID>StripTrailingWhitespaces()
  autocmd BufRead,BufNewFile *.erb setfiletype eruby
  autocmd BufNewFile,BufReadPost *.c map <leader>r :w\|!gcc % && ./a.out<cr>
  autocmd BufNewFile,BufReadPost *.js map <leader>r :w\|!node %
  autocmd BufWritePre  *.sass,*.styl nnoremap <leader>t :call ChangeToStyles();<cr>


  " auto source .vimrc
  autocmd BufWritePost .vimrc source $MYVIMRC
endif

" Identify invisible characters and don't show them by default
"set list listchars=eol:¬,tab:▸\ ,trail:.,

set autoread

set t_Co=256 """{{{1
set background=dark
" solarized options
let g:solarized_termcolors = 256
" let g:solarized_visibility = "high"
" let g:solarized_contrast = "high"
colorscheme solarized
" colorscheme molokai
let g:molokai_original = 1
let g:rehash256 = 1

" Make comments and special characters look better
highlight Comment    ctermfg=245 guifg=#8a8a8a
highlight NonText    ctermfg=240 guifg=#585858
highlight SpecialKey ctermfg=240 guifg=#585858

" " Use the same symbols as TextMate for tabstops and EOLs
set list
set listchars=tab:▸\ ,eol:¬
command! -nargs=* Wrap set wrap linebreak nolist
set showbreak=â€¦

"map {{{1
let mapleader=","
let maplocalleader = "\\"

function! RemoveTab()
  :%s/\t/  /g | :%s/\s$//
endfunction

" Shortcut to rapidly toggle `set list`
nmap <leader>t :call RemoveTab()<cr>
nmap <leader>l :set list!<cr>
nmap <leader>m :set number!<cr>
nmap <leader>v :tabedit $MYVIMRC<cr>
nmap <leader>a :tabedit .<cr>
nmap <leader>e :e %:h<cr>
nmap <leader>s :vs %:h<cr>
nmap <leader>ne :e .<cr>
" nmap <leader>t :tabedit ~/todo.md<cr>
nnoremap <leader>" viw<esc>a"<esc>hbi"<esc>lel

" leader save
nmap <leader><space> :w<cr>
nmap <leader>q :q<cr>
nmap <leader>h :set hlsearch<cr>

" copy insert paste mode
nmap <leader>y :set paste<cr>
nmap <leader>ny :set nopaste<cr>

map <c-h> <c-w>h
map <c-j> <c-w>j
map <c-k> <c-w>k
map <c-l> <c-w>l

vmap <D-j> gj
vmap <D-k> gk
vmap <D-4> g$
vmap <D-6> g^
vmap <D-0> g^
nmap <D-j> gj
nmap <D-k> gk
nmap <D-4> g$
nmap <D-6> g^
nmap <D-0> g^

" "+y copy text to c
vmap "+y :w !pbcopy<CR><CR>
nmap "+y :.w !pbcopy<CR><CR>
nmap "+p :r !pbpaste<CR><CR>

" map for fold
vnoremap <Space> za
nnoremap <Space> za

function! <SID>StripTrailingWhitespaces()
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " Do the business:
    %s/\s\+$//e
    " Clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction
nnoremap <silent> <F5> :call <SID>StripTrailingWhitespaces()<CR>

function! Zzzz()
  call system('sleep 2')
endfunction

filetype off

"Vundle Settings {{{1
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'https://github.com/VundleVim/Vundle.vim.git'

Plugin 'EasyMotion'
Plugin 'Townk/vim-autoclose'

Plugin 'ShowTrailingWhitespace'

" Plugin '_jsbeautify'

Plugin 'UltiSnips'
  let g:UltiSnipsSnippetDirectories = ['UltiSnips']
  let g:UltiSnipsSnippetsDir = '~/.vim/UltiSnips'
  let g:UltiSnipsExpandTrigger = '<Tab>'
  let g:UltiSnipsListSnippets = '<C-Tab>'
  let g:UltiSnipsJumpForwardTrigger = '<Tab>'
  let g:UltiSnipsJumpBackwardTrigger = '<S-Tab>'

Plugin 'pangloss/vim-javascript'
let g:javascript_enable_domhtmlcss = 1
let g:javascript_ignore_javaScriptdoc = 1
set foldmethod=syntax
set foldlevelstart=1

let javaScript_fold=1

Plugin 'jade.vim'

Plugin 'mattn/emmet-vim'

" VISUAL mode surround html element
Plugin 'surround.vim'

Plugin 'christoomey/vim-tmux-navigator'

" Aligning text
Plugin 'godlygeek/tabular'


" Markdown
Plugin 'tpope/vim-markdown'
Plugin 'nelstrom/vim-markdown-folding'

Plugin 'isRuslan/vim-es6'
Plugin 'groenewege/vim-less'
Plugin 'wavded/vim-stylus'
Plugin 'othree/html5.vim'

" coffee
Plugin 'kchmck/vim-coffee-script'
" react jsx
Plugin 'mxw/vim-jsx'

Plugin 'kien/ctrlp.vim' " fuzzy find files
Plugin 'scrooloose/nerdtree' " file drawer, open with :NERDTreeToggle
  nmap <Leader>nt :NERDTree<cr>:set rnu<cr>
  let NERDTreeShowBookmarks=1
  let NERDTreeShowFiles=1
  let NERDTreeShowhidden=1
  let NERDTreeIgnore=['\.$', '\~$']
  let NREDTreeShowLineNumbers=1
  let NREDTreeWinPos=1

" Plugin 'benmills/vimux'

" A Git wrapper so awesome, ti should be illegal
Plugin 'tpope/vim-fugitive' " the ultimate git helper

" 各个语言的注释插件
Plugin 'tpope/vim-commentary'

" Plugin 'Lokaltog/vim-powerline'
" let g:Powerline_symbols = 'fancy'
"
" Plugin 'scrooloose/syntastic'
" set statusline+=%#warningmsg#
" set statusline+=%{SyntasticStatuslineFlag()}
" set statusline+=%*
" let g:syntastic_always_populate_loc_list = 1
" let g:syntastic_auto_loc_list = 1
" let g:syntastic_check_on_open = 1
" let g:syntastic_check_on_wq = 0
" let g:syntastic_javascript_checkers = ['eslint']
" let g:syntastic_javascript_eslint_exec = 'eslint'
" let g:ycm_show_diagnostics_ui = 0
" autocmd bufwritepost *.js silent !standard-format -w %
"
Plugin 'rizzatti/dash.vim'

"}
call vundle#end()
filetype indent on              " load indent file for specific file type
filetype plugin indent on " Alternative: use the following to also enable language-dependent indenting.

set rtp+=/Users/lizhi/Library/Python/2.7/lib/python/site-packages/powerline/bindings/vim

" These lines setup the environment to show graphics and colors correctly.
" python from powerline.vim import setup as powerline_setup
" python powerline_setup()
" python del powerline_setup
let g:minBufExplForceSyntaxEnable = 1

" if ! has('gui_running')
"    set ttimeoutlen=10
"    augroup FastEscape
"       autocmd!
"       au InsertEnter * set timeoutlen=0
"       au InsertLeave * set timeoutlen=1000
"    augroup END
" endif

set laststatus=2 " Always display the statusline in all windows
set guifont=Cousine\ for\ Powerline
set noshowmode " Hide the default mode text (e.g. -- INSERT -- below the statusline)
