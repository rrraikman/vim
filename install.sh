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

# install_tool <command> <brew formula> [npm package...]: installs with Homebrew,
# or with npm when Homebrew isn't available, unless <command> is already on PATH.
# Homebrew comes first so the language servers don't depend on the Node version
# nvm has active.
install_tool() {
  cmd="$1"
  formula="$2"
  shift 2
  if command -v "$cmd" >/dev/null 2>&1; then
    echo "ok       $cmd"
  elif command -v brew >/dev/null 2>&1; then
    brew install "$formula"
    echo "installed $cmd (brew)"
  elif [ $# -gt 0 ] && command -v npm >/dev/null 2>&1; then
    npm install -g "$@"
    echo "installed $cmd (npm)"
  elif [ $# -gt 0 ]; then
    echo "skipped  $cmd: install Homebrew or npm and rerun" >&2
  else
    echo "skipped  $cmd: install Homebrew and rerun" >&2
  fi
}

install_tool typescript-language-server typescript-language-server typescript typescript-language-server
install_tool bash-language-server bash-language-server bash-language-server
install_tool yaml-language-server yaml-language-server yaml-language-server
install_tool vscode-json-language-server vscode-langservers-extracted vscode-langservers-extracted
# nvim-treesitter builds its parsers with this and a C compiler
install_tool tree-sitter tree-sitter-cli tree-sitter-cli
install_tool lua-language-server lua-language-server
install_tool shellcheck shellcheck
install_tool fzf fzf
install_tool rg ripgrep
install_tool fd fd
