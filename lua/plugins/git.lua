return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      current_line_blame = true,
      current_line_blame_opts = {
        -- Show immediately with zero delay, just like VS Code
        delay = 0,
      },
    },
    keys = {
      -- Navigation
      {
        "]g",
        function()
          if vim.wo.diff then
            vim.cmd.normal { "]c", bang = true }
          else
            require("gitsigns").nav_hunk "next"
          end
        end,
        mode = { "n", "x", "o" },
        desc = "Next Git Hunk",
      },
      {
        "[g",
        function()
          if vim.wo.diff then
            vim.cmd.normal { "[c", bang = true }
          else
            require("gitsigns").nav_hunk "prev"
          end
        end,
        mode = { "n", "x", "o" },
        desc = "Previous Git Hunk / Diff Change",
      },

      -- Leader actions

      -- Stage / Reset (Normal & Visual Modes)
      { "<leader>gs", ":Gitsigns stage_hunk<CR>", mode = { "n", "v" }, desc = "Stage Hunk / Selection" },
      { "<leader>gr", ":Gitsigns reset_hunk<CR>", mode = { "n", "v" }, desc = "Reset Hunk / Selection" },

      -- Information & Preview
      {
        "<leader>gp",
        function()
          require("gitsigns").preview_hunk()
        end,
        desc = "Preview Hunk Inline",
      },
      {
        "<leader>gb",
        function()
          require("gitsigns").blame_line { full = true }
        end,
        desc = "Full Blame Popup",
      },
      {
        "<leader>gd",
        function()
          require("gitsigns").diffthis()
        end,
        desc = "Diff Hunk Against Index",
      },

      -- Buffer Level
      {
        "<leader>gS",
        function()
          require("gitsigns").stage_buffer()
        end,
        desc = "Stage Entire Buffer",
      },
      {
        "<leader>gR",
        function()
          require("gitsigns").reset_buffer()
        end,
        desc = "Reset Entire Buffer",
      },

      -- Toggles & Quickfix
      {
        "<leader>gt",
        function()
          require("gitsigns").toggle_current_line_blame()
        end,
        desc = "Toggle Line Blame",
      },
      {
        "<leader>gq",
        function()
          require("gitsigns").setqflist()
        end,
        desc = "Send All Hunks to Quickfix",
      },

      -- Text objects
      { "ig", ":<C-U>Gitsigns select_hunk<CR>", mode = { "o", "x" }, desc = "Select Git Hunk" },
      { "ag", ":<C-U>Gitsigns select_hunk<CR>", mode = { "o", "x" }, desc = "Select Git Hunk" },
    },
  },
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    cmd = "Neogit",
    keys = {
      { "<leader>gg", "<cmd>Neogit<cr>", desc = "Neogit UI" },
    },
    opts = {
      kind = "floating",
    },
  },
}
