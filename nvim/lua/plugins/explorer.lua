return {
  -- {
  --   "preservim/nerdtree",
  --   dependencies = {
  --       "tiagofumo/vim-nerdtree-syntax-highlight",
  --   },
  --   lazy = false,
  --   cmd = { "NERDTree", "NERDTreeToggle", "NERDTreeFind" },
  --   init = function()
  --     vim.g.NERDTreeHijackNetrw = 1
  --   end,
  --   config = function()
  --     vim.g.NERDTreeShowHidden = 1
  --   end
  -- },


  {
    "nvim-tree/nvim-tree.lua",
    version = "*", -- use latest stable release
    dependencies = {
      "nvim-tree/nvim-web-devicons", -- for file icons
    },
    config = function()
      require("nvim-tree").setup({
        sync_root_with_cwd = true,
        sort_by = "case_sensitive",
        view = {
          width = 30,
        },
        renderer = {
          group_empty = true,
          highlight_git = true
        },
        filters = {
          dotfiles = false,
          git_ignored = false,
        },
        diagnostics = {
          enable = true, -- show LSP diagnostics in the tree
        },
        git = {
          enable = true, -- show git status
        },
      })

      -- vim.api.nvim_create_user_command('NvimTreeModified', function()
      --     local git_files = vim.fn.systemlist("git ls-files -m")
      --     if #git_files == 0 then
      --         print("No modified files.")
      --         return
      --     end
      --     require('nvim-tree.api').tree.open()
      --     require('nvim-tree.api').tree.find_file(git_files[1])
      --     for _, file in ipairs(git_files) do
      --         vim.cmd("edit " .. file)
      --     end
      -- end, {})

      -- optional keymaps
      vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { noremap = true, silent = true })
      vim.keymap.set("n", "<leader>f", ":NvimTreeFindFile<CR>", { noremap = true, silent = true })
    end,
  }
}
