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
set background=light
let g:solarized_bold = 0
let g:solarized_italic = 0
let g:solarized_underline = 0
let g:solarized_visibility = "low"
let g:solarized_hitrail = 1
let g:solarized_diffmode = "high"
let g:solarized_menu = 0
colo solarized
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

function! SL(function)
  if exists('*'.a:function)
    return call(a:function,[])
  else
    return ''
  endif
endfunction

function! Run()
  let old_makeprg = &makeprg
  let old_errorformat = &errorformat
  try
    let cmd = matchstr(getline(1),'^#!\zs[^ ]*')
    if exists('b:run_command')
      exe b:run_command
    elseif cmd != '' && executable(cmd)
      wa
      let &makeprg = matchstr(getline(1),'^#!\zs.*').' %'
      make
    elseif &ft == 'mail' || &ft == 'text' || &ft == 'help' || &ft == 'gitcommit'
      setlocal spell!
    elseif exists('b:rails_root') && exists(':Rake')
      wa
      Rake
    elseif &ft == 'cucumber'
      wa
      compiler cucumber
      make %
    elseif &ft == 'ruby'
      wa
      if executable(expand('%:p')) || getline(1) =~ '^#!'
        compiler ruby
        let &makeprg = 'ruby'
        make %
      elseif expand('%:t') =~ '_test\.rb$'
        compiler rubyunit
        let &makeprg = 'ruby'
        make %
      elseif expand('%:t') =~ '_spec\.rb$'
        compiler rspec
        let &makeprg = 'rspec'
        make %
      elseif &makeprg ==# 'bundle'
        make
      elseif executable('pry') && exists('b:rake_root')
        execute '!pry -I"'.b:rake_root.'/lib" -r"%:p"'
      elseif executable('pry')
        !pry -r"%:p"
      else
        !irb -r"%:p"
      endif
    elseif &ft == 'html' || &ft == 'xhtml' || &ft == 'php' || &ft == 'aspvbs' || &ft == 'aspperl'
      wa
      if !exists('b:url')
        call OpenURL(expand('%:p'))
      else
        call OpenURL(b:url)
      endif
    elseif &ft == 'vim'
      w
      if exists(':Runtime')
        return 'Runtime %'
      else
        unlet! g:loaded_{expand('%:t:r')}
        return 'source %'
      endif
    elseif &ft == 'sql'
      1,$DBExecRangeSQL
    elseif expand('%:e') == 'tex'
      wa
      exe "normal :!rubber -f %:r && xdvi %:r >/dev/null 2>/dev/null &\<CR>"
    elseif &ft == 'dot'
      let &makeprg = 'dotty'
      make %
    else
      wa
      if &makeprg =~ '%'
        make
      else
        make %
      endif
    endif
    return ''
  finally
    let &makeprg = old_makeprg
    let &errorformat = old_errorformat
  endtry
endfunction
command! -bar Run :execute Run()

set secure
