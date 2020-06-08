# Export

export PATH=$PATH:$HOME/bin
export PIP_FORMAT=columns
export PYTHONDONTWRITEBYTECODE=1
export PYTHON_CONFIGURE_OPTS="--enable-framework"
### Tokens
# TODO after cp to ~ directory
# Alias

# Work Specific
alias idea='open -a "`ls -dt /Applications/IntelliJ\ IDEA*|head -1`"'
## General
alias lock="/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend"
alias geoip="curl http://ip-api.com/json/"
alias vim="mvim -v"
# alias pip="pip2"
# alias python="python2"
alias setup-pre-commit="cd .git/hooks/ && ln -s ../../bin/pre-commit . && cd ../../"
alias createvenv="python -m venv .venv"  # python3
alias createvirtualenv="python -m virtualenv .venv"  # python2
alias venv=". .venv/bin/activate"
alias senv="source .env"
alias zetc="source etc/devenv.zsh"
alias setc="source etc/devenv.sh"
alias cat="hicat"
alias sleep="pmset sleepnow"
alias pycache="find . | grep -E \"(__pycache__|\.pyc|\.pytest_cache|\.pyo$)\" | xargs rm -rf"

## Git
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
