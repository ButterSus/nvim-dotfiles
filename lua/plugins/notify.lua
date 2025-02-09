return {
  {
    "rcarriga/nvim-notify",
    opts = {
      render = "wrapped-compact",
    },
    config = function(_, opts)
      require("notify").setup(opts)
      vim.notify = require("notify")
    end,
  },
}
