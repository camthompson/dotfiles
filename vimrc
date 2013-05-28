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

" AutoCMD {{{
aug vimrc
  au FocusLost * silent! wall

  " Go to last position in a file when opening
  au BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \   exe "normal g`\"" |
        \ endif

  " Highlight 81st column in insert mode; show trailing spaces when not
  " in insert; honestly I don't know why the ignorecase stuff is here
  au InsertEnter * set colorcolumn+=81 noignorecase listchars-=trail:·
  au InsertLeave * set colorcolumn-=81 ignorecase listchars+=trail:·

  au FileType c,cpp,cs,java setlocal commentstring=//\ %s
  au Syntax javascript setlocal isk+=$
  au FileType text,txt,mail setlocal ai com=fb:*,fb:-,n:>
  au FileType sh,zsh,csh,tcsh inoremap <silent> <buffer> <C-X>! #!/bin/<C-R>=&ft<CR>
  au FileType perl,python,ruby inoremap <silent> <buffer> <C-X>! #!/usr/bin/env<Space><C-R>=&ft<CR>
  au FileType c,cpp,cs,java,perl,javscript,php,aspperl,tex,css let b:surround_101 = "\r\n}"
  au FileType markdown set ai formatoptions=tcroqn2 comments=n:&gt;
  au Filetype qf setlocal colorcolumn=0 nolist nocursorline nowrap
  au FileType vim setlocal foldmethod=marker foldenable foldlevel=0
  au BufEnter Gemfile,Rakefile,Thorfile,config.ru,Guardfile,Capfile,Vagrantfile setfiletype ruby
  au BufEnter *pryrc,*irbrc,*railsrc setfiletype ruby
  au FileType ruby setlocal tw=79 comments=:#\  isfname+=:
  au FileType ruby
        \ if expand('%') =~# '_test\.rb$' |
        \   compiler rubyunit | setl makeprg=testrb\ \"%:p\" |
        \ elseif expand('%') =~# '_spec\.rb$' |
        \   compiler rspec | setl makeprg=rspec\ \"%:p\" |
        \ else |
        \   compiler ruby | setl makeprg=ruby\ -w\ \"%:p\" |
        \ endif
  au FileType css  silent! setlocal omnifunc=csscomplete#CompleteCSS
  au FileType cucumber silent! compiler cucumber | setl makeprg=cucumber\ "%:p" | imap <buffer><expr> <Tab> pumvisible() ? "\<C-N>" : (CucumberComplete(1,'') >= 0 ? "\<C-X>\<C-O>" : (getline('.') =~ '\S' ? ' ' : "\<C-I>"))
  au FileType git,gitcommit setlocal foldmethod=syntax foldlevel=1
  au FileType gitcommit setlocal spell
  au FileType help setlocal ai fo+=2n | silent! setlocal nospell
  au FileType help nnoremap <silent><buffer> q :q<CR>
  au FileType html setlocal iskeyword+=~
  au FileType mail if getline(1) =~ '^[A-Za-z-]*:\|^From ' | exe 'norm gg}' |endif|silent! setlocal spell
  au FileType vim  setlocal keywordprg=:help nojoinspaces

  " For whatever reason, this breaks shit if mapped normally
  au VimEnter * noremap ; :

  au WinEnter,BufEnter * call UpdateStatusline(1)
  au WinLeave * call UpdateStatusline(0)
aug END
" }}}

" Appearance {{{
set number "show line numbers
set scrolloff=5 "keep 5 lines above or below current line
set sidescrolloff=5 "keep 5 lines left or right of cursor
set nolist "don't show symbols for whitespace characters
set listchars=tab:▸\ ,eol:¬,trail:· "symbols for whitespace chars
set matchtime=5 "how long in tenths of a second to show matching parens
set cursorline "highlight the cursor line
set cursorcolumn "highlight the cursor column
set showcmd "show partial command in last line
set laststatus=2 "always show status
set showtabline=1 "show tab line when more than one open
set fillchars=fold:\ ,vert:\| "fill characters for folds and vert splits
set lazyredraw "don't redraw the screen while executing macros
" }}}

" Behavior {{{
set shell=$SHELL\ -l
set nowrap "don't wrap lines
set noshowmode "don't show mode
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

" Colorscheme {{{
set background=dark
colo base16-eighties
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

" Functions {{{
" ClearRegisters {{{
function! ClearRegisters()
  let regs = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789/-"'
  let i=0
  while (i < strlen(regs))
    exec 'let @'.regs[i].'=""'
    let i = i + 1
  endwhile
endfunction
command! ClearRegisters :call ClearRegisters()
" }}}

