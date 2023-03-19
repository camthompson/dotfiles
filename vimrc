set nocompatible "no vi compatibility

" Packages {{{
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/bundle')

Plug 'airblade/vim-gitgutter'
Plug 'AndrewRadev/linediff.vim'
Plug 'AndrewRadev/sideways.vim'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'AndrewRadev/switch.vim'
Plug 'christoomey/vim-tmux-runner'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'elixir-lang/vim-elixir'
Plug 'godlygeek/tabular'
Plug 'google/vim-jsonnet'
Plug 'haya14busa/vim-asterisk'
Plug 'haya14busa/is.vim'
Plug 'henrik/vim-indexed-search'
Plug 'idanarye/vim-merginal'
Plug 'janko-m/vim-test'
Plug 'jiangmiao/auto-pairs'
Plug 'joshdick/onedark.vim'
Plug 'joukevandermaas/vim-ember-hbs'
Plug 'junegunn/gv.vim'
Plug 'leafgarland/typescript-vim'
Plug 'ludovicchabant/vim-gutentags'
Plug 'kana/vim-textobj-entire'
Plug 'kana/vim-textobj-fold'
Plug 'kana/vim-textobj-indent'
Plug 'kana/vim-textobj-line'
Plug 'kana/vim-textobj-user'
Plug 'mattn/gist-vim'
Plug 'mattn/webapi-vim'
Plug 'mbbill/undotree'
Plug 'nelstrom/vim-markdown-folding'
Plug 'nelstrom/vim-textobj-rubyblock'
Plug 'nelsyeung/twig.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'ngmy/vim-rubocop'
Plug 'othree/html5.vim'
Plug 'pangloss/vim-javascript'
Plug 'rust-lang/rust.vim'
Plug 'slim-template/vim-slim'
Plug 'tommcdo/vim-exchange'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-afterimage'
Plug 'tpope/vim-bundler'
Plug 'tpope/vim-capslock'
Plug 'tpope/vim-characterize'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-cucumber'
Plug 'tpope/vim-dadbod'
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
Plug 'w0rp/ale'
Plug 'wellle/targets.vim'
Plug 'zerowidth/vim-copy-as-rtf'

call plug#end()
" }}}

for p in glob('~/.vim/pack/*/start/*/doc', 1, 1)
  exe 'helptags ' . p
endfor

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
set shiftwidth=2 "< and > indent width
set shortmess=aOstTAI "help avoid hit enter prompts
set showbreak=|
set showmode "show mode
set showtabline=1 "show tab line when more than one open
set sidescrolloff=5 "keep 5 lines left or right of cursor
set signcolumn=yes "recommended by coc
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
set updatetime=300 "recommended by coc
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
nnoremap g<cr> :Gwrite<bar>w<cr>

nnoremap gy :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
      \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
      \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<cr>

if !(has("gui_running"))
  nnoremap <c-z> :wa<bar>suspend<cr>
endif

function! MapCR()
  nnoremap <expr> <cr> (&buftype is# "quickfix" ? "\<cr>" : ":w\<cr>")
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
" ALE {{{
let g:ale_linters =
      \ {'javascript': ['eslint'],
      \  'python': ['flake8', 'mypy'],
      \  'typescript': ['tsserver', 'eslint'],
      \  'typescript.tsx': ['tsserver', 'eslint']}
let g:ale_fixers = {'javascript': [], 'typescript': ['prettier'], 'typescript.tsx': ['prettier']}
let g:ale_lint_on_text_changed = 'normal'
let g:ale_lint_on_insert_leave = 1
let g:ale_lint_delay = 0
let g:ale_set_quickfix = 0
let g:ale_set_loclist = 0
let g:ale_javascript_eslint_executable = 'eslint --cache'
nnoremap gj :ALENextWrap<cr>
nnoremap gk :ALEPreviousWrap<cr>
nnoremap g1 :ALEFirst<cr>
" This mapping will kill all ALE-related processes (including tsserver). It's
" necessary when those processes get confused. E.g., tsserver will sometimes
" show type errors that don't actually exist. I don't know exactly why that
" happens yet, but I think that it's related to renaming files.
nnoremap g0 :ALEStopAllLSPs<cr>
" }}}

" Asertisk{{{
map *  <Plug>(asterisk-z*)<Plug>(is-nohl-1)
map g* <Plug>(asterisk-gz*)<Plug>(is-nohl-1)
map #  <Plug>(asterisk-z#)<Plug>(is-nohl-1)
map g# <Plug>(asterisk-gz#)<Plug>(is-nohl-1)
" }}}

" COC {{{
inoremap <silent><expr> <cr> coc#pum#visible() ? coc#_select_confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
" use <tab> to trigger completion and navigate to the next complete item
function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <silent><expr> <Tab>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr> <S-Tab> coc#pum#visible() ? coc#pum#prev(1) : "\<S-Tab>"
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
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files . -co --exclude-standard', 'find %s -type f']
let g:ctrlp_mruf_relative = 1
nnoremap <leader><leader> :CtrlP<cr>
nnoremap \\ :CtrlPBuffer<cr>
nnoremap <localleader><localleader> :CtrlPMRU<cr>
" }}}

" Dispatch {{{
nnoremap g<space> :w<bar>Dispatch<cr>
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
function! s:OpenQUnit(...)
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
    if (a:0 > 0)
      let l:port = a:1
    else
      let l:port = '4200'
    endif
    silent execute "!open -a '/Applications/Google Chrome.app' 'http://localhost:".port."/tests?module=".test_name."'"
    redraw!
  else
    echom 'No test module found'
  endif
endfunction

command! -nargs=? OpenQUnit call s:OpenQUnit(<f-args>)
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
let test#strategy = 'dispatch'
nnoremap <leader>t :w<bar>TestFile<CR>
nnoremap <leader>T :w<bar>TestNearest<CR>
nnoremap <leader>a :w<bar>TestSuite<CR>
nnoremap <leader>l :w<bar>TestLast<CR>
" }}

" Tsuquyomi {{{
" vim-ale handles TypeScript quickfix, so tell Tsuquyomi not to do it.
let g:tsuquyomi_disable_quickfix = 1
" }}}

" ZoomWin {{{
nmap <leader>z <c-w>o
" }}}
" }}}

if filereadable(expand("~/.vimrc.after"))
  source ~/.vimrc.after
endif

set secure
