function! InsertNewLine()
  let c = getline(".")[col(".") - 1]
  if c == ' '
    exe "normal r\<cr>"
  else
    exe "normal i\<bs>\<cr>"
  endif
endfunction
nnoremap K :call InsertNewLine()<cr>
