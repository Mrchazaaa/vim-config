local repo_root = vim.fn.fnamemodify(debug.getinfo(1).source:sub(2), ':p:h:h:h:h')

local M = {}

function M.setup()
    vim.cmd.source(vim.fn.fnameescape(repo_root .. '/vim/CoreConfig/gutter.vim'))

    -- Collapsed folds have their own summary; keep the gutter for numbers and signs.
    vim.opt.foldcolumn = '0'
    vim.opt.statuscolumn = ''
end

return M
