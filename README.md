

[Reference](https://sourabhbajaj.com/mac-setup)


# New Laptop
  - MacOS Update
  - XCode Update
  - command line tools `xcode-select --install`
  - iterm
    - import profile iterm-profile.itermcolors
    - powerlevel9k(10k) theme github repo
    - be sure to insall PowerlineFonts - typically use github repo and ./install.sh
  - brew (how-to-geek how to install homebrew) + os dependencies
  - zsh as default `chsh -s /bin/zsh` or `chsh -s /usr/local/bin/zsh` for brew
  - prezto (prezto github repo)
  - vim + vim_runtime + vundle (vimrc repo) `cp config/config.vim ~/.vim_runtime`
    - install vundle (git clone repo)
    - vim_runtime/install_awesome_vimrc.sh
    - Replace config.vim and vundle.vim in my_config.vim from .vimrc
    run `sh ~/.vim_runtime/install_awesome_vimrc.sh` after coying
  - pyenv + relevant python versions 
    - configure .zshrc before to use pyenv init command
    - pip install --upgrade pip setuptools wheel
    - pip install -r config/requirements.txt
  - hicat `npm install -g hicat`
  - docker

# anscillary
  - private internet access
  - dash
  - spectacle
  - sublime
  - jetbrains ide - intellij (be sure to configure jre)
  - sdkman + java version `curl -s "https://get.sdkman.io" | bash`

# brew
  - ack
  - awscli
  - cmake
  - gcc
  - httpie
  - macvim
  - node
  - pyenv
  - wget
  - zlib

# browser
  - chrome with timco92@gmail.com
  - extensions?

# sys pref
  - energy saver
  - mouse
  - hot corners
  - dark theme
  - fastest key repeat and delay in keyboard


# Reinstall prezto after shit gets fucked up

cp ~/config/* to root

## .env.sh to root

## zsh 
zsh as default

Use two configs in this dir (both are hidden)

## vim
pip install requirements
.vim/bundle/YouCompleteMe/install.py
