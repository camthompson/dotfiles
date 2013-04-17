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
"
inoremap <c-\> <c-k>
" insert diacritic workaround for UltiSnips

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
noremap $ g$
noremap 0 g0
noremap ^ g^
noremap gj j
noremap gk k
noremap g$ $
noremap g0 0
noremap g^ ^
" }}}
