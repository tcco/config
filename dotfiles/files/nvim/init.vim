""" Plugins

" Auto install all desired COC extensions / language servers
let g:coc_global_extensions = ['coc-pyright', 'coc-rls', 'coc-tsserver', 'coc-html', 'coc-css', 'coc-prettier', 'coc-yaml', 'coc-markdownlint', 'coc-json', 'coc-cfn-lint']

call plug#begin()

" prevent modeline from running arbitrary code
Plug 'ciaranm/securemodelines'

" Shows list of all buffers at the top of the window
Plug 'ap/vim-buftabline'

" File navigation
Plug 'preservim/nerdtree'

" Git integration
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" Multiple cursors
Plug 'mg979/vim-visual-multi', {'branch': 'master'}

" Color styling
Plug 'chriskempson/base16-vim'

" modeline formatting
Plug 'itchyny/lightline.vim'

" highlight text when yanked
Plug 'machakann/vim-highlightedyank'

" Language specific motion to jump between matching text (e.g. parenthesis)
Plug 'andymass/vim-matchup'

" Set working directory to project root (by .git, Makefile, package.json, etc)
Plug 'airblade/vim-rooter'

" Use fuzzy finder to search for various things (files, buffers, text, colorschemes, etc)
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Code Completion / language server integration
Plug 'neoclide/coc.nvim', {'branch': 'release', 'do': { -> coc#util#install() } }

" language syntax plugins
Plug 'vim-python/python-syntax'
Plug 'leafgarland/typescript-vim'
Plug 'rust-lang/rust.vim'
Plug 'plasticboy/vim-markdown'
Plug 'stephpy/vim-yaml'
Plug 'cespare/vim-toml'

" Color boxes to preview rgb/hex/etc
Plug 'rrethy/vim-hexokinase', { 'do': 'make hexokinase' }

call plug#end()

" Install all necessary plugins on startup
autocmd VimEnter *
  \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \|   PlugInstall --sync | q
  \| endif

""" GUI

" Enable mouse usages in all modes
set mouse=a

" Remove toolbar
set guioptions-=T

" Remove beeps
set vb t_vb=

" set color scheme and enable highlighting
colorscheme base16-default-dark
syntax on
hi Normal ctermbg=NONE
set termguicolors

" Highlight the symbol at cursor and its references
autocmd CursorHold * silent call CocActionAsync('highlight')

" Omit ins-completion-menu messages (e.g. --- XXX completion (YYY), match 1 of
" 2, etc)
set shortmess+=c

" Set cursor to block in normal+visual+command mode, vertical line in insert
" mode, and horizontal (under)line in replace mode
set guicursor=n-v-c:block-Cursor/lCursor-blinkon0,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor

" Only show color preview in web files
let g:Hexokinase_ftEnabled = ['css', 'html', 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'json']

" Modeline

set noshowmode  " lightline replaces this functionality

let g:secure_modelines_allowed_items = [
                \ "textwidth",   "tw",
                \ "softtabstop", "sts",
                \ "tabstop",     "ts",
                \ "shiftwidth",  "sw",
                \ "expandtab",   "et",   "noexpandtab", "noet",
                \ "filetype",    "ft",
                \ "foldmethod",  "fdm",
                \ "readonly",    "ro",   "noreadonly", "noro",
                \ "rightleft",   "rl",   "norightleft", "norl",
                \ "colorcolumn"
                \ ]

function! LightlineFilename()
  return expand('%:t') !=# '' ? @% : '[No Name]'
endfunction

let g:lightline = {
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'cocstatus', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'filename': 'LightlineFilename',
      \   'cocstatus': 'coc#status'
      \ },
      \ }

" Update the modeline when Coc status/diagnostics change
autocmd User CocStatusChange,CocDiagnosticChange call lightline#update()


