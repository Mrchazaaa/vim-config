return {
  {
    "hat0uma/csvview.nvim",
    ft = { "csv" }, -- load only for CSV files
    opts = {
      -- you can tweak these if you like
      align = true,            -- automatically align columns when opening
      separator = ",",         -- CSV delimiter
      highlight = true,        -- highlight columns
      trim_whitespace = true,  -- remove extra padding on save
      display_mode = "border",
      view = {
        -- header_lnum = true,
        header_lnum = 0,
        sticky_header = {
          enabled = true
        }
      }
    },
    config = function(_, opts)
      local csvview = require("csvview")
      csvview.setup(opts)

      -- optional: auto-enable view when opening a CSV
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "csv",
        callback = function()
          csvview.enable()
          vim.keymap.set("n", "<leader>ca", csvview.align, { buffer = true, desc = "Align CSV columns" })
        end,
      })

      -- optional keymaps for quick toggling
      vim.keymap.set("n", "<leader>cv", function()
        csvview.toggle()
      end, { desc = "Toggle CSV view" })
    end,
  }
}
