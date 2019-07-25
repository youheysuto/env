
" build and run clang
command! Gcc call s:Gcc()
function! s:Gcc()
  :!gcc % -o a.out
  :!./a.out
endfunction
