local M = {}

function M.setup()
  for _, path in ipairs({
    { "AbsolutePath", ":p" },
    { "RelativePath", ":." },
    { "FileName", ":t" },
  }) do
    vim.api.nvim_create_user_command("CopyBuffer" .. path[1], function()
      local name = vim.api.nvim_buf_get_name(0)
      if name == "" then
        vim.notify("Current buffer has no file name", vim.log.levels.WARN)
        return
      end
      local value = vim.fn.fnamemodify(name, path[2])
      vim.fn.setreg("+", value)
      vim.api.nvim_echo({ { value } }, false, {})
    end, { desc = "Copy buffer " .. path[1] .. " to clipboard" })
  end
end

return M
