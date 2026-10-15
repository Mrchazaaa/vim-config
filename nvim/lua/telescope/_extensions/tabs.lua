-- Telescope picker for tabs: lists "N: file(s)" per tab, <CR> jumps to it.
local function pick_tabs()
  local actions = require("telescope.actions")
  local state = require("telescope.actions.state")
  local items = {}
  for i, tab in ipairs(vim.api.nvim_list_tabpages()) do
    local names = {}
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tab)) do
      local name = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(win))
      table.insert(names, name == "" and "[No Name]" or vim.fn.fnamemodify(name, ":t"))
    end
    table.insert(items, { tab = tab, text = i .. ": " .. table.concat(names, ", ") })
  end

  require("telescope.pickers").new({}, {
    prompt_title = "Tabs",
    finder = require("telescope.finders").new_table({
      results = items,
      entry_maker = function(item)
        return { value = item.tab, display = item.text, ordinal = item.text }
      end,
    }),
    sorter = require("telescope.config").values.generic_sorter({}),
    attach_mappings = function(bufnr)
      actions.select_default:replace(function()
        actions.close(bufnr)
        vim.api.nvim_set_current_tabpage(state.get_selected_entry().value)
      end)
      return true
    end,
  }):find()
end

return require("telescope").register_extension({ exports = { tabs = pick_tabs } })
