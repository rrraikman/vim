# vim
Configuration files for vim

## Setup

```sh
git clone git@github.com:rrraikman/vim.git
./vim/install.sh
```

This symlinks `.vimrc` and the Neovim config into your home directory, moving any existing files aside to `.bak`, and installs the TypeScript language server and tree-sitter CLI with npm if they're missing. Neovim (0.12+) installs its plugins on first launch.
