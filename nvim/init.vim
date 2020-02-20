" python host settings using pyenv
let g:python_host_prog  = $PYENV_ROOT.'/versions/neovim2/bin/python'
let g:python3_host_prog = $PYENV_ROOT.'/versions/neovim3/bin/python'

" set leader
let mapleader = "\<space>"

" dein scripts start
let s:dein_dir      = expand('~/.cache/dein')
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
let s:toml_dir = $HOME.'/.config/nvim/'

" memo files path
let g:memo_path='~/OneDrive/docs/memo'

" dein installation check
if &runtimepath !~# '/dein.vim'
  if !isdirectory(s:dein_repo_dir)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
  endif
  execute 'set runtimepath^=' . s:dein_repo_dir
endif

if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)
    call dein#load_toml(s:toml_dir.'dein.toml',{'lazy':0})
    call dein#load_toml(s:toml_dir.'lazy.toml',{'lazy':1})
  call dein#end()
  call dein#save_state()
endif

if dein#check_install()
  call dein#install()
endif

" remove plugin check
let s:removed_plugins = dein#check_clean()
if len(s:removed_plugins) > 0
  call map(s:removed_plugins, "delete(v:val, 'rf')")
  call dein#recache_runtimepath()
endif

" my settings
runtime! autoload/*.vim

