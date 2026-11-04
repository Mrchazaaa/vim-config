-- Soft-wrap prose at word boundaries, preserving indentation on wrapped lines.
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.breakindent = true

-- Highlight misspellings; use z= for suggestions and zg to accept a word.
vim.opt.spelllang = "en"
vim.opt.spell = true

-- Use the built-in Markdown heading folds, with sections open initially.
vim.g.markdown_folding = 1
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("writing_markdown_folds", { clear = true }),
  pattern = "markdown",
  callback = function()
    vim.opt_local.foldenable = true
    vim.opt_local.foldlevel = 99
  end,
})
