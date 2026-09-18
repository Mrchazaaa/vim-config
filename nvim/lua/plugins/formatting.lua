return {
  {
    "stevearc/conform.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "ruff_format", "black" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        json = { "prettier" },
        yaml = { "yamlfmt", "prettier" },
        sh = { "shfmt" },
      },
      notify_on_error = true,
      default_format_opts = { lsp_format = "fallback" },
    },
    config = function(_, opts)
      require("conform").setup(opts)

      vim.api.nvim_create_user_command("Format", function(args)
        local format_opts = {
          async = true,
          lsp_fallback = true,
        }

        if args.range > 0 then
          local srow, scol = unpack(vim.api.nvim_buf_get_mark(0, "<"))
          local erow, ecol = unpack(vim.api.nvim_buf_get_mark(0, ">"))
          format_opts.range = {
            start = { srow - 1, scol },
            ["end"] = { erow - 1, ecol },
          }
        end

        require("conform").format(format_opts)
      end, {
        range = true,
        desc = "Format buffer or selected range with Conform",
      })
    end,
  },
}
