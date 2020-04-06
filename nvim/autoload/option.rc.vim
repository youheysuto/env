set fenc=utf-8
set fileformats=unix,dos,mac
set nobackup
set noswapfile
set autoread
set hidden
set showcmd
set number
set relativenumber
set virtualedit=onemore
set smartindent
set visualbell
set showmatch
set laststatus=2
set wildmode=list:longest
set ignorecase
set wrapscan
set hlsearch
set expandtab
set tabstop=2
set shiftwidth=2
set inccommand=split
set clipboard=unnamed
set cursorcolumn
set list "スペースの可視化"
set listchars=tab:»\ ,trail:-,extends:»,precedes:«,nbsp:% 

" using tmux 
if (empty($TMUX))
  if (has("nvim"))
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  if (has("termguicolors"))
    set termguicolors
  endif
endif

" Required
filetype plugin indent on
syntax enable
