return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    "nvim-neotest/neotest-go",
    "nvim-neotest/neotest-jest",
  },
  config = function()
    local neotest = require("neotest")
    local neotest_go = require("neotest-go")
    local neotest_jest = require("neotest-jest")

    neotest.setup({
      adapters = {
        neotest_go({
          args = { "-coverprofile=coverage.out" },
        }),
        neotest_jest({
          jestCommand = "pnpm test --",
          jestConfigFile = "jest.config.ts",
          env = { CI = true },
          cwd = function(path)
            return vim.fn.getcwd()
          end,
        }),
      },
    })

    vim.keymap.set("n", "<Leader>tt", ':lua require("neotest").run.run()', { desc = "Run test" })
  end,
}
