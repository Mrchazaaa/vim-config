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
- `<leader>dd` collects all diagnostics into the quickfix list and opens it (step through with `]q` / `[q`).
- `grr` renames the symbol under the cursor across the project.
- `<leader>ca` opens available code actions (works in visual mode for range-specific actions). The list appears in a small Telescope window anchored at the cursor.
- `<leader>p` opens Telescope; from there pick `find_files` or `live_grep` to search files and contents.
- `:ToggleIgnore` toggles whether hidden/gitignored files show up in Telescope searches and nvim-tree. Prints whether the feature is ON or OFF. Default is OFF.
- `<C-i>` / `<C-o>` move forward/backward through your jump history.

### Peeking with Telescope (`<leader>l`)
Same LSP queries as `gd` / `gr`, but in a Telescope picker with a preview pane — you
see the code without leaving the buffer, and `<Esc>` backs out with your cursor untouched.
Only bound while a language server is attached.

- `<leader>ld` — definitions of the symbol under the cursor.
- `<leader>lr` — references to it.
- `<leader>li` — implementations (interfaces, abstract methods).
- `<leader>lt` — type definition.
- `<leader>ls` — symbols in the current file.
- `<leader>lw` — symbols across the workspace (fuzzy, queries the server as you type).
- `<leader>lc` / `<leader>lo` — incoming / outgoing calls (who calls this, what this calls).

In the picker: `<C-n>`/`<C-p>` move, `<CR>` jumps, `<C-x>`/`<C-v>`/`<C-t>` open in a split/vsplit/tab.

## Completion and code actions
- Completion (nvim-cmp) pops up automatically while typing. `<Tab>` / `<S-Tab>` cycle the menu, `<CR>` accepts the selection.
- Sources are global, so every filetype gets them: LSP, buffer words, file paths, and snippets. A filetype with no language server attached still gets buffer/path/snippet completion, which is plain text matching rather than language-aware suggestions.
- `<F4>` runs the code action under the cursor (quick fixes, auto-imports, generated stubs). Requires an attached language server; filetypes without one return nothing.
- `<F2>` renames the symbol under the cursor; `<F3>` formats the buffer (or the selection, in visual mode).
- `:Format` formats via conform.nvim, falling back to the language server when no formatter is configured for the filetype. Formatters are registered per-filetype, so a filetype that's absent from that list is left untouched.

## LSP status
- `:LspInfo` (alias for `:checkhealth vim.lsp`) shows which language servers are attached to the current buffer, plus their root dir and settings.
- `:lua =vim.tbl_map(function(c) return c.name end, vim.lsp.get_clients())` lists just the names of the clients running right now.
- `:Mason` shows which servers are installed (`i` installs, `X` uninstalls); a server can be installed but not attached if the filetype doesn't match.

## Code folding
Folds are tree-sitter based and start open.
- `za` toggles the fold under the cursor; 
- `zA` recursively toggle all folds under the cursor
- `zR` / `zM` open / close all folds in the file.
- `:set foldlevel=...` controls which fold levels are open; use the cursor's `foldlevel('.')` to keep its level visible while closing sibling folds.

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
- `<C-w>T` moves the current window (buffer) into a new tab.
- `:tab split` opens the current buffer in a new tab, keeping the original window.

## Find and Replace
- `/pattern` or `?pattern` — search forward/backward; `n`/`N` next/previous match.
- `Esc` clears search highlights.
- `:%s/old/new/g` — replace all in current file.
- `:%s/old/new/gc` — confirm each replacement.
- `:'<,'>s/old/new/g` — replace all in visual selection.
- Search is case-insensitive by default; uppercase in pattern forces exact case.

### Project-wide replace
- `:Rg pattern` — find all matches across project (fills quickfix list).
- `:cfdo %s/pattern/replacement/g | update` — replace in every file, save.
- `:cfdo %s/pattern/replacement/gc | update` — confirm each replacement.
- `:SearchAndReplace` — prompts for pattern and replacement, replaces across project.
- `:SearchAndReplaceConfirm` — same but confirms each replacement.

## Git review
- `:DiffviewFileHistory` — opens the repository commit history, newest first.
- In the history panel, `<CR>`, `o`, or double-click opens the selected commit in Diffview.
- `<C-A-d>` also opens the selected commit in Diffview.
- `:DiffviewFileHistory %` — shows history for only the current file.

## Quickfix
- `<leader>q` toggles the quickfix panel.
