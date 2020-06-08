

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
    - install vundle [git clone vimrc repo](https://github.com/amix/vimrc)
    - Replace config.vim and vundle.vim in my_config.vim from .vimrc
    - run `sh ~/.vim_runtime/install_awesome_vimrc.sh` after coying
    - run vim > :PluginInstall
  - pyenv + relevant python versions 
    - configure .zshrc before to use pyenv init command
    - pip install --upgrade pip setuptools wheel
    - pip install -r config/requirements.txt
  - docker


# node/npm
npm install (npm-requirements.txt)

## bin
Copy `bin` to `~`

# anscillary
  - istat menu
  - private internet access
  - dash
  - spectacle
  - miaforgmail
  - itsycal
  - sublime
    - symlink subl `ln -s "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" ~/bin/subl`
    - Install all packages, some may need additional download
    - Color Highlighter, GitGutter, SublimeLinter, SublimeLinter-flake8, JavaScriptEnhancements
    - See https://medium.com/@adrianmcli/setting-up-sublime-text-3-for-reactjs-3bf6baceb73a
  - sdkman + java version `curl -s "https://get.sdkman.io" | bash`

## Pycharm

jetbrains ide - pycharm or intellij (be sure to configure jre)

Plugins:
- BashSupport
- CodeGlance
- Copy and Browse Github
- Ideavim
- MaterialUI Theme
- mypy
- prettier
- toml
- wrap to column

## UML
brew install `plantuml fswatch`

## flutter
Read [getting started](https://flutter.dev/docs/get-started/install/macos)

# browser
  - chrome with timco92@gmail.com
  - toby tab manager
  - extensions?
  - [web search navigator](https://chrome.google.com/webstore/detail/web-search-navigator/cohamjploocgoejdfanacfgkhjkhdkek)
  - [google results previewer](https://chrome.google.com/webstore/detail/google-results-previewer/mkmjdljkedjpedbceoaaghdmcnipdcjf)

# Bar
  - itsycal
  - mia for gmail
  - spectacle
  - docker

# sys pref
  - energy saver
  - mouse
  - hot corners
  - dark theme
  - fastest key repeat and delay in keyboard
  - CAPS LOCK as esc for every keyboard


# Git
git config --global user.name "Tim Co"
git config --global user.email "timco92@gmail.com"
git config --global credential.helper osxkeychain


# Reinstall prezto after shit gets fucked up

cp ~/config/* to root

## .env.sh to root

## zsh 
zsh as default

Use two configs in this dir (both are hidden)

## vim
pip install requirements
.vim/bundle/YouCompleteMe/install.py

### Vim Tips for Mappings from plugins
:nmap
:nunmap
