return {
  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    dependencies = {
      "mfussenegger/nvim-dap",
      {
        "rcarriga/nvim-dap-ui",
        dependencies = { "nvim-neotest/nvim-nio" },
      },
    },
    config = function()
      local dap, dapui = require("dap"), require("dapui")

      -- Use debugpy from Mason's virtualenv (installed via :MasonInstall debugpy)
      local mason = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/Scripts/python.exe"
      require("dap-python").setup(vim.fn.filereadable(mason) == 1 and mason or "python")

      dapui.setup()
      dap.listeners.before.attach.dapui_config = dapui.open
      dap.listeners.before.launch.dapui_config = dapui.open
      dap.listeners.before.event_terminated.dapui_config = dapui.close
      dap.listeners.before.event_exited.dapui_config = dapui.close

      vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "DAP breakpoint" })
      vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "DAP continue/start" })
      vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "DAP step into" })
      vim.keymap.set("n", "<leader>do", dap.step_over, { desc = "DAP step over" })
      vim.keymap.set("n", "<leader>dO", dap.step_out, { desc = "DAP step out" })
      vim.keymap.set("n", "<leader>dq", dap.terminate, { desc = "DAP terminate" })
      vim.keymap.set("n", "<leader>du", dapui.toggle, { desc = "DAP UI toggle" })
    end,
  },
}
