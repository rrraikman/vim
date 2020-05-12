" Relative numbers for normal mode, normal numbers for insert
set number relativenumber
autocmd InsertEnter * :set norelativenumber
autocmd InsertLeave * :set relativenumber
 
" Highlight search text
set hlsearch

" Incrementally search for string
set incsearch

" Map ctrl-r (redo) to r
nnoremap r <C-R>

" Enable syntax highlighting
syntax on

" Show status bar with full file path
set laststatus=2
set statusline+=%F
