local M = {}

-- Full writing-editor preferences are opt-in; proofreading also works in coding.
function M.setup()
  require("features.writing.editor").setup()
end

function M.attach(bufnr)
  vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action,
    { buffer = bufnr, desc = "Writing corrections" })
  vim.keymap.set("n", "K", function()
    vim.diagnostic.open_float(nil, { scope = "cursor" })
  end, { buffer = bufnr, desc = "Explain writing issue" })
end

return M
