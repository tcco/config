set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'airblade/vim-gitgutter'
Plugin 'scrooloose/nerdtree'
Plugin 'w0rp/ale'
Plugin 'Valloric/YouCompleteMe'
Plugin 'leshill/vim-json'
Plugin 'morhetz/gruvbox'
Plugin 'nvie/vim-flake8'
Plugin 'junegunn/fzf'
Plugin 'junegunn/fzf.vim'
Plugin 'ambv/black'

" Plugin 'tpope/vim-eunuch'
" Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" Plugin 'pangloss/vim-javascript'
" Plugin 'mattn/emmet-vim'
" Plugin 'mxw/vim-jsx'
" Plugin 'ap/vim-css-color'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line
