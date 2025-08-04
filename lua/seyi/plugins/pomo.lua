-- for pomodoro timers in Neovim
return {
  "epwalsh/pomo.nvim",
  version = "*", -- Recommended, use latest release instead of latest commit
  lazy = true,
  cmd = { "TimerStart", "TimerRepeat", "TimerSession" },
  dependencies = {
    -- Optional, but highly recommended if you want to use the "Default" timer
    "rcarriga/nvim-notify",
  },
  opts = {
    -- See below for full list of options 👇
    update_interval = 1000,
    sessions = {
      pomodoro = {
        { name = "Work", duration = "30m" },
        { name = "Short Break", duration = "5m" },
        { name = "Work", duration = "30m" },
        { name = "Short Break", duration = "5m" },
        { name = "Work", duration = "30m" },
        { name = "Short Break", duration = "5m" },
        { name = "Work", duration = "30m" },
        { name = "Long Break", duration = "15m" },
      },
    },
  },
}
