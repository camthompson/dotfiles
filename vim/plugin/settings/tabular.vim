function! s:align()
  let p = '^\s*|\s.*\s|\s*$'
  if exists(':Tabularize') && getline('.') =~# '^\s*|' && (getline(line('.')-1) =~# p || getline(line('.')+1) =~# p)
    let column = strlen(substitute(getline('.')[0:col('.')],'[^|]','','g'))
    let position = strlen(matchstr(getline('.')[0:col('.')],'.*|\s*\zs.*'))
    Tabularize/|/l1
    normal! 0
    call search(repeat('[^|]*|',column).'\s\{-\}'.repeat('.',position),'ce',line('.'))
  endif
endfunction
inoremap <silent> <Bar> <Bar><Esc>:call <SID>align()<cr>a
nnoremap <leader>= :Tabularize /=<cr>
xnoremap <leader>= :Tabularize /=<cr>
nnoremap <leader>: :Tabularize /:\zs<cr>
xnoremap <leader>: :Tabularize /:\zs<cr>
nnoremap <leader>, :Tabularize /,\zs<cr>
xnoremap <leader>, :Tabularize /,\zs<cr>
nnoremap <leader><bar> :Tabularize /<bar><cr>
vnoremap <leader><bar> :Tabularize /<bar><cr>
