" vim: set shiftwidth=4 tabstop=4:

" = plugins ======================================================================= <<< =

" vim-plug
call plug#begin ('~/.vim/plugged')
" Plug 'powerline/powerline'

Plug 'AlessandroYorba/Despacio'
Plug 'arcticicestudio/nord-vim'
Plug 'djmoch/vim-makejob'
Plug 'itchyny/lightline.vim'
Plug 'terryma/vim-multiple-cursors'
Plug 'vim-geek/largefile.vim'

" Plug 'kamwitsta/commentToggle'
Plug 'kamwitsta/dutch_peasants'
Plug 'kamwitsta/nordisk'
Plug '~/devel/vim/commentToggle', {'branch': 'develop'}
" Plug '~/devel/vim/kolorki/nordisk', {'branch': 'develop'}
Plug '~/devel/vim/tex_alt/'
	let g:tex_flavour = "xelatex"
call plug#end ()


" lightline
let g:lightline = {
	\ 'colorscheme':	'nordisk',
	\ 'active': {
	\	'left':		[['mode', 'paste'],
	\				['readonly', 'filename', 'modified']],
	\	'right':	[['lineinfo'], ['percent'], ['filetype']]
	\ },
	\ 'inactive': {
	\	'left':		[['mode', 'paste'],
	\				['readonly', 'filename', 'modified']],
	\	'right':	[['lineinfo'], ['percent'], ['filetype']]
	\ },
	\ 'component': {
	\	'readonly': '%{&filetype=="help"?"":&readonly?"⭤":""}',
	\	'modified': '%{&filetype=="help"?"":&modified?"+":&modifiable?"":"-"}',
	\ },
	\ 'component_visible_condition': {
	\	'readonly': '(&filetype!="help"&& &readonly)',
	\	'modified': '(&filetype!="help"&&(&modified||!&modifiable))',
	\ },
	\ 'separator':		{'left':'', 'right':''},
	\ 'subseparator':	{'left':'', 'right':''}
\ }


" ================================================================================= >>> =
" = behaviour ===================================================================== <<< =

let g:os = substitute(system('uname'), "\n", "", "")

set background=dark
colorscheme nordisk

set autoindent			" auto indentation
set autoread			" monitor for changes to the file
set backspace=2			" backspace over everything
set bufhidden=wipe
if g:os == "Darwin"		" use the X clipboard + fix for visual selection
	set clipboard=unnamed
elseif g:os == "Linux"
	set clipboard=unnamedplus,autoselect
endif
set cole=0				" conceal
set concealcursor=n		" only unconceal in visual and insert
set copyindent			" copy the previous indent
set cursorline			" current line highlighted
set display+=lastline	" show partial paragraphs
set foldcolumn=0		" no left margin (stays wrong after diff)
set foldmarker=<<<,>>>	" triple curly brackets actually occur
set foldmethod=marker	" folding by markers
set formatoptions=j
set history=100			" keep more lines of history
set ignorecase			" required by smartcase
set incsearch			" search after letters typed
set laststatus=2		" always show the status line
set linebreak			" don't wrap in the middle of a word
set listchars=tab:│‧,extends:⇉,precedes:⇇	" hidden characters when list is on (latex)
set modeline			" accept modelines
set mouse=a				" allow mouse clicks to move cursor
set nocompatible		" vi non-compatible
set noerrorbells		" clear, i should hope
set noexpandtab			" way 4 of :help tabstop
set noshowmode			" the mode is shown by lightline already
set noswapfile			" more annoyance than gain
set nowildignorecase	" don't ignore case with autocompletion with file selection
set nowildmenu			" no menu for command completion
set report=0			" always report changes
set ruler				" cursor position in the lower right corner
set scrolloff=10		" more context around the cursor
set shiftwidth=4		" way 4 of :help tabstop
set showbreak=│‧‧‧		" prepended before wrapped lines (just display) (trailing space)
set showcmd				" show (partial) commands as they're typed
set showmatch			" highlight parentheses
set sidescroll=1		" continuous scrolling sideways
set smartcase			" ignore case if no capitals in pattern
set smartindent			" cause it's smart
set smarttab			" insert tabs by shiftwidth
set splitbelow			" split windows open below
set splitright			"	and on the right
set statusline=%f\ %m\%=%l,%c\ \ %P
set synmaxcol=1000		" long lines (xml!) are an overkill
set tabpagemax=50		" open multiple files
set tabstop=4			" way 4 of :help tabstop
set t_Co=256			" 256-colour mode
set termguicolors		" enable truecolor
set termencoding=utf-8
set textwidth=0			" don't automatically break paragraphs
set undofile			" persistent undo
set undodir=~/.tmp-vim
set vb t_vb=			" turn off beep
set virtualedit=		" don't select tabs as if composed of many spaces
set whichwrap+=<,>		" move with arrows through wrapped lines
set wildmode=list:longest	" bash-like completion
set wrap				" wrap lines

filetype plugin on		" load plugins for different filetypes
filetype indent on		"	and indent rules

syntax enable
syntax sync minlines=100 maxlines=500	" speed up highlighting

