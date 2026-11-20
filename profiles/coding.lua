local profiles_path = vim.fn.fnamemodify(debug.getinfo(1).source:sub(2), ":p:h")

local M = {}

function M.setup()
  -- Select shared Vimscript modules explicitly; Main.vim belongs to Vim.
  -- Navigation and quickfix are loaded once by common.lua.
  for _, path in ipairs({
    "MessagesToBuf.vim",
    "ConfigVerification.vim",
    "ConfigUpdate.vim",
    "EditorSettings.vim",
    "Filetypes.vim",
    "Folding.vim",
  }) do
    vim.cmd.source(vim.fn.fnameescape(profiles_path .. "/../vim/CoreConfig/" .. path))
  end
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
      opts = { server_groups = { "coding" }, diagnostics = "inline" },
    },
    { import = "plugins.completion" },
    { import = "plugins.treesitter" },
    { import = "plugins.inline-diagnostics" },
    { import = "plugins.formatting" },
    { import = "plugins.linting" },
    { import = "plugins.dap" },
    { import = "plugins.test" },
    { import = "plugins.csv" },
    { import = "plugins.splitjoin" },
  })
end

return M
