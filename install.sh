#!/bin/sh
# Symlinks this repo's Vim and Neovim config into $HOME. Existing files are
# moved aside to <name>.bak; links that already point here are left alone.
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
