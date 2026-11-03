local config_path = vim.fn.fnamemodify(debug.getinfo(1).source:sub(2), ":p:h:h")

local M = {}

function M.setup(plugins)
  vim.g.mapleader = vim.g.mapleader or " "
  require("lazy-bootstrap")

  require("lazy").setup(plugins, {
    change_detection = { notify = false },
    rocks = { enabled = false },
    performance = {
      rtp = {
        paths = {
          config_path,
          config_path .. "/after",
          "/usr/lib/nvim",
        },
      },
    },
  })
end

return M