" highlight incorrect whitespace (trailing, spaces before tabs and multiple spaces)
if &modifiable && &ft!="csv" && &ft!="haskell"		" unless vimpager, csv or haskell
	match Error "[[:space:]]\+$\| \t\|\t \| \{2,}"
	set fileencoding=utf-8
endif


" ================================================================================= >>> =
" = keys ========================================================================== <<< =


" reasonable moving thrgough wrapped lines
noremap <Up> gk
noremap <Down> gj
noremap <silent> k gk
noremap <silent> j gj
noremap <expr> <Home> &wrap ? "g\<Home>" : "^"
noremap <expr> <silent> ^ &wrap ? "g^" : "^"
noremap <expr> <silent> 0 &wrap ? "g0" : "0"
noremap <expr> <End> &wrap ? "g\<End>" : "$"
noremap <expr> <silent> $ &wrap ? "g$" : "$"
inoremap <expr> <Up> pumvisible() ? "\<Up>" : "\<C-o>gk"
inoremap <expr> <Down> pumvisible() ? "\<Down>" : "\<C-o>gj"
inoremap <expr> <Home> &wrap ? "\<C-o>g\<Home>" : "\<C-o>^"
inoremap <expr> <End> &wrap ? "\<C-o>g\<End>" : "\<C-o>$"
noremap <silent> <Leader>w :set wrap!<CR>

" alt-arrows to switch between split windows
nmap <silent> <A-Up> <C-w>k
nmap <silent> <A-Down> <C-w>j
nmap <silent> <A-Left> <C-w>h
nmap <silent> <A-Right> <C-w>l
imap <silent> <A-Up> <C-o><C-w>k
imap <silent> <A-Down> <C-o><C-w>j
imap <silent> <A-Left> <C-o><C-w>h
imap <silent> <A-Right> <C-o><C-w>l

" <F9> to compile asynchronously (djmoch/vim-makejob)
noremap <F9> :w<CR>:MakeJob %<CR>
" <Leader>n and p to jump to next and previous error
noremap <silent> <Leader>n :copen \| cnext<CR>
noremap <silent> <Leader>p :copen \| cprevious<CR>

" ctrl-s for save
nnoremap <C-s> :update<CR>
vnoremap <C-s> <C-c>:update<CR>
inoremap <C-s> <C-o>:update<CR>

" center window after jumping to next match
nnoremap n nzz
nnoremap N Nzz

" don't want ex mode
nnoremap Q <nop>

" more an annoyance than a convenience
nnoremap q: :q

" vv to highlight the entire line
nnoremap vv <S-v>


" ================================================================================= >>> =
" = autocmds ====================================================================== <<< =

" | AutoCD

function! AutoCD ()
	if bufname("")!~"^ftp://" && &buftype==''
		lcd %:p:h
	endif
endfunction

autocmd BufEnter,BufRead,BufNewFile * call AutoCD ()

" | AutoLoadView

function! AutoLoadview ()
	if &buftype==''
		silent loadview
	endif
endfunction

autocmd BufWinLeave ?* mkview				" remember folds when file closes + ↓
autocmd BufWinEnter ?* call AutoLoadview ()	" cont'd

" | .vimrc gets overridden by plugins sometimes

function! FixVimrc ()
	if !&diff
		set foldcolumn=0
	endif
	set formatoptions=j
endfunction

autocmd BufEnter * call FixVimrc ()

" ================================================================================= >>> =
" = text objects ================================================================== <<< =


" between tabs
vnoremap at :<C-U>silent! normal! T<Tab>vf<Tab><CR>
omap at :normal vat<CR>
vnoremap it :<C-U>silent! normal! T<Tab>vt<Tab><CR>
omap it :normal vit<CR>


" ================================================================================= >>> =
" = vimpager ====================================================================== <<< =

if &readonly
	map y y
	set scrolloff=999
endif


" ================================================================================= >>> =
" = extra functions =============================================================== <<< =


function! CopyMatches()
	let hits = []
	%s//\=len(add(hits, submatch(0))) ? submatch(0) : ''/ge
	execute 'let @+ = join(hits, "\n") . "\n"'
	u
endfunction


function! HighlightGroupCheck ()
	:echo "hi: " . synIDattr(synID(line("."),col("."),1),"name")
		\ . "   trans: " . synIDattr(synID(line("."),col("."),0),"name")
		\ . "   lo: " . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name")
endfunction


function! SortLines() range
	execute a:firstline . "," . a:lastline . 's/^\(.*\)$/\=strdisplaywidth( submatch(0) ) . " " . submatch(0)/'
	execute a:firstline . "," . a:lastline . 'sort n'
	execute a:firstline . "," . a:lastline . 's/^\d\+\s//'
endfunction


function! SpacesToTab ()
	silent! s/[[:space:]]\+/\t/g
	silent! s/[[:space:]]\+$//g
	silent! s/^[[:space:]]\+//g
endfunction


function! Tabs (m)
	let &tabstop=a:m
	let &shiftwidth=a:m
endfunction


function! Udhr ()
	silent! %s/[\.,:;?!\(\)\[\]–"“”`\/]/\r/g
	silent! %s/--/\r/g
	silent! %s/^\-/\r/g
	silent! %s/\-$/\r/g
	silent! %s/[[:space:]]\+/\r/g
	silent! %s/\n\+/\r/g
endfunction


" ================================================================================= >>> =
