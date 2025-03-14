return {
  "jay-babu/mason-nvim-dap.nvim",
  dependencies = {
    "williamboman/mason.nvim",
    "mfussenegger/nvim-dap",
  },
  cmd = { "DapInstall", "DapUninstall" },
  config = function()
    local mason_nvim_dap = require("mason-nvim-dap")

    -- Setup mason-nvim-dap
    mason_nvim_dap.setup({
      -- List of adapters for mason to install

      ensure_installed = {
        "delve",
        "js",
      },
      automatic_installation = true,
    })
  end,
}
