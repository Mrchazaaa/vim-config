return {
  {
    "gaoDean/autolist.nvim",
    ft = "markdown",
    config = function()
      local autolist = require("autolist")

      vim.opt_local.expandtab = true
      vim.opt_local.tabstop = 2
      vim.opt_local.shiftwidth = 2
      vim.opt_local.softtabstop = 2

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("markdown_two_space_lists", { clear = true }),
        pattern = "markdown",
        callback = function()
          vim.opt_local.expandtab = true
          vim.opt_local.tabstop = 2
          vim.opt_local.shiftwidth = 2
          vim.opt_local.softtabstop = 2
        end,
      })

      autolist.setup()

      vim.keymap.set("i", "<Tab>", "<cmd>AutolistTab<cr>", { desc = "Indent list item" })
      vim.keymap.set("i", "<S-Tab>", "<cmd>AutolistShiftTab<cr>", { desc = "Dedent list item" })
      vim.keymap.set("i", "<CR>", "<CR><cmd>AutolistNewBullet<cr><cmd>AutolistRecalculate<cr>", { desc = "Continue list item" })
      vim.keymap.set("n", "o", "o<cmd>AutolistNewBullet<cr><cmd>AutolistRecalculate<cr>", { desc = "New list item below" })
      vim.keymap.set("n", "O", "O<cmd>AutolistNewBulletBefore<cr><cmd>AutolistRecalculate<cr>", { desc = "New list item above" })
      vim.keymap.set("n", "<CR>", "<cmd>AutolistToggleCheckbox<cr><CR>", { desc = "Toggle checkbox" })
      vim.keymap.set("n", "<C-r>", "<cmd>AutolistRecalculate<cr>", { desc = "Recalculate list" })
      vim.keymap.set("n", "<leader>cn", autolist.cycle_next_dr, { expr = true, desc = "Cycle list marker next" })
      vim.keymap.set("n", "<leader>cp", autolist.cycle_prev_dr, { expr = true, desc = "Cycle list marker previous" })
      vim.keymap.set("n", ">>", ">><cmd>AutolistRecalculate<cr>", { desc = "Indent and recalculate list" })
      vim.keymap.set("n", "<<", "<<<cmd>AutolistRecalculate<cr>", { desc = "Dedent and recalculate list" })
      vim.keymap.set("n", "dd", "dd<cmd>AutolistRecalculate<cr>", { desc = "Delete and recalculate list" })
      vim.keymap.set("v", "d", "d<cmd>AutolistRecalculate<cr>", { desc = "Delete and recalculate list" })
    end,
  },
}
