return {
  "numToStr/Comment.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    {
      "JoosepAlviste/nvim-ts-context-commentstring",
      opts = {
        enable_autocmd = false,
      },
    },
  },
  config = function()
    local comment = require("Comment")
    local create_pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook

    comment.setup({
      pre_hook = function(context)
        local ok, commentstring = pcall(create_pre_hook(), context)

        if not ok then
          return nil
        end

        return commentstring
      end,
    })
  end,
}
