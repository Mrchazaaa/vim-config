# Vim configuration help

- `:HelpMe` opens this file in a new window.

Use `:q` to close the help window.

## Profiles

Neovim's installed `init.vim` loads only `nvim/init.lua`. Profiles choose their
Vimscript dependencies: `profiles/common.lua` loads shared navigation, while
`profiles/coding.lua` also loads the legacy settings in `vim/CoreConfig/Main.vim`.
Hemingway uses the shared setup and its own writing settings.

### Coding (default)

For software development.

```bash
nvim
```

### Hemingway

For writing prose.

```bash
NVIM_APPNAME=nvim/vim-config/profiles/hemingway nvim
```

#### Spelling and prose checking

- Available in both coding and Hemingway profiles when Harper attaches to Markdown/plain text.
- Harper checks British English spelling, grammar, and style locally in Markdown and plain-text buffers.
- `<leader>ca` shows available prose corrections at the cursor.
- `:DiagnosticsList` opens a navigable list of diagnostics for the current buffer (available in all buffers).
- Built-in spellcheck is disabled. Words previously accepted with `zg` do not
  automatically carry over to Harper's dictionary. `:LspInfo` shows whether Harper is attached.
- `K` shows the issue at the text cursor. Hemingway also shows it after a half-second
  pause in Normal mode; coding displays inline diagnostics instead.

### LSP configuration layout

- `profiles/coding.lua` selects the `coding` and `writing` server groups with inline diagnostics.
- `profiles/hemingway/init.lua` selects the `writing` group with cursor-idle popups.
- `nvim/lua/plugins/lsp.lua` declares the shared LSP/Mason dependencies.
- `nvim/lua/lsp/setup.lua` configures the selected servers and runs Mason setup once.
- `nvim/lua/lsp/servers/init.lua` defines server groups; neighbouring modules hold
  Lua and TypeScript overrides. Harper's configuration belongs to the writing feature.
- `nvim/lua/lsp/keymaps.lua` owns coding mappings.
- `nvim/lua/features/writing/init.lua` owns proofreading commands and mappings;
  `harper.lua` configures its language-server backend, and `editor.lua` provides
  the wrapping/folding preferences enabled by Hemingway.
- `nvim/lua/ui/diagnostics.lua` owns diagnostic display and popup behaviour.
- `nvim/lua/plugins/completion.lua`, `treesitter.lua`, and `inline-diagnostics.lua`
  define the coding-only completion, syntax, and diagnostic plugins.
- User-facing feature behaviour lives under `features/`, including its backend-specific
  settings. `lsp/` handles shared server infrastructure; `plugins/` declares dependencies.

## Undo and redo (Normal mode)
- `u` undoes the last change; `<C-r>` (Ctrl+r) redoes it.
- `U` undoes all latest changes on the current line.

## Navigation
- `<A-Left>` / `<A-Right>` (Alt+Left/Right) move backward/forward through your jump history.
- `:SessionSearch` searches auto session instances you can easily jump around (e.g: to vimconfig).
- `<C-g>` shows the current file's path in the status area.
- `1<C-g>` shows the full absolute path.
- `:echo expand('%:p')` prints the full absolute path; use `%:h` for its directory, `%:t` for the filename.
- `:CopyBufferAbsolutePath` copies the current file's absolute path to the clipboard.
- `:CopyBufferRelativePath` copies its path relative to Neovim's working directory.
- `:CopyBufferFileName` copies just its file name.

## Code navigation

- `gd` jumps to the definition under the cursor; `<C-o>` jumps back.
- `gr` lists all references to the symbol under the cursor.
- `]q` / `[q` step to the next/previous reference (quickfix entry) without leaving your place.
- `K` shows hover documentation for the symbol under the cursor.
- `<leader>dd` collects all diagnostics into the quickfix list and opens it (step through with `]q` / `[q`).
- `grr` renames the symbol under the cursor within the current file only (backed by treesitter, no LSP needed).
- `<F2>` renames the symbol under the cursor across the project (uses the LSP).
- `<leader>ca` opens available code actions (works in visual mode for range-specific actions). The list appears in a small Telescope window anchored at the cursor.
- In normal mode, the `<leader>ca` list also offers **Rename symbol (LSP)** when the language server supports it; `<F2>` starts the same rename directly.
- `<leader>p` opens Telescope; from there pick `find_files` or `live_grep` to search files and contents.
- `:ToggleIgnore` toggles whether hidden/gitignored files show up in Telescope searches and nvim-tree. Prints whether the feature is ON or OFF. Default is OFF.
- `<C-i>` / `<C-o>` move forward/backward through your jump history.

