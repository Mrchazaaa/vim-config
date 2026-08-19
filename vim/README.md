# Setup

From the repo root, run:

```bash
./install.sh --vim
```

Or run the Vim-only installer directly:

```bash
./vim/install.sh
```

This writes `~/.vimrc` as a shim that sources the shared Vim config and
`vim/VimSpecific.vim`.

## Updating from Vim or Neovim

Use `:ConfigUpdate` to fast-forward the checkout and refresh the shim for the
editor you are currently using. Git determines whether local changes allow the
fast-forward; after a successful update the command asks you to restart. It
requires `git` to be available on `PATH` (and `npm` when updating from
Neovim).
