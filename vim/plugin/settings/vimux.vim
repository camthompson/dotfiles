let g:VimuxUseNearestPane=1

map <leader>vp :VimuxPromptCommand<CR>
map <leader>vl :VimuxRunLastCommand<CR>
map <leader>vq :VimuxCloseRunner<CR>
map <leader>vs :VimuxInterruptRunner<CR>
map <leader>vr :call VimuxRunCommand("clear; ruby " . bufname("%"))<cr>
