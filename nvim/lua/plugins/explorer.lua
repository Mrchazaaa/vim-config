return {
  {
    "nvim-tree/nvim-tree.lua",
    version = "*", -- use latest stable release
    dependencies = {
      "nvim-tree/nvim-web-devicons", -- for file icons
    },
    config = function()
      require("nvim-tree").setup({
        sync_root_with_cwd = true,
        update_focused_file = {
          enable = true,
        },
        sort_by = "case_sensitive",
        view = {
          width = 30,
        },
        renderer = {
          group_empty = true,
          highlight_git = true
        },
        filters = {
          dotfiles = true,
          git_ignored = true,
        },
        diagnostics = {
          enable = true, -- show LSP diagnostics in the tree
        },
        git = {
          enable = true, -- show git status
          timeout = 5000, -- big repos (C:/source/core) blow the 400ms default
        },
      })

      -- optional keymaps
      vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { noremap = true, silent = true })
      vim.keymap.set("n", "<leader>fe", "<Cmd>NvimTreeFocus<CR>", { desc = "Focus explorer" })
    end,
  }
}
