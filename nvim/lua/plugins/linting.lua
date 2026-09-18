return {
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      local lint = require("lint")
      lint.linters_by_ft = {
        python = { "ruff" },
        javascript = { "eslint_d" },
        typescript = { "eslint_d" },
        yaml = { "yamllint" },
        sh = { "shellcheck" },
      }

      -- Uncomment to enable auto-linting
      -- local function try_lint()
      --   lint.try_lint()
      -- end

      -- vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
      --   callback = try_lint,
      -- })
    end,
  },
}
