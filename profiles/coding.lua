local profiles_path = vim.fn.fnamemodify(debug.getinfo(1).source:sub(2), ":p:h")

local M = {}

function M.setup()
  dofile(profiles_path .. "/common.lua").setup({
    { import = "plugins.core" },
    { import = "plugins.finder" },
    { import = "plugins.outline" },
    { import = "plugins.tabpicker" },
    { import = "plugins.commandcomplete" },
    { import = "plugins.git" },
    { import = "plugins.lsp" },
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
