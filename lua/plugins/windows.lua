return {
  {
    "sindrets/winshift.nvim",
    event = "VeryLazy",
    config = function()
      require("winshift").setup({
        highlight_mode = "temporarily",
      })
    end,
    keys = {
      { "<leader>wm", "<cmd>WinShift<cr>", desc = "Enter window shift mode" },
      { "<c-s-h>", "<cmd>WinShift left<cr>", desc = "Move window left" },
      { "<c-s-j>", "<cmd>WinShift down<cr>", desc = "Move window down" },
      { "<c-s-k>", "<cmd>WinShift up<cr>", desc = "Move window up" },
      { "<c-s-l>", "<cmd>WinShift right<cr>", desc = "Move window right" },
    },
  },
}
