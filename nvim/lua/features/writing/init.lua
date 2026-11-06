local M = {}

-- Full writing-editor preferences are opt-in; proofreading also works in coding.
function M.setup()
  require("features.writing.editor").setup()
end

function M.attach(bufnr)
  vim.api.nvim_buf_create_user_command(bufnr, "WritingFix", function()
    vim.lsp.buf.code_action()
  end, { desc = "Show prose corrections at the cursor" })
  vim.api.nvim_buf_create_user_command(bufnr, "WritingIssues", function()
    vim.diagnostic.setloclist()
  end, { desc = "List spelling, grammar, and style issues in this document" })
  vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action,
    { buffer = bufnr, desc = "Writing corrections" })
  vim.keymap.set("n", "K", function()
    vim.diagnostic.open_float(nil, { scope = "cursor" })
  end, { buffer = bufnr, desc = "Explain writing issue" })
end

return M
