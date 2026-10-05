local M = {}

function M.setup()
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

    -- <leader>dd: collect all diagnostics into the quickfix list and open it.
    -- (dd not d, so the <leader>d* DAP maps don't sit behind a timeoutlen wait)
    vim.keymap.set('n', '<leader>dd', function()
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

    local preview_ns = vim.api.nvim_create_namespace('QuickfixPreview')
    local preview_buf
    vim.api.nvim_create_autocmd({ 'CursorMoved', 'BufEnter', 'WinEnter', 'BufLeave', 'WinLeave' }, {
        group = vim.api.nvim_create_augroup('QuickfixPreview', { clear = true }),
        callback = function(event)
            if preview_buf and vim.api.nvim_buf_is_valid(preview_buf) then
                vim.api.nvim_buf_clear_namespace(preview_buf, preview_ns, 0, -1)
            end
            preview_buf = nil
            if event.event == 'BufLeave' or event.event == 'WinLeave' or vim.bo.filetype ~= 'qf' then
                return
            end
            local is_loclist = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1].loclist == 1
            local items = is_loclist and vim.fn.getloclist(0) or vim.fn.getqflist()
            local item = items[vim.fn.line('.')]
            if not item or item.valid ~= 1 or not vim.api.nvim_buf_is_loaded(item.bufnr)
                or item.lnum < 1 or item.lnum > vim.api.nvim_buf_line_count(item.bufnr) then
                return
            end
            preview_buf = item.bufnr
            vim.api.nvim_buf_set_extmark(preview_buf, preview_ns, item.lnum - 1, 0, {
                line_hl_group = 'QuickFixLine',
            })
        end,
    })

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
