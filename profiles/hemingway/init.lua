local profile_path = vim.fn.fnamemodify(debug.getinfo(1).source:sub(2), ":p:h")
local repo_root = vim.fn.fnamemodify(profile_path, ":h:h")
dofile(repo_root .. "/profiles/common.lua").setup({
  { import = "plugins.lsp" },
  {
    "neovim/nvim-lspconfig",
    opts = { server_groups = { "writing" }, diagnostics = "popup" },
  },
})

require("features.writing").setup()