" DiffOrig {{{
command! DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
      \ | wincmd p | diffthis
" }}}

" GitBranch {{{
function! GitBranch()
  if exists("*fugitive#head")
    let head=fugitive#head()
    if strlen(head) > 0
      return '('.head.')'
    endif
  endif
  return ''
endfunction
" }}}

" Mode {{{
function! Mode()
  let l:mode = mode()
  hi clear User1

  if mode ==# "n"
    hi User1 cterm=reverse ctermbg=2 ctermfg=0 gui=reverse guibg=#99cc99 guifg=#2d2d2d
    return "[NORMAL]"
  elseif mode ==# "i"
    hi User1 ctermbg=5 ctermfg=0 guibg=#cc99cc guifg=#2d2d2d
    return "[INSERT]"
  elseif mode ==# "R"
    hi User1 ctermbg=6 ctermfg=0 guibg=#66cccc guifg=#2d2d2d
    return "REPLACE]"
  elseif mode ==# "v"
    hi User1 ctermbg=4 ctermfg=0 guibg=#6699cc guifg=#2d2d2d
    return "[VISUAL]"
  elseif mode ==# "V"
    hi User1 ctermbg=3 ctermfg=0 guibg=#ffcc66 guifg=#2d2d2d
    return "[V-LINE]"
  elseif mode =~# ""
    hi User1 ctermbg=1 ctermfg=0 guibg=#f2777a guifg=#2d2d2d
    return "V-BLOCK]"
  else
    return ""
  endif
endfunction
" }}}

" ShortCWD {{{
function! ShortCWD()
  " Recalculate the filepath when cwd changes.
  let cwd = getcwd()
  if exists("b:cet_cwd") && cwd != b:cet_cwd
    unlet! b:cet_filepath
  endif
  let b:cet_cwd = cwd

  if exists('b:cet_filepath')
    return b:cet_filepath
  endif

  let dirsep = has('win32') && ! &shellslash ? '\' : '/'
  let filepath = expand('%:p')

  if empty(filepath)
    return ''
  endif

  let ret = ''

  let mod = (exists('+acd') && &acd) ? ':~:h' : ':~:.:h'
  let fpath = split(fnamemodify(filepath, mod), dirsep)
  let fpath_shortparts = map(fpath, 'v:val[0]')
  let ret = join(fpath_shortparts, dirsep) . dirsep

  if ret == ('.' . dirsep)
    let ret = ''
  endif

  let b:cet_filepath = ret
  return ret
endfunction
" }}}

" OpenChangedFiles {{{
function! OpenChangedFiles()
  only " Close all windows, unless they're modified
  let status = system('git status -s | grep "^ \?\(M\|A\|UU\)" | sed "s/^.\{3\}//"')
  let filenames = split(status, "\n")
  exec "edit " . filenames[0]
  for filename in filenames[1:]
    exec "sp " . filename
  endfor
endfunction
command! OpenChangedFiles :call OpenChangedFiles()
" }}}

" OpenTestAlternate {{{
function! OpenTestAlternate()
  let new_file = AlternateForCurrentFile()
  exec ':e ' . new_file
endfunction

function! AlternateForCurrentFile()
  let current_file = expand("%")
  let new_file = current_file
  let in_spec = match(current_file, '^spec/') != -1
  let going_to_spec = !in_spec
  let in_app = match(current_file, '\<controllers\>') != -1 || match(current_file, '\<models\>') != -1 || match(current_file, '\<views\>') || match(current_file, '\<helpers\>') != -1
  if going_to_spec
    if in_app
      let new_file = substitute(new_file, '^app/', '', '')
    end
    let new_file = substitute(new_file, '\.rb$', '_spec.rb', '')
    let new_file = 'spec/' . new_file
  else
    let new_file = substitute(new_file, '_spec\.rb$', '.rb', '')
    let new_file = substitute(new_file, '^spec/', '', '')
    if in_app
      let new_file = 'app/' . new_file
    end
  endif
  return new_file
endfunction

nnoremap <leader>. :call OpenTestAlternate()<cr>
" }}}

" PromoteToLet {{{
function! PromoteToLet()
  :normal! dd
  " :exec '?^\s*it\>'
  :normal! P
  :.s/\(\w\+\) = \(.*\)$/let(:\1) { \2 }/
  :normal ==
endfunction
au BufNewFile,BufRead *spec.rb :map <buffer> <leader>l :call PromoteToLet()<cr>
" }}}

" Rails {{{
map <leader>gr :topleft :split config/routes.rb<cr>
map <leader>gg :topleft 100 :split Gemfile<cr>
map <leader>gd :topleft 100 :split db/schema.rb<cr>
" }}}

