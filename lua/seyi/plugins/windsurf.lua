return {
  {
    "Exafunction/windsurf.nvim",
    enabled = vim.env.NVIM_HEADLESS_TEST ~= "1",
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "hrsh7th/nvim-cmp",
    },
    config = function()
      require("codeium").setup({})
    end,
  },
  {
    "Exafunction/windsurf.vim",
    enabled = vim.env.NVIM_HEADLESS_TEST ~= "1",
    event = "VeryLazy",
  },
}
