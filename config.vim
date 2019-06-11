" Solarized Dark
syntax enable
set background=dark
colorscheme gruvbox

" Mapping Entries
map ' :NERDTreeToggle<CR>
map " :Files<CR>

" Other
set completeopt-=preview
set nofoldenable
set rtp+=/usr/local/opt/fzf
set updatetime=100
" let g:ale_linters = {
"  'javascript': ['eslint'],
"  'python': ['flake8', 'pylint'],
" }
" let g:ale_completion_enabled = 1
let g:gitgutter_enabled=1
" let g:ale_python_flake8_use_global = 1
" let g:ale_use_global_executables = 1
" let g:ale_python_flake8_executable='python3'
" let g:ale_python_flake8_options='-m flake8'
let g:flake8_show_in_gutter=1
let g:flake8_show_in_file=0
let g:flake8_show_quickfix=1
let g:flake8_quickfix_height=3 
let g:flake8_cmd="/Users/timothyco/.pyenv/shims/flake8"
autocmd BufWritePost *.py call Flake8()
