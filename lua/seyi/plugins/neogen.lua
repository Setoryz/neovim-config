-- Plugin to make generating annotations and docstrings easier
return {
  "danymat/neogen",
  config = function()
    local neogen = require("neogen")

    neogen.setup({ snippet_engine = "luasnip" })

    local opts = { noremap = true, silent = true }
    vim.api.nvim_set_keymap("n", "<leader>nfd", ":lua require('neogen').generate()<CR>", opts)
  end,
}
