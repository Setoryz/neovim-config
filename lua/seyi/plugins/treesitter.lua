return {
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPre", "BufNewFile" },
  build = ":TSUpdate",
  dependencies = {
    "windwp/nvim-ts-autotag",
    "mustache/vim-mustache-handlebars",
  },
  config = function()
    -- import nvim-treesitter plugin
    local treesitter = require("nvim-treesitter.configs")

    -- configure treesitter
    treesitter.setup({
      -- enable syntax highlighting
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      -- enable indentation
      indent = { enable = true },

      -- enable autotagging (w/ nvim-ts-autotag plugin)
      -- This now has to be done with autotag directly and i moved this to autotag.lua
      --autotag = {
      --  enable = true,
      --},

      -- Automatically install missing parsers when entering buffer
      -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
      auto_install = true,

      -- Install parsers synchronously (only applied to `ensure_installed`)
      sync_install = false,

      ignore_install = {},

      -- ensure these language parsers are installed
      ensure_installed = {
        "json",
        "javascript",
        "typescript",
        "tsx",
        "yaml",
        "xml",
        "html",
        "css",
        "scss",
        "prisma",
        "markdown",
        "markdown_inline",
        "svelte",
        "graphql",
        "bash",
        "lua",
        "vim",
        "dockerfile",
        "gitignore",
        "query",
        "vimdoc",
        "c",
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
    })
  end,
}
