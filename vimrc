set nocompatible "no vi compatibility

" Packages {{{
packadd minpac

call minpac#init()

call minpac#add('airblade/vim-gitgutter')
call minpac#add('AndrewRadev/linediff.vim')
call minpac#add('AndrewRadev/sideways.vim')
call minpac#add('AndrewRadev/splitjoin.vim')
call minpac#add('AndrewRadev/switch.vim')
call minpac#add('ctrlpvim/ctrlp.vim')
call minpac#add('elixir-lang/vim-elixir')
call minpac#add('godlygeek/tabular')
call minpac#add('google/vim-jsonnet')
call minpac#add('haya14busa/vim-asterisk')
call minpac#add('haya14busa/is.vim')
call minpac#add('henrik/vim-indexed-search')
call minpac#add('idanarye/vim-merginal')
call minpac#add('janko-m/vim-test')
call minpac#add('jiangmiao/auto-pairs')
call minpac#add('joshdick/onedark.vim')
call minpac#add('junegunn/gv.vim')
call minpac#add('kana/vim-textobj-entire')
call minpac#add('kana/vim-textobj-fold')
call minpac#add('kana/vim-textobj-indent')
call minpac#add('kana/vim-textobj-line')
call minpac#add('kana/vim-textobj-user')
call minpac#add('k-takata/minpac', {'type':'opt'})
call minpac#add('mattn/gist-vim')
call minpac#add('mattn/webapi-vim')
call minpac#add('mbbill/undotree')
call minpac#add('nelstrom/vim-markdown-folding')
call minpac#add('nelstrom/vim-textobj-rubyblock')
call minpac#add('ngmy/vim-rubocop')
call minpac#add('othree/html5.vim')
call minpac#add('pangloss/vim-javascript')
call minpac#add('rust-lang/rust.vim')
call minpac#add('Shougo/neocomplete.vim')
call minpac#add('slim-template/vim-slim')
call minpac#add('tommcdo/vim-exchange')
call minpac#add('tpope/vim-abolish')
call minpac#add('tpope/vim-afterimage')
call minpac#add('tpope/vim-bundler')
call minpac#add('tpope/vim-capslock')
call minpac#add('tpope/vim-characterize')
call minpac#add('tpope/vim-commentary')
call minpac#add('tpope/vim-cucumber')
call minpac#add('tpope/vim-dadbod')
call minpac#add('tpope/vim-dispatch')
call minpac#add('tpope/vim-dotenv')
call minpac#add('tpope/vim-endwise')
call minpac#add('tpope/vim-eunuch')
call minpac#add('tpope/vim-flagship')
call minpac#add('tpope/vim-fugitive')
call minpac#add('tpope/vim-git')
call minpac#add('tpope/vim-haml')
call minpac#add('tpope/vim-jdaddy')
call minpac#add('tpope/vim-markdown')
call minpac#add('tpope/vim-projectionist')
call minpac#add('tpope/vim-ragtag')
call minpac#add('tpope/vim-rails')
call minpac#add('tpope/vim-rake')
call minpac#add('tpope/vim-repeat')
call minpac#add('tpope/vim-rhubarb')
call minpac#add('tpope/vim-rsi')
call minpac#add('tpope/vim-scriptease')
call minpac#add('tpope/vim-sensible')
call minpac#add('tpope/vim-sleuth')
call minpac#add('tpope/vim-speeddating')
call minpac#add('tpope/vim-surround')
call minpac#add('tpope/vim-tbone')
call minpac#add('tpope/vim-unimpaired')
call minpac#add('tpope/vim-vinegar')
call minpac#add('vim-ruby/vim-ruby')
call minpac#add('vim-scripts/kwbdi.vim')
call minpac#add('wellle/targets.vim')
call minpac#add('zerowidth/vim-copy-as-rtf')

packloadall

command! PackUpdate call minpac#update()
command! PackClean call minpac#clean()
" }}}

filetype plugin indent on
set ttyfast "improves copy/paste for terminals
set visualbell t_vb= "no bell
set mouse=a "enable mouse in all modes
set cpoptions=aABceFsmq "copy options
set exrc "local for .vimrc in CWD

if filereadable(expand("~/.vimrc.before"))
  source ~/.vimrc.before
endif

