local M = {}

function M.setup(style)
  assert(style == "inline" or style == "popup", "Unknown diagnostic style: " .. tostring(style))
  vim.diagnostic.config({
    underline = true,
    virtual_text = false,
    signs = true,
    severity_sort = true,
    update_in_insert = false,
    float = { border = "rounded", source = style == "popup" },
  })
  local group = vim.api.nvim_create_augroup("lsp_diagnostic_popups", { clear = true })
  if style == "popup" then
    vim.opt.updatetime = 500
    vim.api.nvim_create_autocmd("CursorHold", {
      group = group,
      callback = function()
        if #vim.lsp.get_clients({ bufnr = 0 }) > 0 then
          vim.diagnostic.open_float(nil, { focus = false, scope = "cursor" })
        end
      end,
    })
  end
end

return M
