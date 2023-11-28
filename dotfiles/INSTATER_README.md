See https://github.com/nayaverdier/instater

## Get going

From `dotfiles` folder path

```
instater  --dry-run
instater
instater --tags dev,rust
instater --vars 'python_install=true; brew_install=true; javascript_install=true'
```

## Available

- command line tools
- brew (+installed requirements)
- pyenv for python
- sdkman for java based

- config for zsh, git, ack
- basic requirements for python, java, javascript


## New Computer setup
*after xcode select and iterm installed*

```
git repo clone https://github.com/tcco/config ~
cd config


brew install pyenv
pyeven install <latest python>
pip install instater


instater --tags system --vars 'brew_install=true'
instater --tags dev,git,python,javascript --vars 'python_install=true; javascript_install=true'


instater --tags dev,java,rust,terraform

instater --tags term,zsh,ack,nvim --vars 'zsh_install=true'
```
