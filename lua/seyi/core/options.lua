vim.cmd("let g:netrw_liststyle = 3")

local opt = vim.opt

opt.relativenumber = true
opt.number = true

-- tabs & indentation
opt.tabstop = 2 -- 2 spaces for tabs (prettier default)
opt.shiftwidth = 2 -- 2 spaces for indent width
opt.expandtab = true -- expand tab to spaces
opt.autoindent = true -- copy indent from current line when starting new one

opt.wrap = true -- disable line wrapping

-- search settings
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true --  if you include mixed case in your search, assumes you want case-sensitive

opt.cursorline = true -- highlight current cursoe line

-- turn on termguicolours for tokyonight colorscheme to work
-- (have to use iterm2 or any other true color terminal
opt.termguicolors = true
opt.background = "dark" -- colorschemes that can be light or dark will be made dark
opt.signcolumn = "yes" -- show sign column so that text doesn't shift

-- backspace
opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position

-- clipboard
opt.clipboard:append("unnamedplus") -- use system clipboard as default register

-- split windows
opt.splitright = true -- split vertical windows to the right
opt.splitbelow = true -- split horizontal windows to the bottom

-- # Custom Options based on files and filetypes
-- Configure conceal level markdown
vim.api.nvim_create_augroup("ConcealSettings", { clear = true })

-- Set conceallevel=2 for Markdown and Obsidian Files
vim.api.nvim_create_autocmd("FileType", {
  group = "ConcealSettings",
  pattern = { "markdown", "obsidian" },
  callback = function()
    vim.opt_local.conceallevel = 2
  end,
  desc = "Set conceallevel to 2 for Markdown and Obsidian files",
})

-- Disable concealment for JSON files
vim.api.nvim_create_autocmd("FileType", {
  group = "ConcealSettings",
  pattern = "json",
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
  desc = "Disable concealment for JSON files",
})

-- Enable osc52 clipboard
-- This allows text yanked over ssh to be added to the system clipboard
vim.g.clipboard = {
  name = "OSC 52",
  copy = {
    ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
    ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
  },
  paste = {
    ["+"] = require("vim.ui.clipboard.osc52").paste("+"),
    ["*"] = require("vim.ui.clipboard.osc52").paste("*"),
  },
}

-- Settings for GO
vim.api.nvim_create_autocmd("FileType", {
  pattern = "make",
  callback = function()
    vim.opt_local.expandtab = false -- Use tabs, not spaces
    vim.opt_local.shiftwidth = 8 -- set indentation width
    vim.opt_local.softtabstop = 0 -- Disable soft tabl conversion
    vim.opt_local.tabstop = 8 -- key tab width as 8 spaces
  end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
    local params = vim.lsp.util.make_range_params()
    params.context = { only = { "source.organizeImports" } }
    -- buf_request_sync defaults to a 1000ms timeout. Depending on your
    -- machine and codebase, you may want longer. Add an additional
    -- argument after params if you find that you have to write the file
    -- twice for changes to be saved.
    -- E.g., vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
    for cid, res in pairs(result or {}) do
      for _, r in pairs(res.result or {}) do
        if r.edit then
          local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
          vim.lsp.util.apply_workspace_edit(r.edit, enc)
        end
      end
    end
    vim.lsp.buf.format({ async = false })
  end,
})
