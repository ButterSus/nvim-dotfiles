return {
  {
    "sindrets/winshift.nvim",
    config = function()
      require("winshift").setup({
        highlight_mode = "temporarily",
      })
    end,
    keys = {
      { "<leader>wm", "<cmd>WinShift<cr>", desc = "Enter window shift mode" },
      { "<leader>ws", "<cmd>WinShift swap<cr>", desc = "Swap windows" },
    },
  },
}
