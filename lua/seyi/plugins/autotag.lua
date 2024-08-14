return {
  "windwp/nvim-ts-autotag",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
  config = function()
    local nvim_ts_autotag = require("nvim-ts-autotag")

    nvim_ts_autotag.setup()
  end,
}
