
# Install

```bash
brew install neovim

# install vim-plug https://github.com/junegunn/vim-plug
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'


cp -r config/nvm ~/.config
```



# Needed

Multi
```
select all/next/previous match
\\A, <c-n>, <c-N>

skip current
q

insert, append, cut
i, I, a, A, c, C
```

FZF 
```
new tab
<c-t>

vertical / horizontal split
<c-v>, <c-x>

switch views
<c-ww>, left / right arrow
```

<leader>v NerdTree
<leader>f Files
<leader>b Buffers
<leader>k Text

COC

```
[g prev issue
]g next issue

Look at all commands in init.vim
```

save w/o formatting
:noa w

Fugitive

:G
git status -> 
+ sign expand
- will stage
CC will do message

Review keyboard shortcuts

Split
:vs
:hs

lookup ** in init.vim for favs
