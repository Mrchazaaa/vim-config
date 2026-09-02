# Vim configuration help

- `:VimConfig` opens Neovim's system configuration directory in a new tab.
- `:HelpMe` opens this file in a new window.

Use `:q` to close the help window.

## Code navigation

- `gd` jumps to the definition under the cursor; `<C-o>` jumps back.
- `gr` lists all references to the symbol under the cursor.
- `K` shows hover documentation for the symbol under the cursor.
- `grr` renames the symbol under the cursor across the project.
- `<leader>p` opens Telescope; from there pick `find_files` or `live_grep` to search files and contents.
- `<C-i>` / `<C-o>` move forward/backward through your jump history.
