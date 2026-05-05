# Autosuggestions configuration
# Requires: brew install zsh-autosuggestions

# If zsh-autosuggestions is installed, enable it
if [ -f ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    export ZSH_AUTOSUGGEST_USE_ASYNC=true
    . ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
    bindkey '^ ' autosuggest-accept
bindkey '^F' autosuggest-accept
bindkey '^E' autosuggest-accept
bindkey '\e[C' autosuggest-accept
fi
