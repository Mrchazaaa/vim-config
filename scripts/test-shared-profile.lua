-- Run with either profile, e.g.:
-- nvim --headless -u profiles/hemingway/init.lua '+luafile scripts/test-shared-profile.lua'
local ok, err = pcall(function()
  local plugins = require("lazy.core.config").plugins
  assert(plugins["nvim-tree.lua"], "Shared explorer is missing")
  assert(vim.fn.exists(":NvimTreeToggle") == 2, "Explorer did not initialize")
  assert(vim.fn.maparg(" e", "n") ~= "", "Explorer toggle mapping is missing")
  assert(vim.fn.maparg(" fe", "n") ~= "", "Explorer focus mapping is missing")
  assert(#vim.api.nvim_get_runtime_file("lua/plugins/explorer.lua", false) > 0,
    "Plugin implementation runtime was lost during lazy setup")

  if vim.fn.exists(":CopySymbolPath") == 2 then
    assert(plugins["aerial.nvim"], "Coding profile lost its outline plugin")
  else
    assert(not plugins["aerial.nvim"], "Writing profile loaded coding plugins")
    assert(vim.wo.wrap and vim.wo.linebreak and vim.wo.breakindent,
      "Writing profile lost its wrapping settings")
    vim.cmd("setlocal nowrap nolinebreak nobreakindent")
    vim.cmd("enew")
    assert(vim.wo.wrap and vim.wo.linebreak and vim.wo.breakindent,
      "Writing profile did not restore wrapping when entering a text buffer")
    local text_win = vim.api.nvim_get_current_win()
    require("nvim-tree.api").tree.open()
    assert(not vim.wo.wrap, "Writing wrapping overrode explorer window settings")
    vim.wo[text_win].linebreak = false
    vim.wo[text_win].breakindent = false
    vim.api.nvim_set_current_win(text_win)
    assert(vim.wo.wrap and vim.wo.linebreak and vim.wo.breakindent,
      "Writing profile did not restore wrapping when returning from explorer")
  end
  require("nvim-tree.api").tree.open()
  assert(vim.bo.filetype == "NvimTree", "Explorer did not open")
end)

if not ok then
  vim.api.nvim_err_writeln(tostring(err))
  vim.cmd("cquit")
end
print("Shared profile checks passed")
vim.cmd("qa!")
