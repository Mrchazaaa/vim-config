-- Picker lives in lua/telescope/_extensions/tabs.lua so it shows up in <leader>p.
local function pick_tabs() require("telescope").extensions.tabs.tabs() end

vim.api.nvim_create_user_command("Tabs", pick_tabs, { desc = "Pick a tab with Telescope" })

return {
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      { "<leader>ft", pick_tabs, desc = "Pick tab" },
    },
  },
}
