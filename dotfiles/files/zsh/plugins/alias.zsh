# Export
export EDITOR=nvim
export PATH=$PATH:$HOME/bin
export PIP_FORMAT=columns
export PYTHONDONTWRITEBYTECODE=1
export PYTHON_CONFIGURE_OPTS="--enable-framework"

# Alias

## General
alias lock="/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend"
alias geoip="curl http://ip-api.com/json/"
# alias vim="mvim -v"
alias vim="nvim"

alias cat="hicat"
alias sleep="pmset sleepnow"
alias pycache="find . | grep -E \"(__pycache__|\.pyc|\.pytest_cache|\.pyo$)\" | xargs rm -rf"

# builtin 
alias ls='ls -G'
alias l='ls -Gla'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

## Git
### branch
alias gb='git branch'
### Log
alias gl='git log'
alias glp='git log --topo-order --pretty=format:"${_git_log_medium_format}"'
alias glgraph='git log --topo-order --all --graph --pretty=format:"${_git_log_oneline_format}"'
alias glstat='git log --topo-order --stat --pretty=format:"${_git_log_medium_format}"'
### Check
alias gls='git ls-files'
alias gd='git diff'
alias gg='git grep'
alias gst='git status'
### Commit
alias gaa='git add --all .'
alias gm='git commit -m'
alias gp='git push'
alias gpo='git push origin'
alias gpom='git push origin master'
alias gpod='git push origin develop'
alias grh='git reset --hard'
alias grs='git reset --soft'
### Pull
alias ggl='git pull'
alias gcl='git clone'
alias gmer='git merge'
alias gmert='git mergetool'
alias gtag='git tag'

## Docker

### Containers
alias drun='docker run'
alias drunrm='docker run --rm'
alias drm='docker rm'
alias dexec='docker exec -ti'
alias dlogs='docker logs'
alias dps='docker ps'
alias dpsa='docker ps -a'
alias demptyc='docker rm `docker ps -qa`'
alias demptycf='docker rm -f `docker ps -qa`'
alias dinspect=' docker inspect'

### Images
alias dbuild='docker build'
alias dimages='docker images'
alias drmi='docker rmi'
alias demptyi='docker rmi $(docker images -q --filter "dangling=true")'
alias demptyif='docker rmi -f $(docker images -q --filter "dangling=true")'
alias dcleari='docker rmi $(docker images -a -q)'

### Clear
alias dclear='demptyc && demptyi'

### Network
alias dip="docker inspect -f '{{ .NetworkSettings.IPAddress }}'"

### Volumes
alias dv='docker volume'
alias dvls='docker volume ls'
alias dvinspect=' docker inspect -f {{.Volumes}}'
alias dvrm='docker volume rm $(docker volume ls |awk "{print $2}")'
alias demptyv='docker volume rm `docker volume ls -q -f dangling=true`'

### docker-addons
alias dn='docker network'
alias dc='docker-compose'
