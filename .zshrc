#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Powerlevel9k
plugins=(virtualenv)
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir vcs time virtualenv)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=()
POWERLEVEL9K_SHORTEN_DIR_LENGTH=1
POWERLEVEL9K_SHORTEN_STRATEGY=truncate_folders


# Customize to your needs...
source ~/config/.env.sh
source ~/config/auto-activate-virtualenv.sh

# Chalice development e.g. chal 8001
chal () {
	port=${1:-8000}
	original=$(pwd)
	cd $(dirname `find $original -type d -name ".chalice"`)
	chalice local --host 0.0.0.0 --port "$port"
	cd $original
}

# pyenv
eval "$(pyenv init -)"

#  sdkman
source "$HOME/.sdkman/bin/sdkman-init.sh"


# v
# cp config/.rupa/v/v ~/bin
# z
# cp config/.rupa/z/z.sh ~/bin
. ~/bin/z.sh

# flutter
export PATH="$PATH:$HOME/bin/flutter/bin"
# node
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

# Random
rm -fr ~/.zcompdump*
