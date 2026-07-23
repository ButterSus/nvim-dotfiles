-- Priority 1000 is needed to prevent visual flash,
-- since theme is most visually distinct plugin

return {
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    lazy = false,
    config = function(_, opts)
      require("gruvbox").setup(opts)
      vim.cmd.colorscheme "gruvbox"
    end,
  },
}
