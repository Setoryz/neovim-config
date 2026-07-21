return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  event = { "BufReadPre", "BufNewFile" },
  build = ":TSUpdate",
  dependencies = {
    "windwp/nvim-ts-autotag",
    "mustache/vim-mustache-handlebars",
    {
      "nvim-treesitter/nvim-treesitter-context",
      opts = {},
    },
  },
  config = function()
    local group = vim.api.nvim_create_augroup("seyi_treesitter", { clear = true })

    vim.api.nvim_create_autocmd("FileType", {
      group = group,
      callback = function(event)
        local filetype = vim.bo[event.buf].filetype
        local lang = vim.treesitter.language.get_lang(filetype)

        if not lang then
          return
        end

        if not pcall(vim.treesitter.language.add, lang) then
          return
        end

        pcall(vim.treesitter.start, event.buf, lang)

        vim.bo[event.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        vim.wo.foldmethod = "expr"
        vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
      end,
    })
  end,
}
