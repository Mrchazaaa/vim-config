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

    -- Folds
    vim.opt.foldcolumn = 'auto:1'
    vim.opt.fillchars = {
        foldopen = '▾',
        foldclose = '▸',
        fold = ' ',
    }

    -- Clear search highlight on Esc
    vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlight' })

    -- <leader>d: collect all diagnostics into the quickfix list and open it.
    vim.keymap.set('n', '<leader>d', function()
        vim.diagnostic.setqflist()
    end, { desc = 'Diagnostics to quickfix list' })

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

    vim.keymap.set('n', 'q:', '<Nop>', { desc = 'Disable command history window' })

    -- Search and replace across project
    vim.api.nvim_create_user_command("SearchAndReplace", function()
        local pattern = vim.fn.input("Search pattern: ")
        if pattern == "" then return end
        local replacement = vim.fn.input("Replace with: ")
        vim.cmd("Rg " .. pattern)
        local esc_pattern = vim.fn.escape(pattern, "/")
        local esc_replacement = vim.fn.escape(replacement, "/")
        vim.cmd("cfdo %s/" .. esc_pattern .. "/" .. esc_replacement .. "/g | update")
    end, {})

    vim.api.nvim_create_user_command("SearchAndReplaceConfirm", function()
        local pattern = vim.fn.input("Search pattern: ")
        if pattern == "" then return end
        local replacement = vim.fn.input("Replace with: ")
        vim.cmd("Rg " .. pattern)
        local esc_pattern = vim.fn.escape(pattern, "/")
        local esc_replacement = vim.fn.escape(replacement, "/")
        vim.cmd("cfdo %s/" .. esc_pattern .. "/" .. esc_replacement .. "/gc | update")
    end, {})
end

return M
