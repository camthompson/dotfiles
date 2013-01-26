if filereadable(expand("~/.gvimrc.before"))
  source ~/.gvimrc.before
endif

set guipty "attempts pseudo-tty
set co=90 "number of columns
set guioptions-=T "hide toolbar
set guioptions-=t "hide tearoff menu items
set guioptions-=l "hide left scrollbar
set guioptions-=L "hide left scrollbar when vert window split
set guioptions-=r "hide right scrollbar
set guioptions-=R "hide right scrollbar when vert window split
if has('fullscreen')
  set fuoptions=maxvert,maxhorz,background:Normal "fullscreen options
end

set guicursor=n-c:block-Cursor-blinkon0
set guicursor+=v:block-Cursor-blinkon0
set guicursor+=i-ci:ver10-Cursor-blinkon0

if has("gui_macvim")
  let macvim_skip_cmd_opt_movement = 1
  noremap   <D-Left>       <Home>
  noremap!  <D-Left>       <Home>
  noremap   <M-Left>       <C-Left>
  noremap!  <M-Left>       <C-Left>

  noremap   <D-Right>      <End>
  noremap!  <D-Right>      <End>
  noremap   <M-Right>      <C-Right>
  noremap!  <M-Right>      <C-Right>

  noremap   <D-Up>         <C-Home>
  inoremap  <D-Up>         <C-Home>
  imap      <M-Up>         <C-o>{

  noremap   <D-Down>       <C-End>
  inoremap  <D-Down>       <C-End>
  imap      <M-Down>       <C-o>}

  imap      <M-BS>         <C-w>
  inoremap  <D-BS>         <esc>my0c`y

  noremap <d-1> :e ~/Dropbox/Notes/inbox.txt<cr>
  noremap <d-2> :lcd ~/Dropbox/Notes<cr>:CtrlP<cr>
  noremap <d-3> :e $MYVIMRC<cr>
  noremap <d-4> :e $MYGVIMRC<cr>
  noremap <d-5> :so $MYVIMRC<cr>:so $MYGVIMRC<cr>
endif

if filereadable(expand("~/.gvimrc.after"))
  source ~/.gvimrc.after
endif
