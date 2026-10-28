return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
      {
        "nvim-telescope/telescope-live-grep-args.nvim",
        -- Avoid breaking changes; bump manually for major updates.
        version = "^1.0.0",
      },
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
      { "<leader>ff", "<Cmd>Telescope find_files<CR>", desc = "Find files" },
      {
        "<leader>p",
        function() require("telescope.builtin").builtin({ include_extensions = true }) end,
        desc = "Open Telescope",
      },
      {
        "<leader>fg",
        function()
          vim.ui.input({ prompt = "Glob (e.g. *.lua, comma-separated): " }, function(g)
            if not g or g == "" then return end
            require("telescope.builtin").live_grep({
              glob_pattern = vim.split(g, "%s*,%s*"),
              prompt_title = "Live Grep [" .. g .. "]",
            })
          end)
        end,
        desc = "Live grep in files matching glob",
      },
    },
    config = function()
      local show_ignored = false
      local show_hidden = true

      local function rg_extra_args()
        local args = { "--glob", "!.git/" }
        if show_hidden then table.insert(args, "--hidden") end
        if show_ignored then table.insert(args, "--no-ignore") end
        return args
      end

      require("telescope").setup({
        defaults = {
          path_display = { "smart" },
          layout_strategy = "vertical",
          layout_config = { vertical = { preview_height = 0.35 } },
        },
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_cursor(),
          },
          live_grep_args = {
            auto_quoting = true,
            -- Evaluated per search, so :ToggleHidden / :ToggleIgnore apply here too.
            additional_args = rg_extra_args,
          },
        },
      })
      require("telescope").load_extension("fzf")
      require("telescope").load_extension("ui-select")
      require("telescope").load_extension("tabs")
      require("telescope").load_extension("live_grep_args")

      local tc = require("telescope.config")
      local nvim_tree_api = require("nvim-tree.api")

      local function apply()
        tc.set_pickers({
          find_files = {
            hidden = show_hidden,
            no_ignore = show_ignored,
          },
          live_grep = {
            additional_args = rg_extra_args,
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
