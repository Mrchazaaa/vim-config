local profiles_path = vim.fn.fnamemodify(debug.getinfo(1).source:sub(2), ":p:h")

local M = {}

function M.setup()
  -- Coding retains the legacy editor settings; navigation comes from common.lua.
  vim.cmd.source(vim.fn.fnameescape(profiles_path .. "/../vim/CoreConfig/Main.vim"))
  dofile(profiles_path .. "/common.lua").setup({
    { import = "plugins.finder" },
    { import = "plugins.outline" },
    { import = "plugins.tabpicker" },
    { import = "plugins.lsp" },
    {
      "neovim/nvim-lspconfig",
      event = { "BufReadPost", "BufNewFile" },
      dependencies = {
        { "VonHeikemen/lsp-zero.nvim", branch = "v4.x" },
        { "nvimtools/none-ls.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
        "hrsh7th/cmp-nvim-lsp",
      },
      opts = { server_groups = { "coding", "writing" }, diagnostics = "inline" },
    },
    { import = "plugins.completion" },
    { import = "plugins.treesitter" },
    { import = "plugins.inline-diagnostics" },
    { import = "plugins.formatting" },
    { import = "plugins.linting" },
    { import = "plugins.dap" },
    { import = "plugins.test" },
    { import = "plugins.csv" },
    { import = "plugins.markdown" },
    { import = "plugins.splitjoin" },
  })
end

return M