" AutoCMD {{{
aug vimrc
  " Workaround for https://github.com/airblade/vim-gitgutter/issues/502
  autocmd BufWritePost * GitGutter
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
  au FileType mail if getline(1) =~ '^[A-Za-z-]*:\|^From ' | exe 'norm gg}' |endif
  au FileType mail,markdown call WordProcessorMode()
  au FileType vim  setlocal keywordprg=:help nojoinspaces
  au FileType handlebars setlocal commentstring={{!%s}}
aug END
" }}}

" Settings {{{
let mapleader = "\<space>"
let maplocalleader = ','

let g:onedark_termcolors=16
colo onedark

set background=dark
set backup "enable backup
set backupdir=$HOME/.vim/tmp/backup// "backup file directory
set backupskip=/tmp/*,/private/tmp/* "skip backups for these directories
set breakindent "visually indent wrapped lines
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
set listchars=extends:>,precedes:<,tab:>-
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
set shell=bash "zsh's path gets screwed up on OS X
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
set tags^=./.git/tags;
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
" DiffSCP {{{
function! DiffSCP(host)
  exec 'diffsplit scp://'.a:host.'/'.expand('%:p')
endfunction
command! -nargs=1 DiffSCP :call DiffSCP(<f-args>)
" }}}

" Journal {{{
command! Journal execute 'e ~/Dropbox/Notes/logs/'.strftime('%m-%d-%y').'.md'
" }}}

" Marked {{{
command! Marked execute "!open '%' -a '/Applications/Marked 2.app/'"
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
nnoremap <c-h> <c-w><c-h>
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
nnoremap g<cr> :Gwrite<cr>

nnoremap gy :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
      \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
      \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<cr>

if !(has("gui_running"))
  nnoremap <c-z> :wa<bar>suspend<cr>
endif

function! MapCR()
  nnoremap <expr> <cr> (&buftype is# "quickfix" ? "\<cr>" : ":up\<cr>")
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
" Asertisk{{{
map *  <Plug>(asterisk-z*)<Plug>(is-nohl-1)
map g* <Plug>(asterisk-gz*)<Plug>(is-nohl-1)
map #  <Plug>(asterisk-z#)<Plug>(is-nohl-1)
map g# <Plug>(asterisk-gz#)<Plug>(is-nohl-1)
" }}}

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
nnoremap <leader><leader> :CtrlP<cr>
nnoremap \\ :CtrlPBuffer<cr>
nnoremap <localleader><localleader> :CtrlPMRU<cr>
" }}}

" Neocomplete {{{
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#enable_smart_case = 1
let g:neocomplete#disable_auto_complete = 1
function! CleverTab()
   if strpart( getline('.'), 0, col('.')-1 ) =~ '^\s*$'
     return "\<tab>"
   elseif pumvisible()
     return "\<c-n>"
   else
     return neocomplete#start_manual_complete()
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
    silent execute "!open -a '/Applications/Google Chrome.app' 'http://localhost:4200/tests?module=".test_name."'"
    redraw!
  else
    echom 'No test module found'
  endif
endfunction

command! OpenQUnit call s:OpenQUnit()
au FileType javascript,coffee nnoremap <buffer> <leader>r :OpenQUnit<cr>
" }}}

" Markdown Preview {{{
let g:mkdp_path_to_chrome = 'open -a /Applications/Google\ Chrome.app'
let g:mkdp_refresh_slow = 1
" }}}

" Rubocop {{{
let g:vimrubocop_keymap=0
" }}}

" Ruby {{{
let g:rubycomplete_buffer_loading = 1
let g:rubycomplete_classes_in_global = 1
let g:rubycomplete_rails = 1
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

" SplitJoin {{{
let g:splitjoin_ruby_curly_braces=0
" }}}

" Switch {{{
nnoremap c= :Switch<cr>
" }}}

" Test {{
let test#strategy = "dispatch"
nnoremap <leader>t :w<bar>TestFile<CR>
nnoremap <leader>T :w<bar>TestNearest<CR>
nnoremap <leader>a :w<bar>TestSuite<CR>
nnoremap <leader>l :w<bar>TestLast<CR>
" }}

" ZoomWin {{{
nmap <leader>z <c-w>o
" }}}
" }}}

set secure
