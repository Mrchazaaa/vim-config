# Setup

From the repo root, run:

```bash
./install.sh --nvim
```

Or run the Neovim-only installer directly:

```bash
./nvim/install.sh
```

This writes `~/.config/nvim/init.vim` as a shim that sources the shared Vim
config and loads `nvim/init.lua`.

## Updating from Neovim

Use `:ConfigUpdate` to fast-forward the checkout, then refresh the Neovim
shim. The shared Vimscript command lets Git determine whether local changes
allow the fast-forward, and asks you to restart Neovim after a successful
update. It requires `git` and `npm` to be available on `PATH`, just like the
installer.
