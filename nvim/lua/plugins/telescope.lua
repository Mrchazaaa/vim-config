return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>p", "<Cmd>Telescope<CR>", desc = "Open Telescope" },
    },
    config = function()
      require("telescope").setup({
        pickers = {
          find_files = {
            hidden = true,
            no_ignore = true,
          },
          live_grep = {
            additional_args = function(opts)
              return { "--hidden", "--no-ignore" }
            end,
          },
        },
      })
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
