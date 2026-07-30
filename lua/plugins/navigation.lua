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

  -- Mini Buf Remove
  {
    "echasnovski/mini.bufremove",
    event = "VeryLazy",
    keys = {
      {
        "<leader>bc",
        function()
          require("mini.bufremove").delete(0, false)
        end,
        { desc = "Close Buffer" },
      },
      {
        "<leader>bC",
        function()
          require("mini.bufremove").delete(0, true)
        end,
        { desc = "Force Close Buffer" },
      },
      {
        "<leader>ba",
        function()
          for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if vim.bo[buf].buflisted then
              require("mini.bufremove").delete(buf, false)
            end
          end
        end,
        { desc = "Close All Buffers" },
      },
      {
        "<leader>bo",
        function()
          local current = vim.api.nvim_get_current_buf()
          for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if buf ~= current and vim.bo[buf].buflisted then
              require("mini.bufremove").delete(buf, false)
            end
          end
        end,
        { desc = "Close Other Buffers" },
      },
      {
        "<leader>bl",
        function()
          local current = vim.api.nvim_get_current_buf()
          local bufs = vim.tbl_filter(function(buf)
            return vim.bo[buf].buflisted
          end, vim.api.nvim_list_bufs())
          local current_idx = vim.fn.index(bufs, current)
          for i = current_idx + 2, #bufs do -- +2: skip current itself, list is 1-indexed
            require("mini.bufremove").delete(bufs[i], false)
          end
        end,
        { desc = "Close Buffers to the Right" },
      },
      {
        "<leader>bh",
        function()
          local current = vim.api.nvim_get_current_buf()
          local bufs = vim.tbl_filter(function(buf)
            return vim.bo[buf].buflisted
          end, vim.api.nvim_list_bufs())
          local current_idx = vim.fn.index(bufs, current)
          for i = current_idx, 1, -1 do -- count down from just before current to the start
            require("mini.bufremove").delete(bufs[i], false)
          end
        end,
        { desc = "Close Buffers to the Left" },
      },
    },
    opts = {},
  },
}
