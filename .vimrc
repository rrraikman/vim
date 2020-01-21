" Show relative numbers
set relativenumber

" Map Ecs to jj
inoremap jj <Esc>
 
" Highlight search text
set hlsearch

" Map space to :nohl to clear search highlight
nnoremap <silent> <space> :nohl<CR>

" Incrementally search for string
set incsearch

" Map ctrl-r (redo) to r
nnoremap r <C-R>
