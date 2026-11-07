local M = {}

function M.setup()
  vim.keymap.set('n', '<leader>q', function()
    if vim.fn.getcmdwintype() ~= '' then
      vim.cmd('quit')
      return
    end

    for _, win in ipairs(vim.fn.getwininfo()) do
      if win.quickfix == 1 and win.loclist == 0 then
        vim.cmd('cclose')
        return
      end
    end
    vim.cmd('copen')
  end, { desc = 'Toggle quickfix list' })
end

return M
