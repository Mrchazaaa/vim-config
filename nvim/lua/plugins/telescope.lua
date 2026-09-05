return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
    },
    cmd = "Telescope",
    keys = {
      { "<leader>p", "<Cmd>Telescope<CR>", desc = "Open Telescope" },
    },
    config = function()
      require("telescope").setup({
        defaults = {
          path_display = { "smart" },
        },
      })
      require("telescope").load_extension("fzf")

      local tc = require("telescope.config")
      local show_all = false

      local function apply()
        if show_all then
          tc.set_pickers({
            find_files = { hidden = true, no_ignore = true },
            live_grep = {
              additional_args = function() return { "--hidden", "--no-ignore" } end,
            },
          })
        else
          tc.set_pickers({
            find_files = { hidden = false, no_ignore = false },
            live_grep = {},
          })
        end
      end

      vim.api.nvim_create_user_command("ToggleIgnore", function()
        show_all = not show_all
        apply()
        print("Show hidden/ignored files: " .. (show_all and "ON" or "OFF"))
      end, {})

      apply()
    end,
  },
}
