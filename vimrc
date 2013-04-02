set nocompatible "no vi compatibility

if filereadable(expand("~/.vimrc.before"))
  source ~/.vimrc.before
endif

" Pathogen {{{
runtime bundle/pathogen/autoload/pathogen.vim
runtime macros/matchit.vim
silent! call pathogen#infect()
silent! call pathogen#infect("~/src/vimbundles")
" }}}

" Colorscheme {{{
set t_Co=256
set background=dark
colo Tomorrow-Night
" }}}

" Appearance {{{
set number "show line numbers
set scrolloff=5 "keep 5 lines above or below current line
set sidescrolloff=5 "keep 5 lines left or right of cursor
set list "show symbols for whitespace characters
set listchars=tab:▸\ ,eol:¬,trail:· "symbols for whitespace chars
set matchtime=5 "how long in tenths of a second to show matching parens
set cursorline "highlight the cursor line
set cursorcolumn "highlight the cursor column
set showcmd "show partial command in last line
set laststatus=2 "always show status
set showtabline=1 "show tab line when more than one open
set fillchars=fold:\ ,vert:\| "fill characters for folds and vert splits
set lazyredraw "don't redraw the screen while executing macros
function! SL(function)
  if exists('*'.a:function)
    return call(a:function,[])
  else
    return ''
  endif
endfunction
set statusline=[%n]\ %<%.99f\ %h%w%m%r%{SL('CapsLockStatusline')}%y%{SL('fugitive#statusline')}%#ErrorMsg#%{SL('SyntasticStatuslineFlag')}%*%=%-14.(%l,%c%V%)\ %P
" }}}

" Behavior {{{
set nowrap "don't wrap lines
set showmode "show mode
set startofline "jump commands move to first non-blank character
set autoread "automatically reads file when updated outside of vim
set magic "unescaped . and * in regex are special chars
set hidden "don't delete buffer when abandoned
set report=5 "threshold for showing when a number of lines are changed
set shortmess=aOstTAI "help avoid hit enter prompts
set formatoptions=tcroqwn
set pastetoggle=<F2> "F2 toggles pastemode
set gdefault "makes /g the default on substitute
set modeline "check file for vim options
set modelines=10 "check 10 lines for options
set path+=./**  "search recursively downards
set nrformats=alpha,hex,octal "increment chars, consider 0x and #x to be decimal
set splitbelow "open splits below current window
set splitright "open vertical splits to the right of the current window
set switchbuf=usetab "jump to first open window or tab with a buffer
set virtualedit=block "allow cursor to be placed on nonexistent locations in block mode
set winwidth=84
set winheight=5
set winminheight=5
set winheight=999
set noesckeys "esc enters command mode instantly
" }}}

" Completion {{{
set wildmode=full "complete first full match
"filetypes to ignore on tab-completion
set wildignore=*.dll,*.exe,*.pyc,*.pyo,*.egg,*.class
set wildignore+=*.jpg,*.gif,*.png,*.o,*.obj,*.bak,*.rbc
set wildignore+=Icon*,\.DS_Store,*.out,*.scssc,*.sassc
set wildignore+=.git/*,.hg/*,.svn/*,*/swp/*,*/undo/*,Gemfile.lock
set wildmenu "show completion matches above command line
" }}}

" Folding {{{
set nofoldenable "disable folding by default
set foldmethod=marker "folds on markers
set foldnestmax=5 "only nest 5 folds at max when auto folding
"actions that open folds
set foldopen=block,insert,jump,mark,percent,quickfix,search,tag,undo
set foldlevel=1 "only automatically fold levels of 1 or higher
set foldlevelstart=1 "start editing all buffers with some folds closed
" }}}

" General {{{
syntax on
filetype plugin indent on
set ttyfast "improves copy/paste for terminals
set encoding=utf-8
set visualbell t_vb= "no bell
set mouse=a
set timeout ttimeout "time out on mappings and key codes
set timeoutlen=500 "time out duration
set cpoptions=aABceFsmq "copy options
set fileformats=unix,dos,mac "reads EOLs to determine file format
set history=1000 "number of commands to keep in history
" }}}

" Indentation/Tabs {{{
set backspace=2 "allow backspace over autoindent and line break
set tabstop=2 "tab width
set softtabstop=2 "treat 2 consecutive spaces as a tab
set expandtab "insert spaces instead of tabs
set shiftwidth=2 "< and > indent width
set smarttab "use shiftwidth value for tabs at beginning of a line
set autoindent "use previous line's indentation
set nosmartindent "the name of this option is misleading
set shiftround "round indentation to multiples of shiftwidth
" }}}

" Search {{{
set incsearch "incremental search jumping
set wrapscan "search wraps around end of document
set ignorecase "case insensitive search
set smartcase "stops ignoring case when capitals used
set nohlsearch "don't highlight search terms
" }}}

" Swap/Backup/Undo {{{
set swapfile "save swap files for crash recovery etc.
set directory=$HOME/.vim/swp// "swap file directory
set updatecount=100 "number of chars after which to update swap file
set undofile "persistent undo history
set undodir=$HOME/.vim/undo/ "undo file directory
set undolevels=1000 "number of undo levels to save
set nobackup "do not backup files
" }}}

set secure
