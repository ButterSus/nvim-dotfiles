-- Anything related to moving around files, buffers, and directories

return {
  {
    "stevearc/oil.nvim",
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {},
    dependencies = { { "nvim-mini/mini.icons", opts = {} } },
    -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
    lazy = false,
    keys = {
      {
        "<leader>e",
        function()
          require("oil").open()
        end,
        desc = "Open File Browser",
      },
    },
  },
}
