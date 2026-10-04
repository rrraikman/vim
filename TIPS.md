# Tips and tricks

`Space` is the leader key. Mappings marked *built-in* come with Neovim; the rest are set in `init.lua`.

## Getting around files

| Key | Action |
|---|---|
| `Ctrl-p` / `Space f` | Find a file by name |
| `Space /` | Search text across the project (ripgrep) |
| `Space r` | Recently opened files |
| `Space s` | Symbols (functions, classes) in the current file |
| `Space e` | Go to the file tree (opening it if needed); from the tree, back to the file |
| `Space E` | Show / hide the file tree without leaving the file |
| `Space g` | Files changed in git |
| `Space b` | Open buffers |
| `Ctrl-o` / `Ctrl-i` | Jump back / forward, across files too (*built-in*) |
| `Ctrl-c` in normal mode | Quit Neovim, asking to save any unsaved files or stop a running terminal first |

`nvim .` opens the tree on the left with an empty editor beside it.

### Fuzzy finder

Letters just need to appear in order: `clueks` finds `cluster-eks.ts`. Space-separated words match in any order (`eks cattle`). In file pickers, `'word` matches exactly, `^pack` anchors the start, `.ts$` the end, and `!test` excludes.

| Key in the picker | Action |
|---|---|
| `Enter` | Open |
| `Ctrl-v` / `Ctrl-s` | Open in a vertical / horizontal split |
| `Shift-↓` / `Shift-↑` | Scroll the preview |
| `F4` | Toggle the preview |
| `Alt-h` / `Alt-i` | Include hidden / git-ignored files |
| `Alt-q` | Send results to the quickfix list, then step through with `]q` / `[q` |
| `F1` | All keys |

`Alt` needs Option set to send Alt/Esc+ in your terminal's settings.

Open pickers from the editor side, not with the cursor in the tree: the file opens in whichever window you're in.

### File tree

Like VS Code, git-ignored files and folders (`node_modules`, `cdk.out`) are shown in grey rather than hidden.

| Key | Action |
|---|---|
| `Enter` | Open file / expand folder |
| `a` / `A` | New file (end with `/` for a folder) / new folder |
| `r` / `d` | Rename / delete |
| `c` / `m` | Copy / move to a path you type |
| `y` `x` `p` | Copy / cut / paste, for moving several files |
| `s` / `S` | Open in a vertical / horizontal split |
| `P` | Preview without opening |
| `H` | Show hidden items (only `.git`, `.DS_Store` and `thumbs.db` are hidden) |
| `/` | Filter the tree |
| `.` / `Backspace` | Make the folder under the cursor the root / go up |
| `[g` / `]g` | Previous / next git-modified file |
| `<` / `>` | Switch between files, buffers and git views |
| `Esc` | Back to the editor window you came from, leaving the tree open |
| `q` | Close the tree |
| `?` | All keys |

## Tabs

Each open file gets a tab. Click to switch, or `]b` / `[b` (*built-in*).

| Command | Action |
|---|---|
| `:q`, `Space x` or the tab's `×` | Close the current file; the editor window stays. Refuses if there are unsaved changes |
| `:q!` | Close the file, discarding unsaved changes |
| `:wq` | Save, then close the file |
| `:q` with nothing open | Quit Neovim |
| `:qa` / `Ctrl-c` | Quit Neovim from anywhere |

In a split, the tree or the floating terminal, `:q` closes that window as usual. Don't use `:bd`: with the tree open it closes the editor window, and then Neovim quits.

A `:terminal` gets a tab too; closing it ends the shell.

## Git

Changed lines are marked in the left margin: green bar added, blue changed, red triangle deleted.

| Key | Action |
|---|---|
| `]c` / `[c` | Next / previous change |
| `Space h p` | Preview the change under the cursor |
| `Space h s` | Stage just that change |
| `Space h r` | Reset (discard) just that change |
| `Space h b` | Blame for the current line, with the full commit message |
| `Space h B` | Toggle blame shown inline at the end of every line |

## Terminal

| Key | Action |
|---|---|
| `Space \` | Open the floating terminal; it reopens the same shell, history and running commands intact |
| `Esc` or `Ctrl-\` `Ctrl-\` (inside it) | Hide it |
| `Ctrl-\` `Esc` (inside it) | Send a real `Esc` to the program in the shell (vim, `claude`, zsh vi mode) |
| `Ctrl-\` `Ctrl-n` (inside it) | Normal mode, to scroll and copy output (*built-in*); `Esc` from there hides it |

`exit` closes the shell; the next `Space \` starts a fresh one. For a terminal in a split instead, `:botright 15split | terminal` opens a panel along the bottom.

## Code intelligence

Works in TypeScript/JavaScript, shell, YAML, JSON and Lua.

| Key | Action | VS Code |
|---|---|---|
| `gd` | Go to definition | F12 |
| `K` | Hover docs and type (*built-in*) | hover |
| `grr` | References (*built-in*) | Shift+F12 |
| `gri` | Implementations (*built-in*) | Ctrl+F12 |
| `grn` | Rename symbol (*built-in*) | F2 |
| `gra` | Code actions, e.g. add missing import (*built-in*) | Ctrl+. |
| `]d` / `[d` | Next / previous error or warning (*built-in*) | F8 |
| `Ctrl-w d` | Show the full message for the error under the cursor (*built-in*) | hover |

When `gd` finds more than one place (a class and its constructor, say), it jumps to the first; `:cnext` goes to the next.

`:checkhealth vim.lsp` shows which language servers are attached to the current file.

### Completion

Suggestions pop up as you type, with docs beside them and parameter hints inside a call.

| Key | Action |
|---|---|
| `Enter` | Accept |
| `↓` `↑` / `Ctrl-n` `Ctrl-p` | Move through suggestions |
| `Ctrl-Space` | Open the menu by hand |
| `Ctrl-e` | Dismiss |

## Editing

| Key | Action |
|---|---|
| `gcc` / `gc` in visual mode | Toggle comment on a line / selection (*built-in*) |
| `u` / `r` | Undo / redo (`r` is remapped from replace-char in `.vimrc`) |
| `*` | Search for the word under the cursor (*built-in*) |
| `:noh` | Clear search highlighting (*built-in*) |
| `ciw` / `ci"` / `ci(` | Change the word / inside quotes / inside parens (*built-in*) |
| `.` | Repeat the last change (*built-in*) |

`y` and `p` use the macOS clipboard, so you can copy between Neovim and other apps. Undo history is saved per file, so `u` still works after closing and reopening one.

## Maintenance

- `:lua vim.pack.update()` updates plugins. Commit the changed `nvim-pack-lock.json` so other machines get the same versions.
- `./install.sh` is safe to rerun. It relinks the config and installs any missing language servers or tools.
- Tree-sitter parsers build in the background on a new machine's first launch, so that session uses plain highlighting until they're done.
- `./install.sh` installs tools with Homebrew, falling back to npm only when Homebrew isn't there. Anything that did come from npm is tied to the Node version nvm had active; after switching your default Node, rerun `./install.sh`.
