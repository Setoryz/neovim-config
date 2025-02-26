return {
  "folke/noice.nvim",
  event = "VeryLazy",
  opts = {
    -- options
  },
  dependencies = {
    -- if you lazy-load any plugin below, make sure to add proper `modules="..."` entries
    "MunifTanjim/nui.nvim",
    -- OPTIONAL: `nvim-notify` is only needed, if you want to use the notification view.
    "rcarriga/nvim-notify",
  },
  config = function()
    local noice = require("noice")
    local nvim_notify = require("notify")

    noice.setup({
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = false, -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = false, -- add a border to hover docs and signature help,
      },
    })

    nvim_notify.setup({
      background_colour = "NotifyBackground",
      fps = 60,
      icons = {
        DEBUG = "",
        ERROR = "",
        INFO = "",
        TRACE = "✎",
        WARN = "",
      },
      level = 2,
      minimum_width = 50,
      render = "default",
      stages = "fade_in_slide_out",
      time_formats = {
        notification = "%T",
        notification_history = "%FT%T",
      },
      timeout = 8000,
      top_down = false,
    })
  end,
}
