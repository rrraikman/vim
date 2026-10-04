# vim
Configuration files for vim

## Setup

Clone the repo wherever you like, then from inside it symlink the files to where Vim and Neovim look for them:

```sh
git clone git@github.com:rrraikman/vim.git
cd vim
ln -s "$PWD/.vimrc" ~/.vimrc
mkdir -p ~/.config/nvim
ln -s "$PWD/init.lua" ~/.config/nvim/init.lua
ln -s "$PWD/nvim-pack-lock.json" ~/.config/nvim/nvim-pack-lock.json
```

`ln -s` won't overwrite a file that's already there; move any existing `~/.vimrc` or `~/.config/nvim/init.lua` aside first.

Neovim (0.12+) sources `~/.vimrc` from `init.lua` and installs its plugins on first launch.
