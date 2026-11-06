return {
  on_attach = function(_, bufnr)
    require("features.writing").attach(bufnr)
  end,
  filetypes = { "markdown", "text" },
  settings = {
    ["harper-ls"] = {
      dialect = "British",
      linters = { SpellCheck = true, UseTitleCase = false },
    },
  },
}
