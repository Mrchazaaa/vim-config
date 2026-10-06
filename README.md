# vimconfig

[![Test Neovim Configuration](https://github.com/Mrchazaaa/vimconfig/actions/workflows/nvim-config-test.yml/badge.svg)](https://github.com/Mrchazaaa/vimconfig/actions/workflows/nvim-config-test.yml)
[![Test Install Script](https://github.com/Mrchazaaa/vimconfig/actions/workflows/install-script-test.yml/badge.svg)](https://github.com/Mrchazaaa/vimconfig/actions/workflows/install-script-test.yml)
[![Test Install Script With Preinstalled Editors](https://github.com/Mrchazaaa/vimconfig/actions/workflows/install-script-preinstalled-editors-test.yml/badge.svg)](https://github.com/Mrchazaaa/vimconfig/actions/workflows/install-script-preinstalled-editors-test.yml)

Personal Vim, Neovim, and IdeaVim configuration.

## Install

With Neovim and npm already installed, install only the Neovim config with:

```bash
curl -fsSL https://raw.githubusercontent.com/Mrchazaaa/vimconfig/master/install.sh | bash -s -- --nvim
```

From a local checkout:

```bash
./install.sh --nvim
```

Use `--vim`, `--ideavim`, or `--all` for other targets. With no target flag,
the installer installs the Vim and Neovim shims.

This clones (or updates) the repository at `~/.config/nvim/vim-config`
(override with `VIMCONFIG_INSTALL_DIR`). The shims are written to `~/.config/nvim/init.vim` (Neovim), `~/.vimrc` (Vim),
and `~/.ideavimrc` (IdeaVim), each loading the configuration from the checkout.

### Windows

From a PowerShell session in a local checkout, install the Neovim shim into
the standard Windows config directory:

```powershell
.\install.ps1
```

This writes `%LOCALAPPDATA%\nvim\init.vim` and loads the configuration from
that checkout. Neovim and npm must already be available on `PATH`.

## Launch profiles

### Minimal profile

#### Linux 

```bash
nvim -u `~/.config/nvim/vim-config/minimal.lua`
```
#### Windows 

```powershell
nvim -u "%LOCALAPPDATA%\nvim\minimal.lua"
```
