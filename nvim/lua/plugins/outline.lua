return {
  {
    "stevearc/aerial.nvim",
    branch = "nvim-0.11",
    cmd = { "AerialToggle", "AerialOpen", "AerialClose", "AerialInfo" },
    keys = {
      { "<leader>a", "<Cmd>AerialToggle<CR>", desc = "Toggle code outline" },
    },
    opts = {
      highlight_on_hover = true,
      filter_kind = {
        "Class", "Constructor", "Enum", "Field", "Function", "Interface",
        "Module", "Method", "Namespace", "Property", "Struct",
      },
    },
  },
}
