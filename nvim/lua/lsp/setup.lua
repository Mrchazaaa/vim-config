local M = {}

function M.setup(opts)
  local registry = require("lsp.servers")
  local servers = registry.select(opts.server_groups)
  local coding = vim.tbl_contains(opts.server_groups, "coding")

  require("ui.diagnostics").setup(opts.diagnostics)
  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("profile_lsp_attach", { clear = true }),
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if not client then return end
      if coding and not vim.tbl_contains({ "markdown", "text" }, vim.bo[args.buf].filetype) then
        require("lsp.keymaps").attach(args.buf, client)
      end
    end,
  })

  if coding then
    vim.lsp.config("*", { capabilities = require("cmp_nvim_lsp").default_capabilities() })
    require("features.code-actions").setup()
  end
  for _, server in ipairs(servers) do
    local module = registry.overrides[server]
    if module then vim.lsp.config(server, require(module)) end
  end
  require("mason").setup({ ui = { border = "rounded" } })
  require("mason-lspconfig").setup({
    ensure_installed = servers,
    automatic_enable = servers,
  })
end

return M
