-- Navigate soft-wrapped Markdown by visible rows rather than file lines.
for _, mapping in ipairs({
  { "j", "gj" },
  { "k", "gk" },
  { "<Down>", "gj" },
  { "<Up>", "gk" },
}) do
  vim.keymap.set({ "n", "x" }, mapping[1], mapping[2], { buffer = true, silent = true })
end

vim.keymap.set("i", "<Down>", "<C-o>gj", { buffer = true, silent = true })
vim.keymap.set("i", "<Up>", "<C-o>gk", { buffer = true, silent = true })
