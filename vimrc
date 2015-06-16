set nocompatible "no vi compatibility

" Plug {{{
call plug#begin('~/.vim/plugged')

Plug 'airblade/vim-gitgutter'
Plug 'altercation/vim-colors-solarized'
Plug 'AndrewRadev/linediff.vim'
Plug 'AndrewRadev/sideways.vim'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'AndrewRadev/switch.vim'
Plug 'AndrewRadev/undoquit.vim'
Plug 'benmills/vimux'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'ecomba/vim-ruby-refactoring'
Plug 'godlygeek/tabular'
Plug 'gregsexton/gitv'
Plug 'greyblake/vim-preview'
Plug 'guns/vim-clojure-static'
Plug 'haya14busa/incsearch.vim'
Plug 'henrik/vim-qargs'
Plug 'idanarye/vim-merginal'
Plug 'int3/vim-extradite'
Plug 'jiangmiao/auto-pairs'
Plug 'justinmk/vim-sneak'
Plug 'junegunn/vim-github-dashboard'
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
Plug 'scrooloose/syntastic'
Plug 'Shougo/neocomplete.vim'
Plug 'sickill/vim-pasta'
Plug 'skalnik/vim-vroom'
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
Plug 'tpope/vim-fireplace'
Plug 'tpope/vim-flagship'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-git'
Plug 'tpope/vim-haml'
Plug 'tpope/vim-jdaddy'
Plug 'tpope/vim-liquid'
Plug 'tpope/vim-markdown'
Plug 'tpope/vim-pathogen'
Plug 'tpope/vim-projectionist'
Plug 'tpope/vim-ragtag'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-rake'
Plug 'tpope/vim-repeat'
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
Plug 'vim-scripts/dbext.vim'
Plug 'vim-scripts/kwbdi.vim'
Plug 'vim-scripts/TailMinusF'
Plug 'wting/rust.vim'

Plug '~/.vim/bundle/ZoomWin'

Plug '~/src/vim-ember'

call plug#end()
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
  " Go to last position in a file when opening
  au BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \   exe "normal g`\"" |
        \ endif

  au InsertEnter * set listchars-=trail:-
  au InsertLeave * set listchars+=trail:-

  au FileType c,cpp,cs,java setlocal commentstring=//\ %s
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
  au FileType mail if getline(1) =~ '^[A-Za-z-]*:\|^From ' | exe 'norm gg}' |endif|silent! setlocal spell
  au FileType vim  setlocal keywordprg=:help nojoinspaces
aug END
" }}}

" Appearance {{{
set number "show line numbers
set scrolloff=5 "keep 5 lines above or below current line
set sidescrolloff=5 "keep 5 lines left or right of cursor
set list "show symbols for whitespace characters
set matchtime=5 "how long in tenths of a second to show matching parens
set cursorline "highlight the cursor line
set cursorcolumn "highlight the cursor column
set showtabline=1 "show tab line when more than one open
set fillchars=fold:\ ,vert:\| "fill characters for folds and vert splits
set lazyredraw "don't redraw the screen while executing macros
set colorcolumn=+1 "highlight column after &textwidth
set listchars=tab:▸\ ,extends:❯,precedes:❮
set showbreak=↪
set breakindent "visually indent wrapped lines
" }}}

" Behavior {{{
set textwidth=79 "used for &colorcolumn
set nowrap "don't wrap lines
set showmode "show mode
set startofline "jump commands move to first non-blank character
set magic "unescaped . and * in regex are special chars
set hidden "don't delete buffer when abandoned
set report=5 "threshold for showing when a number of lines are changed
set shortmess=aOstTAI "help avoid hit enter prompts
set formatoptions-=or "don't automatically comment lines
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
set winheight=5
set winminheight=5
set noesckeys "esc enters command mode instantly
set nojoinspaces "don't insert space after word-terminating chars when using J and gq
" }}}

