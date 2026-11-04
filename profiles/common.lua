local repo_root = vim.fn.fnamemodify(debug.getinfo(1).source:sub(2), ":p:h:h")

local M = {}

function M.setup(plugins)
  vim.opt.runtimepath:prepend(repo_root .. "/nvim")

  -- Select shared plugins; implementations live in nvim/lua/plugins/.
  local specs = {
    { import = "plugins.explorer" },
    { import = "plugins.smart-splits" },
    { import = "plugins.telescope" },
    { import = "plugins.dashboard" },
  }
  vim.list_extend(specs, plugins or {})
  require("lazy-setup").setup(specs)
end

return M
