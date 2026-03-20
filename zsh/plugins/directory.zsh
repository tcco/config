function into() {
    mkdir -p $1 || return 1
    cd $1
}

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../../'
