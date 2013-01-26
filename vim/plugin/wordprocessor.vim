func! WordProcessorMode()
  setlocal formatoptions=1
  setlocal noexpandtab
  setlocal spell spelllang=en_us
  set formatprg=par
  setlocal wrap
  setlocal linebreak
  setlocal nolist
endfu
com! WP call WordProcessorMode()
