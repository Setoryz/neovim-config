return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons", "SmiteshP/nvim-navic" },
  config = function()
    local lualine = require("lualine")
    local lazy_status = require("lazy.status") -- to configure lazy pending updates count
    local isHeadlessTest = vim.env.NVIM_HEADLESS_TEST == "1"

    local colors = {
      blue = "#65D1FF",
      green = "#3EFFDC",
      violet = "#FF61EF",
      yellow = "#FFDA7B",
      red = "#FF4A4A",
      fg = "#C3CCDC",
      bg = "#112638",
      inactive_bg = "#2C3043",
    }

    local my_lualine_theme = {
      normal = {
        a = { bg = colors.blue, fg = colors.bg, gui = "bold" },
        b = { bg = colors.bg, fg = colors.fg },
        c = { bg = colors.bg, fg = colors.fg },
      },
      insert = {
        a = { bg = colors.green, fg = colors.bg, gui = "bold" },
        b = { bg = colors.bg, fg = colors.fg },
        c = { bg = colors.bg, fg = colors.fg },
      },
      visual = {
        a = { bg = colors.violet, fg = colors.bg, gui = "bold" },
        b = { bg = colors.bg, fg = colors.fg },
        c = { bg = colors.bg, fg = colors.fg },
      },
      command = {
        a = { bg = colors.yellow, fg = colors.bg, gui = "bold" },
        b = { bg = colors.bg, fg = colors.fg },
        c = { bg = colors.bg, fg = colors.fg },
      },
      replace = {
        a = { bg = colors.red, fg = colors.bg, gui = "bold" },
        b = { bg = colors.bg, fg = colors.fg },
        c = { bg = colors.bg, fg = colors.fg },
      },
      inactive = {
        a = { bg = colors.inactive_bg, fg = colors.semilightgray, gui = "bold" },
        b = { bg = colors.inactive_bg, fg = colors.semilightgray },
        c = { bg = colors.inactive_bg, fg = colors.semilightgray },
      },
    }

    local last_update = 0
    local cached_result = " --"
    local updating = false
    local wakatime_cli = vim.fn.expand("~/.wakatime/wakatime-cli")

    local function refresh_lualine()
      local ok, lualine_instance = pcall(require, "lualine")
      if not ok then
        return
      end

      pcall(lualine_instance.refresh)
    end

    --- Function to get wakatime stats for current day
    --- @returns string
    local function refresh_wakatime_daily_stats()
      if isHeadlessTest or updating then
        return
      end

      updating = true

      vim.system({ wakatime_cli, "--today" }, { text = true, timeout = 2000 }, function(result)
        local next_result = cached_result

        if result.code == 0 and type(result.stdout) == "string" and result.stdout ~= "" then
          next_result = " " .. result.stdout:gsub("\n", ""):gsub("^.*:%s*", "")
        end

        vim.schedule(function()
          cached_result = next_result
          last_update = os.time()
          updating = false
          refresh_lualine()
        end)
      end)
    end

    local function get_wakatime_daily_stats()
      if isHeadlessTest then
        return cached_result
      end

      local now = os.time()
      if now - last_update > 300 and not updating then
        refresh_wakatime_daily_stats()
      end

      return cached_result
    end

    vim.api.nvim_create_autocmd("VimEnter", {
      callback = refresh_wakatime_daily_stats,
      once = true,
    })

    --- Get current cursor position for statusline and winbar display
    ---@return string
    local function get_cursor_position()
      local pos = vim.api.nvim_win_get_cursor(0)
      local line = vim.api.nvim_get_current_line()
      local col = line:sub(1, pos[2]):len()
      return " " .. col .. " : " .. pos[1]
    end

    -- configure lualine modified theme
    lualine.setup({
      options = {
        theme = my_lualine_theme,
        section_separators = { left = "", right = "" },
        component_separators = { left = "", right = "" },
        globalstatus = true,
      },
      -- sections and plugins that need update
      sections = {
        lualine_c = {
          "filename",
          {
            function()
              return get_cursor_position()
            end,
            color = { bg = colors.bg, fg = colors.violet },
          },
          {
            function()
              return require("nvim-navic").get_location()
            end,
            cond = function()
              return require("nvim-navic").is_available()
            end,
          },
        },
        lualine_x = {
          {
            function()
              return get_wakatime_daily_stats()
            end,
          },
        },
        lualine_y = {
          {
            lazy_status.updates,
            cond = lazy_status.has_updates,
            color = { fg = "#FF9E64" },
          },
          { "encoding" },
          { "fileformat" },
          { "filetype" },
        },
        lualine_z = { "tabs" },
      },
      refresh = {
        statusline = 100,
        tabline = 100,
        winbar = 100,
      },
      winbar = {
        lualine_c = {
          {
            "filename",
            path = 1,
            color = { bg = colors.blue, fg = colors.bg, gui = "bold" },
          },
          {
            function()
              return get_cursor_position()
            end,
            color = { bg = colors.bg, fg = colors.violet },
          },
        },
      },
      inactive_winbar = {
        lualine_c = {
          {
            "filename",
            path = 1,
          },
          {
            function()
              return get_cursor_position()
            end,
          },
        },
      },
    })
  end,
}
