return {
  -- Animates curoser with smear effect in all terminals
  {
    "sphamba/smear-cursor.nvim",
    opts = {
      stiffness = 0.5,
      trailing_stiffness = 0.49,
      never_draw_over_target = false,
    },
  },
  -- Support smooth scrolling
  {
    "karb94/neoscroll.nvim",
    opts = {},
  },
  -- This plugin allows to see motions both vertical and horizontal to navigate your current buffer
  {
    "tris203/precognition.nvim",
    opts = {},
  },
}
