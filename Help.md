# Vim configuration help

- `:HelpMe` opens this file in a new window.

Use `:q` to close the help window.

## Navigation
- `:SessionSearch` searches auto session instances you can easily jump around (e.g: to vimconfig).
- `<C-g>` shows the current file's path in the status area.
- `1<C-g>` shows the full absolute path.
- `:echo expand('%:p')` prints the full absolute path; use `%:h` for its directory, `%:t` for the filename.
- `:let @+ = expand('%:p')` copies the current buffer's absolute path into the system clipboard.

## Code navigation

- `gd` jumps to the definition under the cursor; `<C-o>` jumps back.
- `gr` lists all references to the symbol under the cursor.
- `]q` / `[q` step to the next/previous reference (quickfix entry) without leaving your place.
- `K` shows hover documentation for the symbol under the cursor.
- `<leader>d` collects all diagnostics into the quickfix list and opens it (step through with `]q` / `[q`).
- `grr` renames the symbol under the cursor across the project.
- `<leader>p` opens Telescope; from there pick `find_files` or `live_grep` to search files and contents.
- `:ToggleIgnore` toggles whether hidden/gitignored files show up in Telescope searches and nvim-tree. Prints whether the feature is ON or OFF. Default is OFF.
- `<C-i>` / `<C-o>` move forward/backward through your jump history.

## Code folding
Folds are tree-sitter based and start open.
- `za` toggles the fold under the cursor; 
- `zA` recursively toggle all folds under the cursor
- `zR` / `zM` open / close all folds in the file.

## Panes
- `<C-w>+` / `<C-w>-` make the current pane taller / shorter.
- `<C-w>>` / `<C-w><` make the current pane wider / narrower.

## Tabs
- `:tabnew` (or `:tabnew <file>`) opens a new tab.
- `gt` / `gT` go to the next / previous tab.
- `{n}gt` goes to tab `n` (e.g. `3gt`).
- `:tabclose` (or `:tabc`) closes the current tab.
- `:tabmove {n}` moves the current tab to position `n`.
- `:tabs` lists all tabs.
