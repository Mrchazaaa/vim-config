return {
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    lazy = false, -- Hook buffers before LspAttach.
    priority = 1000,
    opts = {
      options = { multilines = { enabled = true, always_show = true } },
    },
  },
}
