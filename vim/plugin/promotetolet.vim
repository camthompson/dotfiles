function! PromoteToLet()
  :normal! dd
  " :exec '?^\s*it\>'
  :normal! P
  :.s/\(\w\+\) = \(.*\)$/let(:\1) { \2 }/
  :normal ==
endfunction
au BufNewFile,BufRead *spec.rb :map <buffer> <leader>l :call PromoteToLet()<cr>
