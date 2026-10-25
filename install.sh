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

# npm_tool <command> <package...>: installs a tool that runs on Node with npm, under
# the Node version nvm has active, unless <command> is already on PATH.
npm_tool() {
  cmd="$1"
  shift
  if command -v "$cmd" >/dev/null 2>&1; then
    echo "ok       $cmd"
  elif command -v npm >/dev/null 2>&1; then
    npm install -g "$@"
    echo "installed $cmd (npm)"
  else
    echo "skipped  $cmd: install Node with nvm and rerun" >&2
  fi
}

# brew_tool <command> <formula>: installs a native tool with Homebrew, unless
# <command> is already on PATH.
brew_tool() {
  cmd="$1"
  formula="$2"
  if command -v "$cmd" >/dev/null 2>&1; then
    echo "ok       $cmd"
  elif command -v brew >/dev/null 2>&1; then
    brew install "$formula"
    echo "installed $cmd (brew)"
  else
    echo "skipped  $cmd: install Homebrew and rerun" >&2
  fi
}

npm_tool typescript-language-server typescript-language-server
npm_tool bash-language-server bash-language-server
npm_tool yaml-language-server yaml-language-server
npm_tool vscode-json-language-server vscode-langservers-extracted
# TypeScript 7's tsc is a native binary, served to Neovim with `tsc --lsp`
brew_tool tsc typescript
# nvim-treesitter builds its parsers with this and a C compiler
brew_tool tree-sitter tree-sitter-cli
brew_tool lua-language-server lua-language-server
brew_tool shellcheck shellcheck
brew_tool fzf fzf
brew_tool rg ripgrep
brew_tool fd fd
