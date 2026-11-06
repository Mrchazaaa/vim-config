-- Soft-wrap prose at word boundaries, preserving indentation on wrapped lines.
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.breakindent = true

-- Window-local values can be restored when buffers or windows are switched.
vim.api.nvim_create_autocmd({ "BufWinEnter", "WinEnter", "FileType" }, {
  group = vim.api.nvim_create_augroup("writing_wrap", { clear = true }),
  callback = function()
    if vim.bo.buftype ~= "" or vim.bo.filetype == "dashboard" then
      return
    end
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.breakindent = true
  end,
})

vim.opt.spell = false
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
