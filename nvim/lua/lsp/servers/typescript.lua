return {
  -- Run for .vue too, since vue_ls isn't installable right now.
  filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
  settings = {
    javascript = { inlayHints = { includeInlayParameterNameHints = "all" } },
    typescript = { inlayHints = { includeInlayParameterNameHints = "all" } },
  },
}
