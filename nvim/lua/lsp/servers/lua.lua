return vim.tbl_deep_extend("force", require("lsp-zero").nvim_lua_ls(), {
  settings = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
      format = {
        defaultConfig = {
          indent_style = "space",
          indent_size = "2",
          quote_style = "double",
          max_line_length = "100",
        },
      },
    },
  },
})
