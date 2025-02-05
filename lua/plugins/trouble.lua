return {
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      auto_open = false, -- do not automatically open Trouble when a diagnostic appears
      auto_close = true, -- close Trouble when no diagnostics remain
      auto_preview = false, -- do not automatically preview the location under the cursor
      use_diagnostic_signs = true, -- use vim.diagnostic.config() signs
      signs = {
        error = "",
        warning = "",
        hint = "",
        information = "",
        other = "",
      },
      modes = {
        test = {
          mode = "diagnostics",
          preview = {
            type = "split",
            relative = "win",
            position = "right",
            size = 0.3,
          },
        },
        diagnostics_buffer = {
          mode = "diagnostics", -- inherit from diagnostics mode
          filter = { buf = 0 }, -- filter diagnostics to the current buffer
        },
      },
    },
    cmd = "Trouble",
    keys = {
      {
        "<leader>dt",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>dT",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<leader>ds",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "Symbols (Trouble)",
      },
      {
        "<leader>dl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP Definitions/References (Trouble)",
      },
      {
        "<leader>dL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<leader>dQ",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)",
      },
    },
  },
}
