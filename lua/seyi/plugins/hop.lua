return {
  "smoka7/hop.nvim",
  opts = {
    multi_windows = true,
    keys = "etovxqpdygfblzhckisuran",
    uppercase_labels = true,
  },
  keys = {
    {
      "<leader>hh",
      function()
        require("hop").hint_words()
      end,
      mode = { "n", "x", "o" },
    },
  },
}
