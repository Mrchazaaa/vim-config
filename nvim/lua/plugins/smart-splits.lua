return {
  {
    "mrjones2014/smart-splits.nvim",
    opts = { default_amount = 5 },
    init = function()
      -- <C-w><C-Arrow> resizes, then keeps resizing on further <C-Arrow> presses (or holding).
      -- Any other key exits and is executed normally.
      local dirs = {
        [vim.keycode("<C-Up>")] = "up",
        [vim.keycode("<C-Down>")] = "down",
        [vim.keycode("<C-Left>")] = "left",
        [vim.keycode("<C-Right>")] = "right",
      }
      local function resize_loop(dir)
        local ss = require("smart-splits")
        while dir do
          ss["resize_" .. dir]()
          vim.cmd.redraw()
          local ok, key = pcall(vim.fn.getcharstr)
          if not ok then return end -- <C-c>
          dir = dirs[key]
          if not dir then vim.api.nvim_feedkeys(key, "m", false) end
        end
      end
      for key, dir in pairs({ Up = "up", Down = "down", Left = "left", Right = "right" }) do
        vim.keymap.set("n", "<C-w><C-" .. key .. ">", function() resize_loop(dir) end,
          { desc = "Move split border " .. dir .. " (repeatable)" })
      end
    end,
  },
}
