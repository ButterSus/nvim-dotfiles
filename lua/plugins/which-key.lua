return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    opts = {
      plugins = {
        marks = true,
        registers = true,
        spelling = {
          enabled = true,
          suggestions = 20,
        },
      },
      win = {
        border = "rounded",
        padding = { 1, 2, 1, 2 },
      },
      layout = {
        height = { min = 4, max = 25 },
        width = { min = 20, max = 50 },
        spacing = 3,
        align = "center",
      },
      show_help = true,
      show_keys = true,
      triggers = {
        { "<auto>", mode = "nixsotc" },
        { "a", mode = { "n", "v" } },
      },
      filter = function(prefix)
        return true -- show everything
      end,
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)

      wk.add({
        mode = { "n", "v" },
        {
          { "<leader>c", group = "config/color" },
          { "<leader>d", group = "diagnostics" },
          { "<leader>j", group = "move down" },
          { "<leader>k", group = "move up" },
          { "<leader>o", group = "oil/open" },
          { "<leader>r", group = "rename/refactor" },
          { "<leader>t", group = "toggle/tab" },
          { "<leader>x", group = "close" },
          { "<leader>z", group = "zen" },
        },
      })

      -- Register non-leader prefixes separately
      wk.add({
        mode = { "n", "v" },
        {
          { "[", group = "prev" },
          { "]", group = "next" },
          { "g", group = "goto" },
        },
      })
    end,
  },
}

