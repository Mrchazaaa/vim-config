
return {
  { "tpope/vim-sensible" },
  { "tpope/vim-commentary" },

  {
    "rmagatti/auto-session",
    config = function()
      local plain_start = (vim.fn.argc() == 0) and (vim.fn.line2byte("$") == -1)
      vim.opt.sessionoptions:append("localoptions")

      require("auto-session").setup {
        log_level = "error",
        auto_restore = not plain_start,
        auto_save = true,
        bypass_save_filetypes = {
          "dashboard"
        },
        pre_save_cmds = {
          function()
            local diffview = package.loaded.diffview and require("diffview.lib")
            if diffview and #diffview.views > 0 then vim.cmd("tabdo DiffviewClose") end
          end,
        },
        suppressed_dirs = {
          "~/",
          "~/Projects",
          "~/Downloads",
          "/",
        },
        post_restore_cmds = {
          function()
            -- Restore nvim-tree after a session is restored
            local nvim_tree_api = require("nvim-tree.api")
            nvim_tree_api.tree.open()
            nvim_tree_api.tree.change_root(vim.fn.getcwd())
            nvim_tree_api.tree.reload()
          end,
        },
      }
    end,
  },
}
