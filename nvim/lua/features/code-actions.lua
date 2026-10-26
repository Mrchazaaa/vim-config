local M = {}

local function can_rename(bufnr)
  return #vim.lsp.get_clients({ bufnr = bufnr, method = "textDocument/rename" }) > 0
end

function M.setup()
  local null_ls = require("null-ls")
  null_ls.setup({
    sources = {
      {
        name = "rename_symbol",
        method = null_ls.methods.CODE_ACTION,
        filetypes = {}, -- All filetypes; availability depends on attached LSP clients.
        generator = {
          fn = function(params)
            if not can_rename(params.bufnr) then return {} end
            local kind = "refactor.rename"
            local only = (params.lsp_params.context or {}).only
            if only and not vim.iter(only):any(function(value)
              return value == "" or kind == value or vim.startswith(kind, value .. ".")
            end) then
              return {}
            end
            return { {
              title = "Rename Symbol",
              kind = kind,
              action = function()
                if vim.api.nvim_buf_is_valid(params.bufnr) and can_rename(params.bufnr) then
                  vim.api.nvim_buf_call(params.bufnr, vim.lsp.buf.rename)
                end
              end,
            } }
          end,
        },
      },
    },
  })
end

return M
