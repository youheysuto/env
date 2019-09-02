" python host settings using pyenv
let g:python_host_prog  = $PYENV_ROOT.'/versions/neovim2/bin/python'
let g:python3_host_prog = $PYENV_ROOT.'/versions/neovim3/bin/python'

if &compatible
  set nocompatible
endif

" dein scripts start
let s:dein_dir      = expand('~/.cache/dein')
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
let s:toml_dir = $HOME.'/.config/nvim/'

set runtimepath+=~/.cache/dein/repos/github.com/Shougo/dein.vim

" set leader
let mapleader = "\<space>"

if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)
    call dein#load_toml(s:toml_dir.'dein.toml',{'lazy':0})
    call dein#load_toml(s:toml_dir.'lazy.toml',{'lazy':1})
  call dein#end()
  call dein#save_state()
endif

" nvim my settings
runtime! autoload/*.vim

if dein#check_install()
  call dein#install()
endif

