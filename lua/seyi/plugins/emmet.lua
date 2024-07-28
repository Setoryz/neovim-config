return {
  "mattn/emmet-vim",
  config = function()
    vim.g.user_emmet_leader_key = "<C-e>" -- Set your preferred trigger key

    -- Extend Emmet settings for multiple filetypes
    vim.g.user_emmet_settings = {
      ["hbs"] = {
        extends = "html",
        filters = "html,css",
      },
      ["handlebars"] = {
        extends = "html",
        filters = "html,css",
      },
      ["html.handlebars"] = {
        extends = "html",
        filters = "html,css",
      },
    }

    -- Alternatively, you can set the filetype of .handlebars files to hbs or html
    vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
      pattern = "*.handlebars",
      callback = function()
        vim.bo.filetype = "handlebars"
      end,
    })
  end,
}
