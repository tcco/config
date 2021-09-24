# Laptop setup

[Read this if anything else](https://sourabhbajaj.com/mac-setup)

## New Laptop

- MacOS Update
- XCode Update
- command line tools `xcode-select --install`
- iterm
  - import profile iterm-profile.itermcolors
  - powerlevel9k(10k) theme github repo
  - be sure to insall PowerlineFonts - typically use github repo and ./install.sh
- brew (how-to-geek how to install homebrew) + os dependencies
  - `$(brew --prefix)/opt/fzf/install` for fzf

## python

pyenv + relevant python versions

- configure .zshrc before to use pyenv init command
- pip install --upgrade pip setuptools wheel
- pip install -r config/requirements.txt

## GH

```zsh
git config --global user.name "Tim Co"
git config --global user.email "timco92@gmail.com"
git config --global credential.helper osxkeychain

git clone https://github.com/tcco/config ~

cp ~/config/.gitignore ~/.gitignore
```

## zsh

- zsh as default `chsh -s /bin/zsh` or `chsh -s /usr/local/bin/zsh` for brew

|Conf|Resource|Notes
|aliases|[env.sh](zsh/modules/alias.zsh)|shortcuts built up over time|
|theme|[powerlevel10k](https://github.com/romkatv/powerlevel10k)|pretty|

```zsh
# First time
cp zsh/zshrc ~/.zshrc
mkdir ~/.zsh/plugins
cp -r zsh/plugins/* ~/.zsh/plugins
source ~/.zshrc

zsh-download

# after adding plugins & changing config
zsh-sync
```

### search

#### fzf

See `https://github.com/junegunn/fzf#fuzzy-completion-for-bash-and-zsh` for usage

`<command e.g. vim, cd, unset> **` for tab completion

`ctl t` for default command

#### ack

```zsh
cp ackrc ~
```

## vim

See [nvim.md](nvim/neovim.md) for neovim installation + helpers

### Vim Tips for Mappings from plugins

:nmap
:nunmap

## node/npm

``` zsh
npm install (npm-requirements.txt)
```

## bin

``` zsh
cp -r bin ~
```

## anscillary

- discord
- dash
- sdkman + java version `curl -s "https://get.sdkman.io" | bash`

### Sublime

[sublime-reqs](./sublime-requirements.txt)
[medium resource](https://medium.com/@adrianmcli/setting-up-sublime-text-3-for-reactjs-3bf6baceb73a)

symlink subl

```bash
ln -s "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" ~/bin/subl
```

### Bar

- itsycal
- mia for gmail
- spectacle
- docker
- istat menu
- private internet access

### sys pref

- energy saver
- mouse
- hot corners
- dark theme
- fastest key repeat and delay in keyboard
- CAPS LOCK as esc for every keyboard
