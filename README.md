# vim
Configuration files for vim

## Setup

Needs Neovim 0.12+, Homebrew, and Node installed with nvm.

```sh
git clone git@github.com:rrraikman/vim.git
./vim/install.sh
```

This symlinks `.vimrc` and the Neovim config into your home directory, moving any existing files aside to `.bak`, and installs any missing tools. The language servers that run on Node (TypeScript, Bash, YAML, JSON) install with npm under the Node version nvm has active, and the native ones (Lua's language server, `tsc`, tree-sitter, fzf, ripgrep, fd, shellcheck) with Homebrew. Neovim (0.12+) installs its plugins on first launch.

See [TIPS.md](TIPS.md) for the key mappings and tricks this setup adds.
