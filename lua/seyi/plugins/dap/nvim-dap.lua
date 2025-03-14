return {
  -- nvim-dap: Debug Adapter Protocol client implementation
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "jay-babu/mason-nvim-dap.nvim",
    { "theHamsta/nvim-dap-virtual-text", config = true }, -- Shows constant or variable value on the line
  },
  config = function()
    -- import required modules
    local dap = require("dap")
    local dapui = require("dapui")

    -- Define signs for breakpoint
    vim.fn.sign_define("DapBreakpoint", { text = "🔴", texthl = "", linehl = "", numhl = "" })

    dap.adapters["pwa-node"] = {
      type = "server",
      host = "localhost",
      port = "${port}",
      executable = {
        command = "node",
        args = {
          vim.fn.stdpath("data") .. "/dap_adapters/js-debug/src/dapDebugServer.js",
          "${port}",
        },
      },
    }

    local js_based_languages = { "typescript", "javascript", "javascriptreact", "typescriptreact" }
    for _, language in ipairs(js_based_languages) do
      dap.configurations[language] = {
        {
          name = "Next.js: debug server-side",
          type = "pwa-node",
          request = "attach",
          port = 9231,
          skipFiles = { "<node_internals>/**", "node_modules/**" },
          cwd = "${workspaceFolder}",
        },
      }
    end

    -- Setup keymaps for debugging
    local keymap = vim.keymap -- for conciseness
    local opts = { noremap = true, silent = true }

    -- Define keymaps with descriptions
    opts.desc = "Continue"
    keymap.set("n", "<leader>dbc", dap.continue, opts)

    opts.desc = "Step Over"
    keymap.set("n", "<leader>dbo", dap.step_over, opts)

    opts.desc = "Step Into"
    keymap.set("n", "<leader>dbi", dap.step_into, opts)

    opts.desc = "Step Out"
    keymap.set("n", "<leader>dbx", dap.step_out, opts)

    opts.desc = "Toggle Breakpoint"
    keymap.set("n", "<leader>dbb", dap.toggle_breakpoint, opts)

    opts.desc = "Set Breakpoint"
    keymap.set("n", "<leader>dbd", dap.set_breakpoint, opts)

    opts.desc = "Open REPL"
    keymap.set("n", "<leader>dbr", dap.repl.open, opts)

    opts.desc = "Run Last"
    keymap.set("n", "<leader>dbl", dap.run_last, opts)

    opts.desc = "Toggle DAP UI"
    keymap.set("n", "<leader>dbt", function()
      dapui.toggle()
    end, opts)
  end,
}
