return {
  { "sheerun/vim-polyglot", lazy = false, priority = 1000 },
  {
    "pearofducks/ansible-vim",
    ft = { "yaml", "yaml.ansible" },
    config = function()
      -- Set yaml.ansible for files in `playbooks/` directory
      vim.api.nvim_create_autocmd({ "BufRead", "BufEnter", "BufNewFile" }, {
        pattern = "*/playbooks/*.{yml,yaml}",
        callback = function()
          vim.bo.filetype = "yaml.ansible"
        end,
      })
    end,
  },
}
