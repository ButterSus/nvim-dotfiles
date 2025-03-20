return {
  -- Replace nvim-notify with fidget.nvim
  { "rcarriga/nvim-notify", enabled = false },
  {
    "ButterSus/fidget.nvim",
    branch = "main",
    dependencies = { "nvim-telescope/telescope.nvim" },
    event = "VeryLazy",
    opts = {},
    config = function(_, opts)
      local fidget = require "fidget"
      fidget.setup(opts)
      vim.notify = fidget.notify

      -- Then load the extension
      require("telescope").load_extension "fidget"
    end,
    keys = {
      {
        "<leader>fn",
        function() require("telescope").extensions.fidget.fidget() end,
        desc = "Telescope: List all notifications",
      },
    },
  },
}
