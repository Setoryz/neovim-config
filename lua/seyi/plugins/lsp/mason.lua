return {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  config = function()
    -- import mason
    local mason = require("mason")

    -- import mason-lspconfig
    local mason_lspconfig = require("mason-lspconfig")

    local mason_tool_installer = require("mason-tool-installer")

    -- enable mason and configure icons
    mason.setup({
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    })

    mason_lspconfig.setup({
      -- list of servers for mason to install
      ensure_installed = {
        "ansiblels",
        "cssls",
        "emmet_ls",
        "html",
        "graphql",
        "jsonls",
        "lua_ls",
        "prismals",
        "pyright",
        "quick_lint_js",
        "svelte",
        "tailwindcss",
        "ts_ls",
        "terraformls",
        "yamlls",
        "gopls",
      },
    })

    mason_tool_installer.setup({
      ensure_installed = {
        "ansible-lint", -- ansible linter
        "prettierd", -- prettierd formatter
        "prettier", -- prettier formatter
        "stylua", -- python formatter
        "isort", -- python formatter
        "black", -- python formatter
        "pylint", -- python linter
        "eslint_d", -- js linter
        "tflint", -- terraform linter
        "yamlfmt", -- yaml, ansible
      },
    })
  end,
}
