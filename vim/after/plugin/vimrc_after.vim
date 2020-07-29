nnoremap <c-p> <c-^>

if filereadable(expand("~/.vimrc.after"))
  source ~/.vimrc.after
endif
