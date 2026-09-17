return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = vim.fn.has("win32") == 1
          and "zig cc -O3 -shared -o build/libfzf.dll src/fzf.c"
          or "make",
      },
    },
    cmd = "Telescope",
    -- ui-select replaces vim.ui.select globally, so it must load before the
    -- first code action rather than waiting for a :Telescope invocation.
    event = "VeryLazy",
    keys = {
      { "<leader>p", "<Cmd>Telescope<CR>", desc = "Open Telescope" },
    },
    config = function()
      require("telescope").setup({
        defaults = {
          path_display = { "smart" },
        },
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_cursor(),
          },
        },
      })
      require("telescope").load_extension("fzf")
      require("telescope").load_extension("ui-select")

      local tc = require("telescope.config")
      local nvim_tree_api = require("nvim-tree.api")
      local show_ignored = false
      local show_hidden = true

      local function apply()
        tc.set_pickers({
          find_files = {
            hidden = show_hidden,
            no_ignore = show_ignored,
          },
          live_grep = {
            additional_args = function()
              local args = {}
              if show_hidden then table.insert(args, "--hidden") end
              if show_ignored then table.insert(args, "--no-ignore") end
              return args
            end,
          },
        })
      end

      vim.api.nvim_create_user_command("ToggleIgnore", function()
        show_ignored = not show_ignored
        nvim_tree_api.filter.git.ignored.toggle()
        apply()
        print("Show gitignored files: " .. (show_ignored and "ON" or "OFF"))
      end, { desc = "Toggle gitignored files" })

      vim.api.nvim_create_user_command("ToggleHidden", function()
        show_hidden = not show_hidden
        nvim_tree_api.filter.dotfiles.toggle()
        apply()
        print("Show hidden files: " .. (show_hidden and "ON" or "OFF"))
      end, { desc = "Toggle hidden files" })

      apply()
    end,
  },
}
