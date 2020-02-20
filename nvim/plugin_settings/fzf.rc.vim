" using fzf
set rtp+=~/.fzf

" Rg
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case --hidden --follow '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview({'options': '--exact --reverse --delimiter : --nth 3..'}), <bang>0)

" Memo settings
command! -bang MemoFiles call fzf#vim#files(memo_path, fzf#vim#with_preview(), <bang>0)
command! -bang -nargs=* MemoGrep
  \ call fzf#vim#grep(
  \   'rg --line-number --no-filename --color=always --smart-case --hidden --follow '.shellescape(<q-args>).' '.memo_path, 1,
  \   fzf#vim#with_preview({'options': '--exact --reverse --delimiter : --nth 3..'}), <bang>0)

" Hide statusline
autocmd! FileType fzf
autocmd  FileType fzf set nonumber norelativenumber
  \| autocmd BufLeave <buffer> set number relativenumber

" keymappings
nnoremap [fzf] <Nop>
nmap <C-d> [fzf]
nnoremap <silent> [fzf]p :<C-u>Files<CR>
nnoremap <silent> [fzf]g :<C-u>Rg<CR>
nnoremap <silent> [fzf]l :<C-u>Lines<CR>
nnoremap <silent> [fzf]b :<C-u>Buffers<CR>
nnoremap <silent> [fzf]r :<C-u>History<CR>
nnoremap <silent> [fzf]s :<C-u>GFiles<CR>
nnoremap <silent> [fzf]d :<C-u>GFiles?<CR>
nnoremap <silent> [fzf]m :<C-u>MemoFiles<CR>
nnoremap <silent> [fzf]mg :<C-u>MemoGrep<CR>

