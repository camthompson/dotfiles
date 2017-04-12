if filereadable(expand("~/.vimrc.after"))
  source ~/.vimrc.after
endif
delfunction SleuthIndicator
