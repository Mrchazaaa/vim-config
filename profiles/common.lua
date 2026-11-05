local repo_root = vim.fn.fnamemodify(debug.getinfo(1).source:sub(2), ":p:h:h")

local M = {}

function M.setup(plugins)
  vim.opt.runtimepath:prepend(repo_root .. "/nvim")

  -- Select shared plugins; implementations live in nvim/lua/plugins/.
  local specs = {
    { import = "plugins.theme" },
    { import = "plugins.statusline" },
    { import = "plugins.explorer" },
    { import = "plugins.smart-splits" },
    { import = "plugins.telescope" },
    { import = "plugins.dashboard" },
    { import = "plugins.git" },
  }
  vim.list_extend(specs, plugins or {})
  require("lazy-setup").setup(specs)
  require("ui.appearance").setup()

  require("features.tabs").setup()
end

return M
