#!/bin/sh
# Symlinks this repo's Vim and Neovim config into $HOME and installs the
# language servers and CLI tools Neovim uses. Existing files are moved aside to
# <name>.bak; links that already point here are left alone.
set -eu

repo=$(cd "$(dirname "$0")" && pwd)

link() {
  src="$repo/$1"
  dest="$2"
  if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
    echo "ok       $dest"
    return
  fi
  mkdir -p "$(dirname "$dest")"
  if [ -e "$dest" ] || [ -L "$dest" ]; then
    mv "$dest" "$dest.bak"
    echo "backup   $dest -> $dest.bak"
  fi
  ln -s "$src" "$dest"
  echo "linked   $dest -> $src"
}

link .vimrc "$HOME/.vimrc"
link init.lua "$HOME/.config/nvim/init.lua"
link nvim-pack-lock.json "$HOME/.config/nvim/nvim-pack-lock.json"

# install_tool <manager> <command> <package>...: installs the packages with
# npm or brew unless <command> is already on PATH
install_tool() {
  manager="$1"
  cmd="$2"
  shift 2
  if command -v "$cmd" >/dev/null 2>&1; then
    echo "ok       $cmd"
  elif command -v "$manager" >/dev/null 2>&1; then
    if [ "$manager" = npm ]; then npm install -g "$@"; else brew install "$@"; fi
    echo "installed $cmd"
  else
    echo "skipped  $cmd: $manager not found, install it and rerun" >&2
  fi
}

install_tool npm typescript-language-server typescript typescript-language-server
install_tool npm bash-language-server bash-language-server
install_tool npm yaml-language-server yaml-language-server
install_tool npm vscode-json-language-server vscode-langservers-extracted
# nvim-treesitter builds its parsers with this and a C compiler
install_tool npm tree-sitter tree-sitter-cli

install_tool brew lua-language-server lua-language-server
install_tool brew shellcheck shellcheck
install_tool brew fzf fzf
install_tool brew rg ripgrep
install_tool brew fd fd
