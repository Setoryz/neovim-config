-- Show test coverage in Neovim using the nvim-coverage plugin.
-- This plugin is useful for viewing code coverage reports directly in the editor.
-- supports js/ts with jest
return {
  "andythigpen/nvim-coverage",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    require("coverage").setup({
      lang = {
        go = {
          coverage_file = vim.fn.getcwd() .. "/coverage.out",
        },
      },
    })
  end,
}
