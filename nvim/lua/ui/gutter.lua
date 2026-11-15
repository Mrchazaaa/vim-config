local M = {}

function M.setup()
    -- Collapsed folds have their own summary; keep the gutter for numbers and signs.
    vim.opt.foldcolumn = '0'
    vim.opt.statuscolumn = ''
end

return M
