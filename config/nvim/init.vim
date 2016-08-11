" Plug {{{
call plug#begin('~/.config/nvim/plugged')

Plug 'airblade/vim-gitgutter'
Plug 'altercation/vim-colors-solarized'
Plug 'AndrewRadev/linediff.vim'
Plug 'AndrewRadev/sideways.vim'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'AndrewRadev/switch.vim'
Plug 'AndrewRadev/undoquit.vim'
Plug 'chriskempson/base16-vim'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'ecomba/vim-ruby-refactoring'
Plug 'elixir-lang/vim-elixir'
Plug 'godlygeek/tabular'
Plug 'greyblake/vim-preview'
Plug 'idanarye/vim-merginal'
Plug 'janko-m/vim-test'
Plug 'jiangmiao/auto-pairs'
Plug 'junegunn/gv.vim'
Plug 'justinmk/vim-sneak'
Plug 'kana/vim-textobj-entire'
Plug 'kana/vim-textobj-fold'
Plug 'kana/vim-textobj-indent'
Plug 'kana/vim-textobj-line'
Plug 'kana/vim-textobj-user'
Plug 'mattn/ctrlp-register'
Plug 'mattn/gist-vim'
Plug 'mattn/webapi-vim'
Plug 'mbbill/undotree'
Plug 'mmozuras/vim-github-comment'
Plug 'mustache/vim-mustache-handlebars'
Plug 'nelstrom/vim-markdown-folding'
Plug 'nelstrom/vim-textobj-rubyblock'
Plug 'nelstrom/vim-visual-star-search'
Plug 'ngmy/vim-rubocop'
Plug 'othree/html5.vim'
Plug 'pangloss/vim-javascript'
Plug 'radenling/vim-dispatch-neovim'
Plug 'rust-lang/rust.vim'
Plug 'Shougo/deoplete.nvim'
Plug 'sickill/vim-pasta'
Plug 'slim-template/vim-slim'
Plug 'tommcdo/vim-exchange'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-afterimage'
Plug 'tpope/vim-bundler'
Plug 'tpope/vim-capslock'
Plug 'tpope/vim-characterize'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-cucumber'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-dotenv'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-flagship'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-git'
Plug 'tpope/vim-haml'
Plug 'tpope/vim-jdaddy'
Plug 'tpope/vim-markdown'
Plug 'tpope/vim-obsession'
Plug 'tpope/vim-projectionist'
Plug 'tpope/vim-ragtag'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-rake'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-rsi'
Plug 'tpope/vim-scriptease'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-tbone'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-vinegar'
Plug 'vim-ruby/vim-ruby'
Plug 'vim-scripts/kwbdi.vim'
Plug 'vim-scripts/TailMinusF'
Plug 'wellle/targets.vim'

Plug '~/.config/nvim/bundle/ZoomWin'

Plug '~/src/vim-ember'

call plug#end()
" }}}

filetype plugin indent on
set visualbell t_vb= "no bell
set mouse=a "enable mouse in all modes
set cpoptions=aABceFsmq "copy options
set exrc "local for .vimrc in CWD

if filereadable(expand("~/.vimrc.before"))
  source ~/.vimrc.before
endif

