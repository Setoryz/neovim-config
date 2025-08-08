return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    bigfile = { enabled = true },
    dashboard = {
      sections = {
        { section = "header" },
        { section = "keys", gap = 1, padding = 1 },
        { pane = 2, icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
        { pane = 2, icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
        {
          pane = 2,
          icon = " ",
          title = "Git Status",
          section = "terminal",
          enabled = function()
            local snacks = require("snacks")
            return snacks.git.get_root() ~= nil
          end,
          cmd = "git status --short --branch --renames",
          height = 5,
          padding = 1,
          ttl = 5 * 60,
          indent = 3,
        },
        { section = "startup" },
      },
    },
    explorer = {
      enabled = true,
    },
    indent = { enabled = true },
    input = { enabled = true },
    picker = {
      enabled = true,
      sources = {
        explorer = {
          hidden = true,
          ignored = false,
          win = {
            list = {
              wo = {
                number = true,
                relativenumber = true,
              },
            },
          },
          layout = {
            layout = {
              position = "right",
              width = 50,
            },
          },
        },
      },
    },
    notifier = { enabled = true },
    quickfile = { enabled = true },
    scope = { enabled = true },
    scroll = { enabled = true },
    statuscolumn = { enabled = true },
    words = { enabled = true },
  },
  config = function(_, opts)
    local snacks = require("snacks")
    snacks.setup(opts)

    -- Set number and relative number in snacks explorer
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "snacks_picker_list",
      callback = function()
        vim.opt_local.number = true
        vim.opt_local.relativenumber = true
      end,
    })

    -- Keymaps
    local keymap = vim.keymap
    local keymap_opts = {}

    --#region explorer
    -- keymap_opts.desc = "SN Toggle Explorer"
    -- keymap.set("n", "<leader>eo", function()
    --   snacks.explorer()
    -- end, keymap_opts)
    --
    keymap_opts.desc = "SN Open Explorer"
    keymap.set("n", "<leader>eo", function()
      local explorer_win = nil

      for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)
        local ft = vim.bo[buf].filetype
        if ft == "snacks_picker_list" then
          explorer_win = win
          break
        end
      end

      if vim.api.nvim_get_current_win() ~= explorer_win and explorer_win then
        vim.api.nvim_set_current_win(explorer_win)
      else
        Snacks.explorer()
      end
    end, keymap_opts)
    --#endregion

    --#region Find files
    keymap_opts.desc = "SN Smart find files"
    keymap.set("n", "<leader><space>f", function()
      snacks.picker.smart()
    end, keymap_opts)

    keymap_opts.desc = "SN find files in directory"
    keymap.set("n", "<leader>ff", function()
      snacks.picker.files()
    end, keymap_opts)

    keymap_opts.desc = "SN find recent files"
    keymap.set("n", "<leader>fr", function()
      snacks.picker.recent()
    end, keymap_opts)

    keymap_opts.desc = "SN find project"
    keymap.set("n", "<leader>fp", function()
      snacks.picker.projects()
    end, keymap_opts)

    keymap_opts.desc = "SN Find open files()"
    keymap.set("n", "<leader>f,", function()
      snacks.picker.buffers()
    end, keymap_opts)
    --#endregion

    --#region grep
    keymap_opts.desc = "SN Find string in files"
    keymap.set("n", "<leader>f/", function()
      snacks.picker.grep()
    end, keymap_opts)

    keymap_opts.desc = "SN Find word in files"
    keymap.set("n", "<leader>fw", function()
      snacks.picker.grep_word()
    end, keymap_opts)

    keymap_opts.desc = "SN Find selection in files"
    keymap.set("v", "<leader>fs", function()
      snacks.picker.grep_visual()
    end, keymap_opts)
    --#endregion

    --#region git
    keymap_opts.desc = "SN Open git stash"
    keymap.set("n", "<leader>gS", function()
      snacks.picker.git_stash()
    end, keymap_opts)

    keymap_opts.desc = "SN Open git branches"
    keymap.set("n", "<leader>gb", function()
      snacks.picker.git_branches()
    end, keymap_opts)

    keymap_opts.desc = "SN Open git status"
    keymap.set("n", "<leader>gs", function()
      snacks.picker.git_status()
    end, keymap_opts)

    keymap_opts.desc = "SN Open git stash"
    keymap.set("n", "<leader>gS", function()
      snacks.picker.git_stash()
    end, keymap_opts)

    keymap_opts.desc = "SN Open git log"
    keymap.set("n", "<leader>gl", function()
      snacks.picker.git_log()
    end, keymap_opts)

    keymap_opts.desc = "SN Open git log line"
    keymap.set("n", "<leader>gL", function()
      snacks.picker.git_log_line()
    end, keymap_opts)

    keymap_opts.desc = "SN Open git log file"
    keymap.set("n", "<leader>gf", function()
      snacks.picker.git_log_file()
    end, keymap_opts)

    keymap_opts.desc = "SN Open git diff (hunks)"
    keymap.set("n", "<leader>gd", function()
      snacks.picker.git_diff()
    end, keymap_opts)
    --#endregion

    --#region search
    keymap_opts.desc = "SN Search Registers"
    keymap.set("n", "<leader>fsr", function()
      snacks.picker.registers()
    end, keymap_opts)

    keymap_opts.desc = "SN Search in file"
    keymap.set("n", "<leader><space>/", function()
      snacks.picker.lines()
    end, keymap_opts)

    --#endregion

    keymap_opts.desc = "SN Open command history"
    keymap.set("n", "<leader>f:", function()
      snacks.picker.command_history()
    end, keymap_opts)

    keymap_opts.desc = "SN Open notification history"
    keymap.set("n", "<leader>fn", function()
      snacks.picker.notifications()
    end, keymap_opts)
  end,
}