### Live grep with arguments (`live_grep_args`)
Open with `:Telescope live_grep_args` or pick `live_grep_args` from `<leader>p`. The prompt is passed to ripgrep, so you can add rg flags, globs and paths after the search term.

If the prompt doesn't start with `"`, `'` or `-`, the whole prompt (spaces included) is searched as a single regex pattern. Once you add flags, quote the search term yourself.

- `foo bar` — search for "foo bar" everywhere.
- `"foo bar" src/` — search only inside `src/`.
- `"foo" --iglob *.lua` — only in files matching the glob.
- `"foo" --iglob !*test*` — exclude files matching the glob.
- `"foo" -tcs` — only C# files (`-t` takes a ripgrep file type: `lua`, `ts`, `py`, ...).
- `-w foo` — whole-word matches only.
- `-F "Foo.Bar("` — treat the pattern as a literal string (no regex).
- `--no-ignore "foo"` — also search gitignored files.

`:ToggleHidden` / `:ToggleIgnore` apply here too.

### Fuzzy refine (`<C-f>`)
In `live_grep` and `live_grep_args`, press `<C-f>` to freeze the current results and fuzzy-filter them by typing. Telescope's default for this is `<C-Space>`, but this terminal sends it as a plain space, so it's remapped to `<C-f>` (this replaces Telescope's preview-scroll-left in those pickers).

### Peeking with Telescope (`<leader>g`)
Same LSP queries as `gd` / `gr`, but in a Telescope picker with a preview pane — you
see the code without leaving the buffer, and `<Esc>` backs out with your cursor untouched.
Only bound while a language server is attached.

- `<leader>gd` — definitions of the symbol under the cursor.
- `<leader>gr` — references to it.
- `<leader>gi` — implementations (interfaces, abstract methods).
- `<leader>gt` — type definition.
- `<leader>gs` — symbols in the current file.
- `<leader>gw` — symbols across the workspace (fuzzy, queries the server as you type).
- `<leader>gc` / `<leader>go` — incoming / outgoing calls (who calls this, what this calls).

In the picker: `<C-n>`/`<C-p>` move, `<CR>` jumps, `<C-x>`/`<C-v>`/`<C-t>` open in a split/vsplit/tab.

### Code outline (Aerial)
- `<leader>a` (Space, then `a`) or `:AerialToggle` opens/closes the outline and focuses it when opened.
- In the outline: `j` / `k` select a symbol; `<CR>` jumps to its code; `q` closes; `?` shows help.
- `p` peeks at the symbol without leaving Aerial; the selected symbol's source line is highlighted while the outline has focus.
- `za` toggles a branch; `zM` collapses all; `zr` reveals one more level; `zR` expands all. Try `zM`, then `zr` until class members are visible.
- Includes classes, methods, properties, and fields. Uses Tree-sitter or LSP; full parameter lists/types may not appear.

## Completion and code actions
- Completion (nvim-cmp) pops up automatically while typing. `<Tab>` / `<S-Tab>` cycle the menu, `<CR>` accepts the selection.
- Sources are global, so every filetype gets them: LSP, buffer words, file paths, and snippets. A filetype with no language server attached still gets buffer/path/snippet completion, which is plain text matching rather than language-aware suggestions.
- `<F4>` runs the code action under the cursor (quick fixes, auto-imports, generated stubs). Requires an attached language server; filetypes without one return nothing.
- `<F2>` renames the symbol under the cursor; `<F3>` formats the buffer (or the selection, in visual mode).
- `:Format` formats via conform.nvim, falling back to the language server when no formatter is configured for the filetype. Formatters are registered per-filetype, so a filetype that's absent from that list is left untouched.

## LSP status
- `:LspInfo` (alias for `:checkhealth vim.lsp`) shows which language servers are attached to the current buffer, plus their root dir and settings.
- If diagnostics stay stale after Copilot changes another file, run `:LspRestart` from the affected file to refresh its language server (you can specify specific language servers. E.G,`:LspRestart ts_ls` for TypeScript only).
- `:lua =vim.tbl_map(function(c) return c.name end, vim.lsp.get_clients())` lists just the names of the clients running right now.
- `:Mason` shows which servers are installed (`i` installs, `X` uninstalls); a server can be installed but not attached if the filetype doesn't match.

## Split / join (treesj)
Tree-sitter aware: works on the node under the cursor (arrays, objects, argument lists, blocks, etc.).
- `gS` toggles the node between split (one item per line) and joined (one line).
- `:TSJSplit` / `:TSJJoin` force a split / join.

## Code folding
Folds are tree-sitter based and start open.
- `za` toggles the fold under the cursor; 
- `zA` recursively toggle all folds under the cursor
- `zR` / `zM` open / close all folds in the file.
- `:set foldlevel=...` controls which fold levels are open; use the cursor's `foldlevel('.')` to keep its level visible while closing sibling folds.

## Testing (neotest)
.NET tests (xUnit/NUnit/MSTest) via neotest-vstest. First discovery in a large solution builds the project, so it can be slow.

- `<leader>ts` — toggle the test explorer tree.
- `<leader>tt` — run the nearest test; `<leader>tf` — current file; `<leader>ta` — all tests; `<leader>tl` — re-run last.
- `<leader>to` — open output for the nearest test; `<leader>tO` — toggle the output panel.
- `<leader>tS` — stop running tests.
- `<leader>td` — debug the nearest test (needs a .NET debug adapter, not configured yet).

In the explorer tree:
- `r` runs the test/class/file/project under the cursor; `d` debugs it; `u` stops.
- `m` marks a test, `R` runs marked, `M` clears marks.
- `o` / `O` show full / short output; `i` jumps to the test source.
- `<CR>` expands/collapses; `e` expands all; `J` / `K` jump to next/previous failed; `x` clears results; `w` toggles watch.

## Panes
- `<C-w>+` / `<C-w>-` make the current pane taller / shorter.
- `<C-w>>` / `<C-w><` make the current pane wider / narrower.
- `<C-A-Up>` / `<C-A-Down>` make the current pane taller / shorter.
- `<C-A-Left>` / `<C-A-Right>` make the current pane narrower / wider.

## Tabs
- `<leader>tn` opens a new tab; `<leader>tc` closes the current tab.
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
- `*` — highlights the word under the cursor (or the visual selection, matched literally) without moving; `n`/`N` then navigate. `#` searches backward (jumps).
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
- `:Git add %` — stages the current file via vim-fugitive (`%` is the current file's path). Stages the saved version on disk; run `:w` first if you have unsaved changes.
- `:Gwrite` — saves the current buffer and stages the file in one command (vim-fugitive).
- `:DiffviewFileHistory` — opens the repository commit history, newest first.
- In the history panel, `<CR>`, `o`, or double-click opens the selected commit in Diffview.
- `<C-A-d>` also opens the selected commit in Diffview.
- `:DiffviewFileHistory %` — shows history for only the current file.

## Quickfix
- `<leader>q` toggles the quickfix panel.
- In quickfix, the focused entry's source line is highlighted in loaded buffers while quickfix has focus (Neovim). Moving between entries moves the highlight; leaving quickfix clears it.
- `p` brings the selected entry into view and returns focus to quickfix; `<CR>` jumps into the source window.

## Reloading config
- `:source $MYVIMRC` re-runs `init.lua` in the current session (options, global keymaps, autocmds).
- `:source %` re-runs the file you're editing.
- Plugin spec changes don't apply this way; use `:Lazy reload <plugin>` (e.g. `:Lazy reload diffview.nvim`) or restart.

## Lazy plugin commands
- `:Lazy` opens the plugin manager.
- `:Lazy install` installs missing plugins.
- `:Lazy update` updates installed plugins and the lockfile.
- `:Lazy sync` installs, updates, and removes plugins to match the config.
- `:Lazy clean` removes plugins no longer in the config.
- `:Lazy check` checks for available plugin updates.
- `:Lazy restore` restores plugin versions from the lockfile.