" Run {{{
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
    elseif &ft == 'html' || &ft == 'xhtml'
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
" }}}

" SL {{{
function! SL(function)
  if exists('*'.a:function)
    return call(a:function,[])
  else
    return ''
  endif
endfunction
" }}}

" StripTrailingWhitespace {{{
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
command! StripTrailingWhitespaces call <SID>StripTrailingWhitespaces()
nmap <leader>w :StripTrailingWhitespaces<CR>
" }}}

" SynStack {{{
function! SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunction
" }}}

" ToggleBackground {{{
function! ToggleBackground()
  let dark=(&bg == 'dark')
  if dark
    set bg=light
  else
    set bg=dark
  endif
endfunction
command! ToggleBG call ToggleBackground()
" }}}

" UpdateStatusLine {{{
function! UpdateStatusline(current)
  if a:current
    let l:statline="%1*%{Mode()}%*"
  else
    let l:statline=""
  endif

  let statline.="[%n]%{SL('CapsLockl:statline')}"
  let statline.=" %{ShortCWD()}%t%{GitBranch()}"
  let statline.=" %h%w%m%r%y%#ErrorMsg#"
  let statline.="%{SL('Syntasticl:statlineFlag')}%*"
  let statline.="%=%-14.(%l,%c%V%)\ %P\ "

  call setwinvar(0, '&statusline', statline)
endfunction
" }}}

" WordProcessorMode {{{
function! WordProcessorMode()
  setlocal formatoptions=1
  setlocal noexpandtab
  setlocal spell spelllang=en_us
  set formatprg=par
  setlocal wrap
  setlocal linebreak
  setlocal nolist
endfu
command! WP call WordProcessorMode()
" }}}
"}}}

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

" Maps {{{
let mapleader = '\'
let maplocalleader = '-'

" Useless Keys {{{
noremap <F1> <nop>
" }}}

" Command Mode {{{
cnoremap %% <c-r>=expand('%:h').'/'<cr>
cnoremap <c-o> <up>
" }}}

" {{{ Insert Mode
inoremap <c-c> <esc>zza
"center current line on screen

" make c-u and c-w undoable
inoremap <c-u> <c-g>u<c-u>
inoremap <c-w> <c-g>u<c-w>
" }}}

