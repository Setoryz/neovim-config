local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
local isHeadlessTest = vim.env.NVIM_HEADLESS_TEST == "1"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", --latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  { import = "seyi.plugins" },
  { import = "seyi.plugins.lsp" },
  { import = "seyi.plugins.dap" },
  { import = "seyi.plugins.test" },
}, {
  checker = {
    enabled = not isHeadlessTest and vim.env.NVIM_DISABLE_PLUGIN_CHECKER ~= "1",
    notify = false,
  },
  change_detection = {
    notify = false,
  },
})