" AutoCMD {{{
aug vimrc
  " Go to last position in a file when opening
  au BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") && &ft != "gitcommit" |
        \   exe "normal g`\"" |
        \ endif

  au InsertEnter * set listchars-=trail:-
  au InsertLeave * set listchars+=trail:-

  au Syntax javascript setlocal isk+=$
  au FileType text,txt,mail setlocal ai com=fb:*,fb:-,n:>
  au FileType sh,zsh,csh,tcsh inoremap <silent> <buffer> <C-X>! #!/bin/<C-R>=&ft<CR>
  au FileType perl,python,ruby inoremap <silent> <buffer> <C-X>! #!/usr/bin/env<Space><C-R>=&ft<CR>
  au FileType c,cpp,cs,java,perl,javscript,php,aspperl,tex,css let b:surround_101 = "\r\n}"
  au FileType markdown set formatoptions=tcroqn2 comments=n:&gt;
  au Filetype qf setlocal colorcolumn=0 nolist nocursorline nowrap
  au FileType vim setlocal foldmethod=marker foldenable foldlevel=0
  au BufEnter Gemfile,Rakefile,Thorfile,config.ru,Guardfile,Capfile,Vagrantfile setfiletype ruby
  au BufEnter *pryrc,*irbrc,*railsrc setfiletype ruby
  au FileType ruby let b:surround_58 = ":\r"
  autocmd FileType ruby setlocal tw=79 comments=:#\  isfname+=:
  autocmd FileType ruby
        \ let b:start = executable('pry') ? 'pry -r "%:p"' : 'irb -r "%:p"' |
        \ if expand('%') =~# '_test\.rb$' |
        \   let b:dispatch = 'testrb %' |
        \ elseif expand('%') =~# '_spec\.rb$' |
        \   let b:dispatch = 'rspec %' |
        \ elseif !exists('b:dispatch') |
        \   let b:dispatch = 'ruby -wc %' |
        \ endif
  au FileType css  silent! setlocal omnifunc=csscomplete#CompleteCSS
  au FileType cucumber silent! compiler cucumber | setl makeprg=cucumber\ "%:p" | imap <buffer><expr> <Tab> pumvisible() ? "\<C-N>" : (CucumberComplete(1,'') >= 0 ? "\<C-X>\<C-O>" : (getline('.') =~ '\S' ? ' ' : "\<C-I>"))
  au FileType git,gitcommit setlocal foldmethod=syntax foldlevel=1 spell
  au WinEnter */.git/index nunmap q;| nunmap ql
  au WinLeave */.git/index nnoremap q; q:| nnoremap ql ^vg_gq
  au FileType help setlocal ai fo+=2n | silent! setlocal nospell
  au FileType help nnoremap <silent><buffer> q :q<CR>
  au FileType html setlocal iskeyword+=~
  au FileType mail if getline(1) =~ '^[A-Za-z-]*:\|^From ' | exe 'norm gg}' |endif|silent! setlocal spell fo+=aw
  au FileType markdown call WordProcessorMode()
  au FileType vim  setlocal keywordprg=:help nojoinspaces
aug END
" }}}

" Settings {{{
let mapleader = "\<space>"
let maplocalleader = ','

colo base16-oceanicnext

