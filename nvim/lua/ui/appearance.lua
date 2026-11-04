local M = {}

function M.setup()
    if vim.fn.has('termguicolors') == 1 then
        vim.opt.termguicolors = true
    end

    vim.opt.foldcolumn = 'auto:1'
    vim.opt.fillchars = {
        foldopen = '▾',
        foldclose = '▸',
        fold = ' ',
    }
end

return M
