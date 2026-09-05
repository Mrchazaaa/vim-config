return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
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

      local tc = require("telescope.config")
      local show_all = true

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
    opts = function()
      local actions = require("telescope.actions")
      return {
        defaults = {
          mappings = {
            i = {
              ["<C-j>"]    = actions.preview_scrolling_down,
              ["<C-k>"]    = actions.preview_scrolling_up,
              ["<C-Up>"]   = actions.preview_scrolling_up,
              ["<C-Down>"] = actions.preview_scrolling_down,
            },
            n = {
              ["<C-j>"]    = actions.preview_scrolling_down,
              ["<C-k>"]    = actions.preview_scrolling_up,
              ["<C-Up>"]   = actions.preview_scrolling_up,
              ["<C-Down>"] = actions.preview_scrolling_down,
            },
          },
        },
      }
    end,
  },
}
