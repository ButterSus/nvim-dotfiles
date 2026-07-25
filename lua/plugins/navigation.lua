-- Anything related to moving around files, buffers, and directories

local has_local, local_settings = pcall(require, "local_settings")
local file_explorer = (has_local and local_settings.file_explorer) or "oil"

return {
  -- 1. Oil File Explorer
  {
    "stevearc/oil.nvim",
    enabled = file_explorer == "oil",
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

  -- 2. Yazi File Explorer
  {
    "mikavilpas/yazi.nvim",
    enabled = file_explorer == "yazi",
    version = "*", -- use the latest stable version
    event = "VeryLazy",
    dependencies = {
      { "nvim-lua/plenary.nvim", lazy = true },
    },
    keys = {
      {
        "<leader>e",
        "<cmd>Yazi<cr>",
        desc = "Open yazi at the current file",
      },
      {
        "<leader>E",
        "<cmd>Yazi cwd<cr>",
        desc = "Open yazi in nvim's working directory",
      },
    },
    opts = {
      open_for_directories = true,
    },
  },

  -- 3. Mini.Files Explorer
  {
    "nvim-mini/mini.files",
    enabled = file_explorer == "mini.files",
    version = false,
    opts = {},
    keys = {
      {
        "<leader>e",
        function()
          require("mini.files").open(vim.api.nvim_buf_get_name(0), true)
        end,
        desc = "Open mini.files (current file)",
      },
      {
        "<leader>E",
        function()
          require("mini.files").open(vim.fn.getcwd(), true)
        end,
        desc = "Open mini.files (cwd)",
      },
    },
  },
}
