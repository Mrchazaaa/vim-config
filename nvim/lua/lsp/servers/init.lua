local M = {}

M.groups = {
  coding = {
    "lua_ls", "pyright", "jsonls", "yamlls", "eslint", "bashls",
    "ts_ls", "roslyn_ls", "powershell_es", "cucumber_language_server",
  },
  writing = { "harper_ls" },
}

-- Load overrides only for selected servers (Lua's settings use lsp-zero).
M.overrides = {
  harper_ls = "features.writing.harper",
  lua_ls = "lsp.servers.lua",
  ts_ls = "lsp.servers.typescript",
}

function M.select(groups)
  local servers, seen = {}, {}
  for _, group in ipairs(groups) do
    for _, server in ipairs(assert(M.groups[group], "Unknown LSP group: " .. group)) do
      if not seen[server] then
        servers[#servers + 1] = server
        seen[server] = true
      end
    end
  end
  return servers
end

return M
