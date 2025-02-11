return {
  {
    "j-hui/fidget.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    event = "VeryLazy",
    opts = {},
    config = function(_, opts)
      local fidget = require("fidget")
      fidget.setup(opts)
      vim.notify = fidget.notify
      require("telescope").load_extension("fidget")
    end,
  },
}
