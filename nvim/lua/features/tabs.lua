local M = {}

function M.setup()
  vim.keymap.set("n", "<leader>tc", "<cmd>tabnew<cr>", { desc = "New tab" })
  vim.keymap.set("n", "<leader>tx", "<cmd>tabclose<cr>", { desc = "Close tab" })
end

return M
