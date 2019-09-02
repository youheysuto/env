" " (nvim@0.4 >=) floating options
" let s:denite_win_width_percent = 0.85
" let s:denite_win_height_percent = 0.7
" call denite#custom#option('default', {
"     \ 'split': 'floating',
"     \ 'winwidth': float2nr(&columns * s:denite_win_width_percent),
"     \ 'wincol': float2nr((&columns - (&columns * s:denite_win_width_percent)) / 2),
"     \ 'winheight': float2nr(&lines * s:denite_win_height_percent),
"     \ 'winrow': float2nr((&lines - (&lines * s:denite_win_height_percent)) / 2),
"     \ })

" Denite open buffer settings
autocmd FileType denite call s:denite_my_settings()
function! s:denite_my_settings() abort
  nnoremap <silent><buffer><expr> <CR>
  \ denite#do_map('do_action')
  nnoremap <silent><buffer><expr> d
  \ denite#do_map('do_action', 'delete')
  nnoremap <silent><buffer><expr> p
  \ denite#do_map('do_action', 'preview')
  nnoremap <silent><buffer><expr> q
  \ denite#do_map('quit')
  nnoremap <silent><buffer><expr> i
  \ denite#do_map('open_filter_buffer')
  nnoremap <silent><buffer><expr> <Space>
  \ denite#do_map('toggle_select').'j'
endfunction

autocmd FileType denite-filter call s:denite_filter_my_setting()
function! s:denite_filter_my_setting() abort
  " inoremap <silent><buffer><expr> <BS>    denite#do_map('move_up_path')
  inoremap <silent><buffer><expr> <C-c>   denite#do_map('quit')
  nnoremap <silent><buffer><expr> <C-c>   denite#do_map('quit')
endfunction

call denite#custom#option('_', {
      \ 'cached_filter': v:true,
      \ 'cursor_shape': v:true,
      \ 'cursor_wrap': v:true,
      \ 'highlight_filter_background': 'DeniteFilter',
      \ 'highlight_matched_char': 'Underlined',
      \ 'matchers': 'matcher_cpsm',
      \ 'prompt': '$ ',
      \ 'start_filter':v:true,
      \ 'statusline':v:false,
      \})

call denite#custom#source('file/rec', 'matchers', ['matcher_cpsm','matcher_ignore_globs'])
call denite#custom#source('file/old', 'matchers', ['matcher_ignore_globs'])
call denite#custom#source('grep', 'matchers', ['matcher_ignore_globs'])
call denite#custom#filter('matcher_ignore_globs', 'ignore_globs',
      \ [
      \ '.git/', 'build/', '__pycache__/','node_modules/',
      \ 'images/', '*.o', '*.make', '*.png', '*.jpg', '*.PNG',
      \ '*.min.*',
      \ 'img/', 'fonts/'])

" keymappings
nnoremap [denite] <Nop>
nmap <C-d> [denite]
nnoremap <silent> [denite]g :<C-u>Denite grep -buffer-name=search-buffer-denite<CR>
nnoremap <silent> [denite]p :<C-u>Denite file/rec<CR>
nnoremap <silent> [denite]r :<C-u>Denite -resume -buffer-name=search-buffer-denite<CR>
nnoremap <silent> [denite]b :<C-u>Denite -no-statusline buffer<CR>
nnoremap <silent> [denite]s :<C-u>Denite documentSymbol<CR>
nnoremap <silent> [denite]w :<C-u>DeniteCursorWord -no-statusline grep -buffer-name=search line<CR><C-R><C-W><CR>
nnoremap <silent> [denite]u :<C-u>Denite file/old<CR>

" replace grep2rg
if executable('rg')
  call denite#custom#var('file_rec', 'command',
        \ ['rg', '--files', '--glob', '!.git'])
  call denite#custom#var('grep', 'command', ['rg', '--threads', '1'])
  call denite#custom#var('grep', 'recursive_opts', [])
  call denite#custom#var('grep', 'final_opts', [])
  call denite#custom#var('grep', 'separator', ['--'])
  call denite#custom#var('grep', 'default_opts',
        \ ['--vimgrep', '--no-heading'])
endif
