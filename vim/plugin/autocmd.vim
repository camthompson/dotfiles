augroup vimrc
  au!

  " Go to last position in a file when opening
  au BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  " Show relative line numbers on active buffer
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

  " Highlight 81st column in insert mode; show trailing spaces when not
  " in insert; honestly I don't know why the ignorecase stuff is here
  au InsertEnter * set colorcolumn+=81 noignorecase listchars-=trail:·
  au InsertLeave * set colorcolumn-=81 ignorecase listchars+=trail:·

  " TODO: Figure out why this is here
  au FileType python set sw=4 sts=4 et
  au FileType markdown set ai formatoptions=tcroqn2 comments=n:&gt;
  au Filetype qf setlocal colorcolumn=0 nolist nocursorline nowrap
  au FileType vim setlocal foldmethod=marker foldenable foldlevel=0
  au BufEnter Gemfile,Rakefile,Thorfile,config.ru,Guardfile,Capfile,Vagrantfile setfiletype ruby
  au BufEnter *pryrc,*irbrc,*railsrc setfiletype ruby
  au FileType ruby,haml,eruby,yaml,html,javascript,sass,cucumber,coffee set ai sw=2 sts=2 et

  " TODO: Figure out if this is still necessary
  " For whatever reason, this breaks shit if mapped normally
  au VimEnter * noremap ; :
augroup END
