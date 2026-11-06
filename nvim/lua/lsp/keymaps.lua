local M = {}

function M.attach(bufnr, client)
  require("lsp-zero").default_keymaps({ buffer = bufnr })
  vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action,
    { buffer = bufnr, desc = "Code action" })
  vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = bufnr, desc = "LSP references" })
  vim.keymap.set("n", "]q", "<cmd>cnext<CR>", { buffer = bufnr, desc = "Next quickfix (reference)" })
  vim.keymap.set("n", "[q", "<cmd>cprev<CR>", { buffer = bufnr, desc = "Prev quickfix (reference)" })
  for key, picker in pairs({
    d = "lsp_definitions", r = "lsp_references", i = "lsp_implementations",
    t = "lsp_type_definitions", s = "lsp_document_symbols", w = "lsp_dynamic_workspace_symbols",
    c = "lsp_incoming_calls", o = "lsp_outgoing_calls",
  }) do
    vim.keymap.set("n", "<leader>g" .. key, "<Cmd>Telescope " .. picker .. "<CR>",
      { buffer = bufnr, desc = "Telescope " .. picker })
  end
  if client.server_capabilities.inlayHintProvider then
    pcall(vim.lsp.inlay_hint.enable, true, { bufnr = bufnr })
  end
end

return M
