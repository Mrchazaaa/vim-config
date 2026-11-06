return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "williamboman/mason.nvim", opts = { ui = { border = "rounded" } } },
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      -- CursorHold uses 'updatetime'; the default makes explanations feel absent.
      vim.opt.updatetime = 500

      vim.lsp.config("harper_ls", {
        filetypes = { "markdown", "text" },
        settings = {
          ["harper-ls"] = {
            dialect = "British",
            linters = { SpellCheck = true },
          },
        },
      })
      require("mason-lspconfig").setup({
        ensure_installed = { "harper_ls" },
        automatic_enable = { "harper_ls" },
      })

      vim.diagnostic.config({
        underline = true,
        virtual_text = false,
        signs = true,
        severity_sort = true,
        update_in_insert = false,
        float = { border = "rounded", source = true },
      })

      vim.api.nvim_create_user_command("WritingFix", function()
        vim.lsp.buf.code_action()
      end, { desc = "Show prose corrections at the cursor" })
      vim.api.nvim_create_user_command("WritingIssues", function()
        vim.diagnostic.setloclist()
      end, { desc = "List spelling, grammar, and style issues in this document" })

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("writing_lsp", { clear = true }),
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if not client or client.name ~= "harper_ls" then return end
          vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action,
            { buffer = args.buf, desc = "Writing corrections" })
          vim.keymap.set("n", "K", function()
            vim.diagnostic.open_float(nil, { scope = "cursor" })
          end, { buffer = args.buf, desc = "Explain writing issue" })
          vim.api.nvim_create_autocmd("CursorHold", {
            buffer = args.buf,
            group = "writing_lsp",
            callback = function()
              vim.diagnostic.open_float(nil, { focus = false, scope = "cursor" })
            end,
          })
        end,
      })
    end,
  },
}
