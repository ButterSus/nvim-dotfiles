return {
  {
    "zaldih/themery.nvim",
    lazy = false,
    opts = {
      themes = {"gruvbox"},
      livePreview = true
    },
    keys = {
      { "<leader>ct", "<cmd>Themery<CR>", mode = "n" }
    }
  }
}
