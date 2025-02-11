return {
  -- Neoscroll
  {
    "karb94/neoscroll.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      mappings = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "<C-y>", "<C-e>", "zt", "zz", "zb" },
      respect_scrolloff = true,
      cursor_scrolls_alone = false,
      easing = "quadratic",
      stop_eof = true,
    },
  },
}

