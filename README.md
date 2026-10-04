# vim
Configuration files for vim

## Setup

```sh
git clone git@github.com:rrraikman/vim.git
./vim/install.sh
```

This symlinks `.vimrc` and the Neovim config into your home directory, moving any existing files aside to `.bak`, and installs any missing language servers (TypeScript, Bash, YAML, JSON, Lua) and tools (tree-sitter, fzf, ripgrep, fd, shellcheck) with Homebrew, or npm for the language servers where Homebrew isn't available. Neovim (0.12+) installs its plugins on first launch.

See [TIPS.md](TIPS.md) for the key mappings and tricks this setup adds.
