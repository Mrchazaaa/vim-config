-- Run from the repo root: nvim --headless -u NONE -l nvim/test-quickfix-preview.lua
vim.cmd('filetype plugin on')
dofile('nvim/lua/ui/init.lua').setup()
local source = vim.api.nvim_get_current_buf()
local source_win = vim.api.nvim_get_current_win()
vim.api.nvim_buf_set_lines(source, 0, -1, false, { 'first', 'second' })
local items = {
    { bufnr = source, lnum = 1, text = 'first' },
    { bufnr = source, lnum = 2, text = 'second' },
    { text = 'invalid entry' },
}
local ns = vim.api.nvim_get_namespaces().QuickfixPreview
local function marks()
    return vim.api.nvim_buf_get_extmarks(source, ns, 0, -1, {})
end
for _, location_list in ipairs({ false, true }) do
    if location_list then
        vim.fn.setloclist(0, items)
        vim.cmd('lopen')
    else
        vim.fn.setqflist(items)
        vim.cmd('copen')
    end
    local list_win = vim.api.nvim_get_current_win()
    for row = 1, 3 do
        vim.api.nvim_win_set_cursor(list_win, { row, 0 })
        vim.api.nvim_exec_autocmds('CursorMoved', {})
        local found = marks()
        if row < 3 then
            assert(#found == 1 and found[1][2] == row - 1, 'Wrong source highlight')
        else
            assert(#found == 0, 'Invalid entry left a highlight')
        end
    end
    vim.api.nvim_win_set_cursor(list_win, { 2, 0 })
    vim.api.nvim_exec_autocmds('CursorMoved', {})
    vim.api.nvim_set_current_win(source_win)
    assert(#marks() == 0, 'Highlight remained after leaving list')
    vim.api.nvim_set_current_win(list_win)
    assert(#marks() == 1, 'Highlight not restored on focus')
    vim.cmd(location_list and 'lclose' or 'cclose')
    assert(#marks() == 0, 'Highlight remained after closing list')
    assert(not vim.wo[source_win].cursorline, 'Changed source cursorline setting')
end
print('Quickfix/location-list focus highlights: OK')
