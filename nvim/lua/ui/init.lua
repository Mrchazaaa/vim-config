local M = {}

function M.setup()
    -- Colors and theme setup
    local colorscheme_group = vim.api.nvim_create_augroup('ColorschemePreferences', { clear = true })
    vim.api.nvim_create_autocmd('ColorScheme', {
        group = colorscheme_group,
        pattern = '*',
        callback = function()
            vim.cmd('highlight Normal ctermbg=NONE guibg=NONE')
            vim.cmd('highlight SignColumn ctermbg=NONE guibg=NONE')
            vim.cmd('highlight Todo ctermbg=NONE guibg=NONE')
        end
    })

    if vim.fn.has('termguicolors') == 1 then
        vim.opt.termguicolors = true
    end

    -- <leader>d: collect all diagnostics into the quickfix list and open it.
    vim.keymap.set('n', '<leader>d', function()
        vim.diagnostic.setqflist()
    end, { desc = 'Diagnostics to quickfix list' })
end

return M