set background=dark
set backup "enable backup
set backupdir=$HOME/.vim/tmp/backup// "backup file directory
set backupskip=/tmp/*,/private/tmp/* "skip backups for these directories
set breakindent "visually indent wrapped lines
set colorcolumn=+1 "highlight column after &textwidth
set cursorcolumn "highlight the cursor column
set cursorline "highlight the cursor line
set directory=$HOME/.vim/tmp/swp// "swap file directory
set expandtab "insert spaces instead of tabs
set fillchars=fold:\ ,vert:\| "fill characters for folds and vert splits
set foldlevel=1 "only automatically fold levels of 1 or higher
set foldlevelstart=1 "start editing all buffers with some folds closed
set foldmethod=marker "folds on markers
set foldnestmax=5 "only nest 5 folds at max when auto folding
set foldopen=block,insert,jump,mark,percent,quickfix,search,tag,undo
set gdefault "makes /g the default on substitute
set hidden "don't delete buffer when abandoned
set ignorecase "case insensitive search
set lazyredraw "don't redraw the screen while executing macros
set list "show symbols for whitespace characters
set listchars+=extends:>,precedes:<
set magic "unescaped . and * in regex are special chars
set matchtime=5 "how long in tenths of a second to show matching parens
set modeline "check file for vim options
set modelines=10 "check 10 lines for options
set noequalalways "don't make windows same size automatically
set noesckeys "esc enters command mode instantly
set nofoldenable "disable folding by default
set nojoinspaces "don't insert space after word-terminating chars when using J and gq
set nosmartindent "the name of this option is misleading
set noswapfile "don't save swap files
set nowrap "don't wrap lines
set nrformats=alpha,hex,octal "increment chars, consider 0x and #x to be decimal
set number "show line numbers
set pastetoggle=<F2> "F2 toggles pastemode
set path+=./**  "search recursively downards
set report=5 "threshold for showing when a number of lines are changed
set scrolloff=5 "keep 5 lines above or below current line
set shiftwidth=2 "< and > indent width
set shortmess=aOstTAI "help avoid hit enter prompts
set showbreak=|
set showmode "show mode
set showtabline=1 "show tab line when more than one open
set sidescrolloff=5 "keep 5 lines left or right of cursor
set smartcase "stops ignoring case when capitals used
set softtabstop=2 "treat 2 consecutive spaces as a tab
set splitbelow "open splits below current window
set splitright "open vertical splits to the right of the current window
set startofline "jump commands move to first non-blank character
set switchbuf=usetab "jump to first open window or tab with a buffer
set tabstop=2 "tab width
set textwidth=79 "used for &colorcolumn
set undodir=$HOME/.vim/tmp/undo// "undo file directory
set undofile "persistent undo history
set undolevels=1000 "number of undo levels to save
set virtualedit=block "allow cursor to be placed on nonexistent locations in block mode
set wildignore+=*.jpg,*.gif,*.png,*.o,*.obj,*.bak,*.rbc
set wildignore+=.git/*,.hg/*,.svn/*,*/swp/*,*/undo/*,Gemfile.lock
set wildignore+=Icon*,\.DS_Store,*.out,*.scssc,*.sassc
set wildignore=*.dll,*.exe,*.pyc,*.pyo,*.egg,*.class
set wildignorecase "ignore case when completing
set wildmode=full "complete first full match
set winheight=5
set winminheight=5
set wrapscan "search wraps around end of document
" }}}

" Commands {{{
" Journal {{{
command! Journal execute 'e ~/Dropbox/Notes/logs/'.strftime('%m-%d-%y').'.md'
" }}}

" Notes {{{
function! Notes()
  let notes_dir = '~/Dropbox/Notes'
  exec 'lcd' l:notes_dir
  exec 'CtrlP' l:notes_dir
endfunction
command! Notes :call Notes()
nnoremap <leader>n :Notes<cr>
" }}}

" Timestamp {{{
command! Timestamp execute 'normal o## '.strftime("%I:%M%p")
"}}}
"}}}

" Functions {{{
" ClearRegisters {{{
function! ClearRegisters()
  let regs = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789/-"'
  let i=0
  while (i < strlen(regs))
    exec "let @".regs[i]."=''"
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

" Rails {{{
nnoremap <leader>gr :topleft :split config/routes.rb<cr>
nnoremap <leader>gg :topleft 100 :split Gemfile<cr>
nnoremap <leader>gd :topleft 100 :split db/schema.rb<cr>
let g:rails_gem_projections = {
      \ "active_model_serializers": {
      \   "app/serializers/*_serializer.rb": {
      \     "command": "serializer",
      \     "affinity": "model"}}
      \}
let g:rails_projections = { "config/routes.rb": {"command": "routes"}}
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

" WordProcessorMode {{{
function! WordProcessorMode()
  setlocal formatoptions=1
  setlocal spell spelllang=en_us
  setlocal formatprg=par
  setlocal wrap
  setlocal linebreak
  setlocal nolist
  setlocal tw=0
endfu
command! WP call WordProcessorMode()
" }}}
"}}}

" Maps {{{
" Useless Keys {{{
noremap <F1> <nop>
" }}}

" Command Mode {{{
cnoremap <expr> %%  getcmdtype() == ':' ? fnameescape(expand('%:h')).'/' : '%%'
cnoremap <c-o> <up>
" }}}

" Insert Mode {{{
inoremap <c-c> <esc>zza
"center current line on screen

" make c-w undoable
inoremap <c-w> <c-g>u<c-w>

imap <c-l> <Plug>CapsLockToggle

inoremap <c-c> <esc>
" }}}

" Normal Mode {{{
nnoremap ' `
nnoremap ` '
nnoremap H g^
xnoremap H g^
nnoremap L g_
xnoremap L g_
nnoremap <c-y> 5<c-y>
nnoremap <c-e> 5<c-e>
nnoremap <c-j> <c-w><c-j>
nnoremap <c-k> <c-w><c-k>
nnoremap <c-l> <c-w><c-l>
nnoremap <bs> <c-w><c-h>
nnoremap <c-=> <c-w>=
nnoremap <c-p> <c-^>
nnoremap & :&&<cr>
xnoremap & :&&<cr>
nnoremap Q gqip
xnoremap Q gq
nnoremap <leader>c :!git ctags<cr>
nnoremap Y y$
nnoremap ; :
nnoremap : ;
xnoremap ; :
xnoremap : ;
nnoremap q; q:
nnoremap <tab> :set hlsearch!<cr>
nnoremap vv ^vg_

if !(has("gui_running"))
  nnoremap <c-z> :wa<bar>suspend<cr>
endif

function! MapCR()
  nnoremap <expr> <cr> (&buftype is# "quickfix" ? "\<cr>" : ":up\<bar>GitGutter\<cr>")
endfunction
call MapCR()
autocmd! CmdwinEnter * :unmap <cr>
autocmd! CmdwinLeave * :call MapCR()
" }}}

" Move By Display Lines {{{
noremap j gj
noremap k gk
noremap gj j
noremap gk k
" }}}
" }}}

" Plugins {{{
" CtrlP {{{
let g:ctrlp_max_height = 10
let g:ctrlp_match_window_reversed = 0
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_max_files = 0
let g:ctrlp_prompt_mappings = {
      \ 'PrtSelectMove("j")':   ['<c-n>', '<c-j>', '<s-tab>'],
      \ 'PrtSelectMove("k")':   ['<c-p>', '<c-k>', '<tab>'],
      \ 'PrtHistory(-1)':       ['<down>'],
      \ 'PrtHistory(1)':        ['<up>'],
      \ 'ToggleFocus':          ['<c-tab>'],
      \ }
let g:ctrlp_dotfiles = 0
let g:ctrlp_extensions = ['register']
let g:ctrlp_jump_to_buffer = 0
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_arg_map = 1
let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard | sed -n "/.keep/!p"',
      \ "find %s '(' -type f -or -type l ')' -maxdepth 15 -not -path '*/\\.*/*'"]
let g:ctrlp_mruf_relative = 1
let g:ctrlp_mruf_exclude = '.*/\.git/.*\|.*/mutt/tmp/.*'
let g:ctrlp_map = '<leader><leader>'
nnoremap \\ :CtrlPBuffer<cr>
nnoremap <localleader><localleader> :CtrlPMRU<cr>
" }}}

