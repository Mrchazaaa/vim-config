# Vim configuration help

- `:HelpMe` opens this file in a new window.

Use `:q` to close the help window.

## Navigation
- `:SessionSearch` searches auto session instances you can easily jump around (e.g: to vimconfig).
- `<C-g>` shows the current file's path in the status area.
- `1<C-g>` shows the full absolute path.
- `:echo expand('%:p')` prints the full absolute path; use `%:h` for its directory, `%:t` for the filename.

## Code navigation

- `gd` jumps to the definition under the cursor; `<C-o>` jumps back.
- `gr` lists all references to the symbol under the cursor.
- `K` shows hover documentation for the symbol under the cursor.
- `grr` renames the symbol under the cursor across the project.
- `<leader>p` opens Telescope; from there pick `find_files` or `live_grep` to search files and contents.
- `<C-i>` / `<C-o>` move forward/backward through your jump history.