" Completion {{{
set wildmode=full "complete first full match
"filetypes to ignore on tab-completion
set wildignore=*.dll,*.exe,*.pyc,*.pyo,*.egg,*.class
set wildignore+=*.jpg,*.gif,*.png,*.o,*.obj,*.bak,*.rbc
set wildignore+=Icon*,\.DS_Store,*.out,*.scssc,*.sassc
set wildignore+=.git/*,.hg/*,.svn/*,*/swp/*,*/undo/*,Gemfile.lock
" }}}

" Colorscheme {{{
set background=light
colo solarized
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

" WordProcessorMode {{{
function! WordProcessorMode()
  setlocal formatoptions=1
  setlocal noexpandtab
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

" Indentation/Tabs {{{
set tabstop=2 "tab width
set softtabstop=2 "treat 2 consecutive spaces as a tab
set expandtab "insert spaces instead of tabs
set shiftwidth=2 "< and > indent width
set nosmartindent "the name of this option is misleading
" }}}

" Maps {{{
let mapleader = "\<space>"
let maplocalleader = ','

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

" Set Filetypes {{{
nnoremap <localleader>co :setlocal filetype=coffee<CR>
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
let g:ctrlp_extensions = ['tag', 'quickfix', 'dir', 'rtscript' ]
let g:ctrlp_jump_to_buffer = 0
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_arg_map = 1
if executable('ag')
  let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard | sed -n "/.keep/!p"',
        \ 'ag %s -i --nocolor --nogroup --ignore ''.git'' --ignore ''.DS_Store'' --ignore ''node_modules'' --hidden -g ""']
else
  let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard | sed -n "/.keep/!p"',
        \ "find %s '(' -type f -or -type l ')' -maxdepth 15 -not -path '*/\\.*/*'"]
endif
let g:ctrlp_mruf_relative = 1
let g:ctrlp_mruf_exclude = '.*/\.git/.*\|.*/mutt/tmp/.*'
let g:ctrlp_map = '<leader><leader>'
nnoremap \\ :CtrlPBuffer<cr>
nnoremap <localleader><localleader> :CtrlPMRU<cr>
" }}}

" Dispatch {{{
let g:dispatch_compilers = { 'bundle exec': '', 'clear;': '', 'zeus': '' }
nnoremap g<cr> :up<bar>Dispatch<cr>
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

" Incsearch {{{
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)
let g:incsearch#auto_nohlsearch = 1
map n  <Plug>(incsearch-nohl-n)
map N  <Plug>(incsearch-nohl-N)
map *  <Plug>(incsearch-nohl-*)
map #  <Plug>(incsearch-nohl-#)
map g* <Plug>(incsearch-nohl-g*)
map g# <Plug>(incsearch-nohl-g#)
let g:incsearch#magic = '\v'
" }}}

" KWBD {{{
map <leader>d <plug>Kwbd
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
inoremap <expr><c-h> neocomplete#smart_close_popup()."\<c-h>"
inoremap <expr><bs> neocomplete#smart_close_popup()."\<c-h>"
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

" SplitJoin {{{
let g:splitjoin_ruby_curly_braces=0
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

" Syntastic {{{
let g:syntastic_ruby_checkers = ['mri', 'rubocop']
let g:syntastic_mode_map = { 'mode': 'passive',
                           \ 'active_filetypes': ['coffee'],
                           \ 'passive_filetypes': [] }
nnoremap <leader>s :up<bar>:SyntasticCheck<cr>
" }}}

" Vitality {{{
let g:vitality_fix_cursor=0
" }}}

" Vroom {{{
let g:vroom_clear_screen=0
let g:vroom_use_dispatch=1
let g:vroom_use_colors=1
let g:vroom_detect_spec_helper=1
let g:vroom_cucumber_path='cucumber'
let g:vroom_map_keys = 0
nnoremap <leader>r :VroomRunTestFile<cr>
nnoremap <leader>R :VroomRunNearestTest<CR>
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
set hlsearch "highlight search terms
" }}}

" Swap/Backup/Undo {{{
set undofile "persistent undo history
set undodir=$HOME/.vim/tmp/undo// "undo file directory
set undolevels=1000 "number of undo levels to save
set backup "enable backup
set backupdir=$HOME/.vim/tmp/backup// "backup file directory
set backupskip=/tmp/*,/private/tmp/* "skip backups for these directories
set directory=$HOME/.vim/tmp/swp// "swap file directory
set noswapfile "don't save swap files
" }}}

set secure