""" Editor

set encoding=utf-8

" Increase command mode height to 2
set cmdheight=2

" Store undo history between instances
set undofile
set undodir=~/.config/nvim/vimdid

" Leave paste mode when leaving insert mode
autocmd InsertLeave * set nopaste

" Jump to last edit position when opening a file
au BufReadPost * if expand('%:p') !~# '\m/\.git/' && line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" put new splits to the right/below instead of the opposite
set splitright
set splitbelow


"" Autocompletion

" Intelligently autocomplete on tab
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

" Confirm completion with enter key and break undo chain
if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<cr>"
else
  imap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<cr>"
endif


"" File level

" Load plugin and indent files by filetype
filetype plugin indent on

" Allow multiple modified files to be open (hidden buffers)
set hidden

" Don't allow folding code blocks
set nofoldenable

" Use relative line numbers (except for the current line)
set relativenumber
set number

" Wrap long lines so all content is displayed
set wrap
set formatoptions=tc " wrap text and comments using textwidth
set formatoptions+=r " continue comments when pressing ENTER in I mode
set formatoptions+=q " enable formatting of comments with gq
set formatoptions+=n " detect lists for formatting
set formatoptions+=b " auto-wrap in insert mode, and do not wrap old long lines

" Keep the cursor a couple of line from the top/bottom when scrolling
set scrolloff=2

" Show hidden characters (tab, nbsp, etc)
set list
set listchars=tab:\|\ ,nbsp:¬,extends:»,precedes:«,trail:•

" Remove ~ on 'lines' at the bottom underneath the file
set fillchars=eob:\ ,


"" Line level

" Only highlight the first 200 characters on each line (performance reasons)
set synmaxcol=200

" Only put one space after punctuation with join commands (e.g. gq, J)
set nojoinspaces

" Keep indention level when moving to a new line
set autoindent

" Use proper number of spaces when tabbing
set expandtab

" Show preview of what a command will do (e.g. substituting text)
set inccommand=nosplit

" Use 4 spaces for tabs, and 2 for web languages

set tabstop=4
set shiftwidth=4
set softtabstop=4
autocmd FileType html,css,javascript,javascriptreact,typescript,typescriptreact setlocal tabstop=2 shiftwidth=2 softtabstop=2


""" Navigation

" Allow backspace to go over indents, newlines, and delete earlier than where
" insert mode was enabled
set backspace=indent,eol,start

" Show all tab completion options for command mode
set wildmenu
set wildmode=list:longest

" Case insensitive search unless there are capitalized letters
set ignorecase
set smartcase

" Substitute all matches by default instead of just one
set gdefault


""" Languages

"" rust

let g:rustfmt_autosave = 1
let g:rustfmt_emit_files = 1
let g:rustfmt_fail_silently = 0


"" markdown

" Make sure .md files have markdown filetype
autocmd BufRead *.md set filetype=markdown

let g:vim_markdown_new_list_item_indent = 0
let g:vim_markdown_auto_insert_bullets = 0
let g:vim_markdown_frontmatter = 1


""" Misc

" Only wait 300ms to write a swap file
set updatetime=300

"" Diffing

" Ignore whitespace changes in vimdiff
set diffopt+=iwhite

" Use better diff algorithm (https://vimways.org/2018/the-power-of-diff/)
set diffopt+=algorithm:patience
set diffopt+=indent-heuristic


""" Keybindings

let mapleader = "\<Space>"

" General Editor

noremap <C-q> :confirm qall<cr>
nnoremap <leader>q :bp<cr>:bd #<cr>

" Save
nmap <leader>w :w<cr>

" Stats
nnoremap <leader>s g<c-g>

nnoremap <silent> <leader>v :NERDTreeFind<cr>

"" Navigation

" Move by display line (e.g. long line wrapped) unless a count is specified
nnoremap <expr> k v:count == 0 ? 'gk' : 'k'
nnoremap <expr> j v:count == 0 ? 'gj' : 'j'

" Git
nnoremap <leader>gs :Git<cr>
nnoremap <leader>gd :Gdiff<cr>
nnoremap <leader>gb :Git blame<cr>
nnoremap <leader>gp :Git push<cr>
" + to expand diff, - to (un)stage (or s and u), U to unstage all
" cc git commit -m , :wq to save out
" ca git commit --amend

" fzf
nnoremap <leader>f :Files<cr>
nnoremap <leader>b :Buffers<cr>
nnoremap <leader>k :Ag<cr>

" Center each search result as it is focused
nnoremap <silent> n nzz
nnoremap <silent> N Nzz
nnoremap <silent> * *zz
nnoremap <silent> # #zz
nnoremap <silent> g* g*zz

" clear search highlighting on escape
nnoremap <silent> <esc> :noh<cr><esc>

" Jump to start and end of line using the home row keys
map H ^
map L $

" copy / paste from system clipboard
noremap <leader>y "+y
noremap <leader>p "+p
noremap <leader>P "+P

" Disable arrow keys
nnoremap <up> <nop>
nnoremap <down> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>

" Left and right can switch buffers
nnoremap <left> :bp<cr>
nnoremap <right> :bn<cr>
nnoremap <down> :bw<cr>

"" Coc bindings
" :CocLocalConfig to configure locally. Look at coc-settings.json
"
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gr <Plug>(coc-references)

xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

nmap <leader>r <Plug>(coc-rename)


" Implement methods for trait
nnoremap <silent> <leader>i  :call CocActionAsync('codeAction', '', 'Implement missing members')<cr>

" Show actions available at this location
nnoremap <silent> <leader>a  :CocAction<cr>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

nnoremap <silent> K :call <SID>show_documentation()<cr>
