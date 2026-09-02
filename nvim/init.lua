-- Add the current directory to the Lua path
local config_path = vim.fn.fnamemodify(debug.getinfo(1).source:sub(2), ':p:h')
package.path = config_path .. '/lua/?.lua;' .. config_path .. '/lua/?/init.lua;' .. package.path

-- Prefer LF line endings (matches repo .gitattributes; avoids diffview CRLF/LF mismatch)
vim.opt.fileformats = { "unix", "dos" }

-- Bootstrap lazy.nvim (this must happen before requiring lazy)
require('lazy-bootstrap')

-- Setup lazy.nvim with plugins (now lazy.nvim is available)
require('lazy').setup(require('lazy-plugins'), {
  change_detection = { notify = false },
  rocks = { enabled = false },
  performance = {
    rtp = {
      paths = { "/usr/lib/nvim" },
    },
  },
})

-- UI components (theme customizations after lazy loads)
require('ui').setup()

vim.api.nvim_create_user_command("HelpMe", function()
  vim.cmd("new " .. vim.fn.fnameescape(config_path .. "/../Help.md"))
end, { desc = "Open this configuration's help in a new window" })

-- Create a Lua scratchfile command
vim.api.nvim_create_user_command("LuaScratch", function()
  local scratch_path = vim.fn.stdpath("config") .. "/scratch.lua"
  vim.cmd("edit " .. scratch_path)
end, { desc = "Open Lua scratch file" })
