 #!/bin/bash
DOT_FILES=(.zsh .bash_profile …)

## neovim

for file in ${DOT_FILES[@]}
do
   ln -s $HOME/dotfiles/$file $HOME/$file
done
