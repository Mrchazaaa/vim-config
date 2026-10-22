return {
  {
    "Wansmer/treesj",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    cmd = { "TSJToggle", "TSJSplit", "TSJJoin" },
    keys = {
      { "gS", "<cmd>TSJToggle<cr>", desc = "Toggle split/join node" },
      -- { "gJ", "<cmd>TSJJoin<cr>", desc = "Join node onto one line" },
    },
    opts = { use_default_keymaps = false },
  },
}
