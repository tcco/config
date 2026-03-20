# Aliases

# Editor
export EDITOR=nvim
export VISUAL=nvim

# Export
export PATH=$PATH:$HOME/bin
export PIP_FORMAT=columns
export PYTHONDONTWRITEBYTECODE=1

# Vim/Neovim
alias vim="nvim"
alias mvim="/opt/homebrew/bin/mvim"

# General
alias lock="/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend"
alias geoip="curl http://ip-api.com/json/"
alias cat="bat"
alias sleep="pmset sleepnow"
alias pycache="find . | grep -E \"(__pycache__|\.pyc|\.pytest_cache|\.pyo$)\" | xargs rm -rf"

# Builtin
alias ls='ls -G'
alias l='ls -Gla'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Modern ls replacements (eza)
alias ll='eza -lah'
alias la='eza -a'
alias lt='eza --tree'

# Fuzzy finder
alias f='fzf'
alias fh='history | fzf'

# Git shortcuts (modern)
alias g='git'
alias gs='git status'
alias ga='git add'
alias gc='git commit -m'
alias gca='git commit -am'
alias gpl='git pull'
alias gco='git checkout'
alias gcb='git checkout -b'
alias glog='git log --oneline --graph --decorate'
alias gdiff='git diff | delta'
alias gundo='git reset --soft HEAD~1'

# Utilities
alias cl='clear && printf "\e[3J"'
alias duh='du -sh * | sort -h'
alias findbig='du -ah . | sort -rh | head -n 20'
alias path='echo -e ${PATH//:/\\n}'
alias ip='curl ifconfig.me'
alias now='date +"%T"'
alias nowdate='date +"%d-%m-%Y"'
alias ports='lsof -i -P -n | grep LISTEN'

# Help/docs
alias help='tldr'
alias man='tldr'

# Dotfiles helpers
alias ez='${EDITOR:-nvim} ~/.zshrc'
alias sz='source ~/.zshrc'

# Zoxide integration
alias j='z'
