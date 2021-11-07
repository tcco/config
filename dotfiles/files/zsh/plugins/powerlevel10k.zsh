# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# make the right prompt flush to the right of the window
ZLE_RPROMPT_INDENT=0

# don't enable powerlevel10k from main tty
if [[ $TERM != "linux" ]]; then
  source ~/.zsh/powerlevel10k/powerlevel10k.zsh-theme
fi

typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
