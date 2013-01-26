augroup vimrc
  au!

  au BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  if exists('+relativenumber')
    au WinLeave *
          \ if &rnu == 1 && bufname("%") !~# "Result" && &ft != "help" |
          \ exe "setl norelativenumber" |
          \ exe "setl number" |
          \ endif
    au WinEnter *
          \ if &rnu == 0 && bufname("%") !~# "Result" && &ft != "help" |
          \ exe "setl relativenumber" |
          \ endif
  endif

  au InsertEnter * set colorcolumn+=81 noignorecase listchars-=trail:·
  au InsertLeave * set colorcolumn-=81 ignorecase listchars+=trail:·

  au FileType python set sw=4 sts=4 et
  au FileType markdown set ai formatoptions=tcroqn2 comments=n:&gt;
  au Filetype qf setlocal colorcolumn=0 nolist nocursorline nowrap
  au FileType vim setlocal foldmethod=marker foldenable foldlevel=0

  au BufReadPost fugitive://* setlocal bufhidden=delete

  " For whatever reason, this breaks shit if mapped normally
  au VimEnter * noremap ; :
augroup END
