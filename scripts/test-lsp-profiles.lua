-- Integration checks; install Harper in each profile first with :MasonInstall harper-ls.
-- nvim --headless -u nvim/init.lua '+luafile scripts/test-lsp-profiles.lua'
-- NVIM_APPNAME=nvim/vim-config/profiles/hemingway nvim --headless '+luafile scripts/test-lsp-profiles.lua'
local ok, err = pcall(function()
  local plugins = require("lazy.core.config").plugins
  local coding = plugins["nvim-cmp"] ~= nil
  require("lazy").load({ plugins = { "nvim-lspconfig" } })
  local installed = require("mason-lspconfig.settings").current.ensure_installed
  assert(vim.tbl_contains(installed, "harper_ls"), "Harper missing from server selection")
  assert(vim.tbl_contains(installed, "lua_ls") == coding, "Coding servers selected in wrong profile")
  assert((plugins["tiny-inline-diagnostic.nvim"] ~= nil) == coding, "Wrong diagnostic plugin selection")
  assert((plugins["nvim-treesitter"] ~= nil) == coding, "Wrong Tree-sitter selection")
  if coding then
    assert(vim.lsp.config.lua_ls.settings.Lua.telemetry.enable == false, "Lua overrides lost")
    assert(vim.tbl_contains(vim.lsp.config.ts_ls.filetypes, "vue"), "TypeScript overrides lost")
    assert(vim.lsp.config.lua_ls.capabilities.textDocument.completion.completionItem.snippetSupport,
      "Completion capabilities lost")
  else
    assert(not plugins["lsp-zero.nvim"], "Hemingway loaded coding dependencies")
  end

  assert(vim.fn.executable("harper-ls") == 1, "Install Harper first with :MasonInstall harper-ls")
  for _, ft in ipairs({ "markdown", "text" }) do
    vim.cmd("enew!")
    local bufnr = vim.api.nvim_get_current_buf()
    vim.api.nvim_buf_set_name(bufnr, vim.fn.tempname() .. (ft == "text" and ".txt" or ".md"))
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, {
      "We organise the colourful centre.",
      "This is a mispelled word.",
      "This is a a test.",
    })
    vim.bo.filetype = ft
    assert(vim.wait(15000, function()
      return #vim.lsp.get_clients({ bufnr = bufnr, name = "harper_ls" }) > 0
        and #vim.diagnostic.get(bufnr) >= 2
    end, 100), "Harper did not attach and diagnose " .. ft)
    local client = vim.lsp.get_clients({ bufnr = bufnr, name = "harper_ls" })[1]
    assert(client.settings["harper-ls"].dialect == "British", "British dialect lost")
    local spelling, grammar
    for _, diagnostic in ipairs(vim.diagnostic.get(bufnr)) do
      assert(diagnostic.lnum ~= 0, "British spelling incorrectly flagged: " .. diagnostic.message)
      if diagnostic.lnum == 1 then spelling = diagnostic end
      if diagnostic.lnum == 2 then grammar = diagnostic end
    end
    assert(spelling and grammar, "Spelling or grammar checks missing")
    vim.api.nvim_win_set_cursor(0, { spelling.lnum + 1, spelling.col })
    local params = vim.lsp.util.make_range_params(0, client.offset_encoding)
    params.context = { diagnostics = { spelling.user_data.lsp } }
    local response = client:request_sync("textDocument/codeAction", params, 5000, bufnr)
    assert(response and response.result and #response.result > 0, "Spelling corrections missing")

    local mapping = vim.fn.maparg("K", "n", false, true)
    assert(mapping.desc == "Explain writing issue", "Writing K mapping lost")
    if coding then
      mapping.callback()
    else
      assert(vim.o.updatetime == 500, "Popup delay lost")
      vim.api.nvim_exec_autocmds("CursorHold", { buffer = bufnr })
    end
    local found_popup = false
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      if vim.api.nvim_win_get_config(win).relative ~= "" then
        local text = table.concat(vim.api.nvim_buf_get_lines(vim.api.nvim_win_get_buf(win), 0, -1, false), " ")
        if text:find("mispelled", 1, true) then found_popup = true end
        vim.api.nvim_win_close(win, true)
      end
    end
    assert(found_popup, "Diagnostic explanation missing")
    vim.cmd("DiagnosticsList")
    assert(#vim.fn.getloclist(0) >= 2, "DiagnosticsList missing diagnostics")
    vim.cmd("lclose")
  end
  vim.cmd("enew!")
  assert(vim.fn.exists(":DiagnosticsList") == 2, "DiagnosticsList missing in other buffers")
  if coding then
    vim.cmd("edit nvim/lua/lsp/setup.lua")
    assert(vim.wait(15000, function()
      local clients = vim.lsp.get_clients({ bufnr = 0, name = "lua_ls" })
      return clients[1] and clients[1].initialized
    end, 100), "Lua language server did not attach")
    assert(#vim.lsp.get_clients({ bufnr = 0, name = "harper_ls" }) == 0, "Harper attached to code")
    assert(vim.fn.maparg("gr", "n", false, true).desc == "LSP references", "Coding mappings lost")
    assert(vim.fn.exists(":DiagnosticsList") == 2, "DiagnosticsList missing in Lua")
    assert(package.loaded.cmp and package.loaded.luasnip, "Completion did not load")
    assert(package.loaded["nvim-treesitter.configs"], "Tree-sitter did not load")
  end
end)

if not ok then
  vim.api.nvim_err_writeln(tostring(err))
  vim.cmd("cquit")
end
print("LSP profile checks passed")
vim.cmd("qa!")
