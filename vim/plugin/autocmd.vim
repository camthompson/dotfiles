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

aug FTOptions
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
  au FileType gitrebase nnoremap <buffer> S :Cycle<CR>
  au FileType help setlocal ai fo+=2n | silent! setlocal nospell
  au FileType help nnoremap <silent><buffer> q :q<CR>
  au FileType html setlocal iskeyword+=~
  au FileType mail if getline(1) =~ '^[A-Za-z-]*:\|^From ' | exe 'norm gg}' |endif|silent! setlocal spell
  au FileType vim  setlocal keywordprg=:help nojoinspaces
aug END

" For whatever reason, this breaks shit if mapped normally
au VimEnter * noremap ; :