" Deoplete {{{
let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_smart_case = 1
let g:deoplete#disable_auto_complete = 1
function! CleverTab()
   if strpart( getline('.'), 0, col('.')-1 ) =~ '^\s*$'
     return "\<tab>"
   elseif pumvisible()
     return "\<c-n>"
   else
     return deoplete#mappings#manual_complete()
   endif
endfunction
inoremap <expr><tab> CleverTab()
" }}}

" Dispatch {{{
nnoremap g<space> :up<bar>Dispatch<cr>
" }}}

" Expand Region {{{
vmap v <plug>(expand_region_expand)
vmap V <plug>(expand_region_shrink)
" }}}

" Gist {{{
let g:gist_detect_filetype = 1
if has("mac")
  let g:gist_clip_command = 'pbcopy'
else
  let g:gist_clip_command = 'xclip -selection clipboard'
endif
" }}}

" KWBD {{{
map <leader>d <plug>Kwbd
" }}}

" QUnit {{{
function! s:OpenQUnit()
  let l:test_name = ''

  for l:line in readfile(bufname('%'), '')
    if line =~ "^moduleFor"
      let l:test_name = matchstr(line, '\v, ''\zs.*\ze''')
      break
    elseif line =~ "^module"
      let l:test_name = matchstr(line, '\v''\zs.*\ze''')
      break
    endif
  endfor

  if len(test_name)
    silent execute "!open 'http://localhost:3000/tests?module=".test_name."'"
    redraw!
  else
    echom 'No test module found'
  endif
endfunction

command! OpenQUnit call s:OpenQUnit()
au FileType javascript,coffee nnoremap <buffer> <leader>r :OpenQUnit<cr>
" }}}

" Rubocop {{{
let g:vimrubocop_keymap=0
" }}}

" Ruby {{{
let g:rubycomplete_buffer_loading = 1
let g:rubycomplete_classes_in_global = 1
let g:rubycomplete_rails = 1
" }}}

" Ruby Refactoring {{{
let g:ruby_refactoring_map_keys=0
" }}}

" Sideways {{{
nnoremap ch :SidewaysLeft<cr>
nnoremap cl :SidewaysRight<cr>
" }}}

" Surround {{{
let g:surround_35  = "#{\r}"      " #
let g:surround_45 = "<% \r %>"    " -
let g:surround_61 = "<%= \r %>"   " =
" }}}

" Sneak {{{
let g:sneak#streak=1
let g:sneak#s_next=1
nmap f <Plug>Sneak_f
nmap F <Plug>Sneak_F
xmap f <Plug>Sneak_f
xmap F <Plug>Sneak_F
omap f <Plug>Sneak_f
omap F <Plug>Sneak_F
nmap t <Plug>Sneak_t
nmap T <Plug>Sneak_T
xmap t <Plug>Sneak_t
xmap T <Plug>Sneak_T
omap t <Plug>Sneak_t
omap T <Plug>Sneak_T
" }}}

" Switch {{{
nnoremap c= :Switch<cr>
" }}}

" Test {{
let test#strategy = "dispatch"
nnoremap <leader>t :TestNearest<CR>
nnoremap <leader>T :TestFile<CR>
nnoremap <leader>a :TestSuite<CR>
nnoremap <leader>l :TestLast<CR>
" }}

" ZoomWin {{{
nmap <leader>z <c-w>o
" }}}
" }}}

set secure
