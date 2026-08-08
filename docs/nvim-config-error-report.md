# Neovim Config Error Report

## Summary

Clicking **Config** in the dashboard opened `~/.config/nvim/init.lua`, which caused Neovim to create or read a Lua buffer. That triggered Lua filetype setup, and the built-in Lua ftplugin attempted to start Treesitter. Treesitter then failed because Neovim could not find the Lua parser on `runtimepath`.

The visible error was:

```text
Parser could not be created for buffer ... and language "lua"
```

## Root Cause

Neovim 0.11 ships bundled Treesitter parsers under:

```text
/usr/lib/nvim/parser/
```

The Lua parser existed at:

```text
/usr/lib/nvim/parser/lua.so
```

However, lazy.nvim's managed `runtimepath` did not include `/usr/lib/nvim`, so the built-in Lua ftplugin could not find `parser/lua.so` when it called:

```lua
vim.treesitter.start()
```

This only appeared when opening a Lua file. Basic startup did not trigger the failing path.

## Related Issues Fixed

The config test script also produced a misleading syntax error because it used the standalone `lua` command, which was not installed. The Lua files were not actually syntactically broken. The script now checks Lua syntax through Neovim's embedded Lua runtime.

lazy.nvim health also reported a missing `luarocks/hererocks` setup. No configured plugins require luarocks, so lazy.nvim rocks support was disabled.

`auto-session` reported outdated option names and missing `localoptions` in `sessionoptions`. The option names were updated and `localoptions` was appended.

## Fix

The lazy.nvim setup now explicitly adds `/usr/lib/nvim` back to runtimepath:

```lua
performance = {
  rtp = {
    paths = { "/usr/lib/nvim" },
  },
}
```

This makes Neovim's bundled Treesitter parsers visible before Lua filetype plugins attempt to start Treesitter.

## Test Coverage Added

The original test script did not catch this because it only checked startup, config loading, Lua syntax, and lazy bootstrap loading.

The script now includes a filetype/plugin activation phase that opens representative Lua files, including the dashboard Config target. This forces the same autocommand path that previously failed:

```text
BufRead/BufNewFile -> FileType lua -> ftplugin/lua.lua -> vim.treesitter.start()
```

That means future runtimepath or parser visibility regressions should fail the test script instead of only appearing interactively.
