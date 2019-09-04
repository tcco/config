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

# pyenv
eval "$(pyenv init -)"

#  sdkman
source "$HOME/.sdkman/bin/sdkman-init.sh"

# v
# cp config/.rupa/v/v ~/bin
# z
# cp config/.rupa/z/z.sh ~/bin
. ~/bin/z.sh

# added by travis gem
[ -f /Users/timothyco/.travis/travis.sh ] && source /Users/timothyco/.travis/travis.sh

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

# Random
rm -fr ~/.zcompdump*
