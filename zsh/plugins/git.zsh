# Git aliases from your existing setup

# Branch
alias gb='git branch'

# Log
alias gl='git log'
alias glp='git log --topo-order --pretty=format:"${_git_log_medium_format}"'
alias glgraph='git log --topo-order --all --graph --pretty=format:"${_git_log_oneline_format}"'
alias glstat='git log --topo-order --stat --pretty=format:"${_git_log_medium_format}"'

# Check
alias gls='git ls-files'
alias gd='git diff'
alias gg='git grep'
alias gst='git status'

# Commit
alias gaa='git add --all .'
alias gm='git commit -m'
alias gp='git push'
alias gpo='git push origin'
alias gpom='git push origin master'
alias gpod='git push origin develop'
alias grh='git reset --hard'
alias grs='git reset --soft'

# Pull
alias ggl='git pull'
alias gcl='git clone'
alias gmer='git merge'
alias gmert='git mergetool'
alias gtag='git tag'

# Docker
alias dn='docker network'
alias dc='docker-compose'
