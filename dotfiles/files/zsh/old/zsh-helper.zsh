ZSH_HOME=~/.zsh
ZSH_CONF=~/.zshrc

function zsh-sync() {
  unalias cp || echo 'hello'

  rm -rf $ZSH_HOME/plugins
  mkdir $ZSH_HOME/plugins

  cp -r ~/config/zsh/plugins/* $ZSH_HOME/plugins/
  cp ~/config/zsh/zshrc $ZSH_CONF
  
  cp ~/config/ackrc ~/.ackrc
  cp -r ~/config/nvim ~/.config

  source ~/.zshrc
}

function const_download() {
  _dir=$ZSH_HOME/$2
  _gh=https://github.com/$1/$2.git
  echo "$1/$2"
  [ -d "$_dir" ] && git -C $_dir pull || git clone ${3:---depth=1} $_gh $_dir
}

function zsh-download() {
  # powerlevel10k
  const_download romkatv powerlevel10k
  # zsh-autosuggestions
  const_download zsh-users zsh-autosuggestions
  # zsh syntax highlighting
  const_download zdharma fast-syntax-highlighting 
}