" Normal Mode {{{
nnoremap ' `
nnoremap ` '
nnoremap H g^
nnoremap L g_
nnoremap <c-y> 5<c-y>
nnoremap <c-e> 5<c-e>
nnoremap <c-j> <c-w><c-j>
nnoremap <c-k> <c-w><c-k>
nnoremap <c-l> <c-w><c-l>
nnoremap <c-h> <c-w><c-h>
nnoremap <c-=> <c-w>=
nnoremap / :set hlsearch<cr>/\v
xnoremap / :set hlsearch<cr>/\v
nnoremap ? :set hlsearch<cr>?\v
xnoremap ? :set hlsearch<cr>?\v
nnoremap <c-p> <c-^>
nnoremap & :&&<cr>
xnoremap & :&&<cr>
nnoremap Q gqip
xnoremap Q gq
nnoremap ql ^vg_gq
nnoremap <leader>c :!git ctags<cr>
nnoremap Y y$

if !(has("gui_running"))
  nnoremap <c-z> :wa\|suspend<cr>
endif

function! MapCR()
  nnoremap <cr> :set hlsearch!<cr>
endfunction
call MapCR()
autocmd! CmdwinEnter * :unmap <cr>
autocmd! CmdwinLeave * :call MapCR()
" }}}

" Set Filetypes {{{
nnoremap <localleader>cs :setlocal filetype=css<CR>
nnoremap <localleader>ht :setlocal filetype=html<CR>
nnoremap <localleader>js :setlocal filetype=javascript<CR>
nnoremap <localleader>md :setlocal filetype=markdown<CR>
nnoremap <localleader>pl :setlocal filetype=perl<CR>
nnoremap <localleader>ph :setlocal filetype=php<CR>
nnoremap <localleader>py :setlocal filetype=python<CR>
nnoremap <localleader>rb :setlocal filetype=ruby<CR>
nnoremap <localleader>sh :setlocal filetype=sh<CR>
nnoremap <localleader>vi :setlocal filetype=vim<CR>
nnoremap <localleader>xm :setlocal filetype=xml<CR>
" }}}"

" Move By Display Lines {{{
noremap j gj
noremap k gk
noremap gj j
noremap gk k
" }}}
" }}}

" Plugin Config {{{
" CapsLock {{{
imap <c-l>     <plug>CapsLockToggle
" }}}

" Clam {{{
nnoremap ! :Clam<space>
vnoremap ! :ClamVisual<space>
" }}}

" CtrlP {{{
let g:ctrlp_max_height = 10
let g:ctrlp_match_window_reversed = 0
let g:ctrlp_prompt_mappings = {
      \ 'PrtSelectMove("j")':   ['<c-n>', '<down>', '<s-tab>'],
      \ 'PrtSelectMove("k")':   ['<c-p>', '<up>', '<tab>'],
      \ 'PrtHistory(-1)':       ['<c-j>'],
      \ 'PrtHistory(1)':        ['<c-k>'],
      \ 'ToggleFocus()':        ['<c-tab>'],
      \ }
let g:ctrlp_dotfiles = 0
let g:ctrlp_extensions = ['tag', 'quickfix', 'dir']
let g:ctrlp_mruf_max = 100
let g:ctrlp_use_caching = 0
let g:ctrlp_map = '<leader><leader>'
let g:ctrlp_jump_to_buffer = 0
let g:ctrlp_max_files = 10000
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_arg_map = 1
let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard',
      \ "find %s '(' -type f -or -type l ')' -maxdepth 15 -not -path '*/\\.*/*'"]
let g:ctrlp_mruf_relative = 1
nnoremap \\ :CtrlP<cr>
nnoremap -- :CtrlPMRU<cr>
nnoremap ,, :CtrlPBuffer<cr>
" }}}

" EasyMotion {{{
let g:EasyMotion_leader_key = ','
let g:EasyMotion_keys = 'asdfhjkl'
hi link EasyMotionTarget helpSpecial
" }}}

" Gist {{{
let g:gist_detect_filetype = 1
if has("mac")
  let g:gist_clip_command = 'pbcopy'
else
  let g:gist_clip_command = 'xclip -selection clipboard'
endif
" }}}

" GitGutter {{{
let g:gitgutter_enabled = 0
" }}}

" Gundo {{{
noremap <leader>gu :GundoToggle<cr>
let g:gundo_help = 0
" }}}

" KWBD {{{
map <leader>d <plug>Kwbd
" }}}

" Ruby {{{
let g:rubycomplete_buffer_loading = 1
let g:rubycomplete_classes_in_global = 1
let g:rubycomplete_rails = 1
let g:space_disable_select_mode = 1
" }}}

" SplitJoin {{{
nnoremap <leader>j :SplitjoinJoin<cr>
nnoremap <leader>s :SplitjoinSplit<cr>
let g:splitjoin_ruby_curly_braces=0
" }}}

" SuperTab {{{
let g:SuperTabDefaultCompletionType = 'context'
let g:SuperTabCrMapping = 0
" }}}

" Surround {{{
let g:surround_35  = "#{\r}"      " #
let g:surround_45 = "<% \r %>"    " -
let g:surround_61 = "<%= \r %>"   " =
" }}}

" Syntastic {{{
let g:syntastic_check_on_open = 0
let g:syntastic_enable_balloons = 0
let g:syntastic_loc_list_height = 5
" }}}

" Tabular {{{
function! s:align()
  let p = '^\s*|\s.*\s|\s*$'
  if exists(':Tabularize') && getline('.') =~# '^\s*|' && (getline(line('.')-1) =~# p || getline(line('.')+1) =~# p)
    let column = strlen(substitute(getline('.')[0:col('.')],'[^|]','','g'))
    let position = strlen(matchstr(getline('.')[0:col('.')],'.*|\s*\zs.*'))
    Tabularize/|/l1
    normal! 0
    call search(repeat('[^|]*|',column).'\s\{-\}'.repeat('.',position),'ce',line('.'))
  endif
endfunction
inoremap <silent> <Bar> <Bar><Esc>:call <SID>align()<cr>a
nnoremap <leader>= :Tabularize /=<cr>
xnoremap <leader>= :Tabularize /=<cr>
nnoremap <leader>: :Tabularize /:\zs<cr>
xnoremap <leader>: :Tabularize /:\zs<cr>
nnoremap <leader>, :Tabularize /,\zs<cr>
xnoremap <leader>, :Tabularize /,\zs<cr>
nnoremap <leader><bar> :Tabularize /<bar><cr>
vnoremap <leader><bar> :Tabularize /<bar><cr>
" }}}

" Vitality {{{
let g:vitality_fix_cursor = 0
" }}}

" Vroom {{{
let g:vroom_use_dispatch=1
let g:vroom_use_colors=1
let g:vroom_detect_spec_helper=1
" }}}

" ZoomWin {{{
nmap <leader>z <c-w>o
set noequalalways
" }}}
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
