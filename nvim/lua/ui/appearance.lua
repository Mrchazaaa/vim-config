local M = {}

function M.setup()
    if vim.fn.has('termguicolors') == 1 then
        vim.opt.termguicolors = true
    end
end

return M
