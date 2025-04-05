return {
  "nvim-telescope/telescope.nvim",
  opts = function(_, opts)
    -- Extend the existing options
    return vim.tbl_deep_extend("force", opts, {
      defaults = {
        borderchars = { " ", " ", " ", " ", " ", " ", " ", " " },
      },
    })
  end,
}
