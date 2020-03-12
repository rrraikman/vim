" Show relative numbers
set number relativenumber
 
" Highlight search text
set hlsearch

" Map space to :nohl to clear search highlight
nnoremap <silent> <space> :nohl<CR>

" Incrementally search for string
set incsearch

" Map ctrl-r (redo) to r
nnoremap r <C-R>

" Enable syntax highlighting
syntax on

" Show status bar with full file path
set laststatus=2
set statusline+=%F
