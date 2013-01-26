function! Browser()
  let uri = matchstr(getline("."), '[a-z]*:\/\/[^ >,;]*')
  echo uri
  if uri != ""
    exec "!open \"" . uri . "\""
  else
    echo "No URI found in line."
  endif
endfunction
noremap <leader>3 :call Browser()<cr><cr>
