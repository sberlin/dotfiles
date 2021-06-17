set number
set relativenumber
set showbreak=+++
set textwidth=80
set formatoptions-=t
set showmatch
set visualbell

set hlsearch
set smartcase
set ignorecase
set incsearch

set autoindent
set expandtab
set shiftwidth=4
set smartindent
set smarttab
set tabstop=4
set nofixendofline
let g:netrw_liststyle=3
let g:netrw_altv=1
let g:netrw_winsize=-30
let g:netrw_preview=1

augroup ExtraWhitespace_cmd
  autocmd!
  autocmd BufWinEnter * highlight ExtraWhitespace ctermbg=red guibg=red
  autocmd BufWinEnter * call matchadd('ExtraWhitespace', '\s\+$')
augroup END

augroup OverLength_cmd
  autocmd!
  autocmd BufWinEnter * highlight OverLength ctermbg=black guibg=black
  autocmd BufWinEnter * call matchadd('OverLength', '\%81v')
augroup END

