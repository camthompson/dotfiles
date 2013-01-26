let g:ctrlp_max_height = 10
let g:ctrlp_match_window_reversed = 0
let g:ctrlp_prompt_mappings = {
      \ 'PrtSelectMove("j")':   ['<c-n>', '<down>', '<s-tab>'],
      \ 'PrtSelectMove("k")':   ['<c-p>', '<up>', '<tab>'],
      \ 'PrtHistory(-1)':       ['<c-j>'],
      \ 'PrtHistory(1)':        ['<c-k>'],
      \ 'ToggleFocus()':        ['<c-tab>'],
      \ }
let g:ctrlp_dotfiles = 0
let g:ctrlp_extensions = ['tag', 'quickfix', 'dir']
let g:ctrlp_mruf_max = 100
let g:ctrlp_use_caching = 1
let g:ctrlp_map = '<leader><leader>'
let g:ctrlp_jump_to_buffer = 0
let g:ctrlp_max_files = 10000
let g:ctrlp_working_path_mode = 'rc'
let g:ctrlp_arg_map = 1
let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard',
      \ "find %s '(' -type f -or -type l ')' -maxdepth 15 -not -path '*/\\.*/*'"]
let g:ctrlp_mruf_relative = 1
nnoremap \\ :CtrlP<cr>
nnoremap -- :CtrlPMRU<cr>
nnoremap ,, :CtrlPBuffer<cr>
