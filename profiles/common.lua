local repo_root = vim.fn.fnamemodify(debug.getinfo(1).source:sub(2), ":p:h:h")

local M = {}

function M.setup(plugins)
  vim.opt.runtimepath:prepend(repo_root .. "/nvim")

  -- Reuse the navigation mappings shared with Vim in every Neovim profile.
  for _, path in ipairs({
    "WindowNavigation.vim",
    "Quickfix.vim",
    "TextNavigation/CursorHistory.vim",
    "TextNavigation/Motions.vim",
    "TextNavigation/Search.vim",
  }) do
    vim.cmd.source(vim.fn.fnameescape(repo_root .. "/vim/CoreConfig/" .. path))
  end

  -- Select shared plugins; implementations live in nvim/lua/plugins/.
  local specs = {
    { "tpope/vim-sensible" },
    { "tpope/vim-commentary" },
    { import = "plugins.theme" },
    { import = "plugins.statusline" },
    { import = "plugins.explorer" },
    { import = "plugins.smart-splits" },
    { import = "plugins.telescope" },
    { import = "plugins.dashboard" },
    { import = "plugins.session" },
    { import = "plugins.commandcomplete" },
    { import = "plugins.git" },
    { import = "plugins.markdown" },
  }
  vim.list_extend(specs, plugins or {})
  require("lazy-setup").setup(specs)
  require("ui.appearance").setup()

  require("features.tabs").setup()
  require("features.buffer-paths").setup()
  require("features.quickfix").setup()
end

return M
