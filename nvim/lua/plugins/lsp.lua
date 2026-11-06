return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "williamboman/mason.nvim",
        build = function() pcall(vim.cmd, "MasonUpdate") end,
      },
      "williamboman/mason-lspconfig.nvim",
    },
    opts = { server_groups = {}, diagnostics = "popup" },
    config = function(_, opts)
      require("lsp.setup").setup(opts)
    end,
  },
}
