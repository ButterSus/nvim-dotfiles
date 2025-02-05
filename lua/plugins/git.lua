return {
  -- Git Signs
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      -- Define custom highlight groups using new API
      vim.api.nvim_set_hl(0, "GitSignsAddNr", { fg = "#d4d4d4", bg = "#2a4d3e" })
      vim.api.nvim_set_hl(0, "GitSignsChangeNr", { fg = "#d4d4d4", bg = "#34415d" })
      vim.api.nvim_set_hl(0, "GitSignsDeleteNr", { fg = "#d4d4d4", bg = "#55393d" })
      vim.api.nvim_set_hl(0, "GitSignsChangedeleteNr", { link = "GitSignsChangeNr" })
      vim.api.nvim_set_hl(0, "GitSignsTopdeleteNr", { link = "GitSignsDeleteNr" })
      vim.api.nvim_set_hl(0, "GitSignsUntrackedNr", { link = "GitSignsAddNr" })

      require("gitsigns").setup({
        signs = {
          add = { text = "▎" },
          change = { text = "▎" },
          delete = { text = "" },
          topdelete = { text = "" },
          changedelete = { text = "▎" },
          untracked = { text = "▎" },
        },
        signcolumn = false, -- Disable signs in the signcolumn
        numhl = true, -- Enable line number highlighting
        linehl = false,
        word_diff = false,
        watch_gitdir = {
          interval = 1000,
          follow_files = true,
        },
        attach_to_untracked = true,
        current_line_blame = false,
        current_line_blame_opts = {
          virt_text = true,
          virt_text_pos = "eol",
          delay = 1000,
          ignore_whitespace = false,
        },
        current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
        sign_priority = 6,
        update_debounce = 100,
        status_formatter = nil,
        max_file_length = 40000,
        preview_config = {
          border = "rounded",
          style = "minimal",
          relative = "cursor",
          row = 0,
          col = 1,
        },
      })
    end,
    keys = {
      { "]h", ":Gitsigns next_hunk<CR>", desc = "Next git hunk" },
      { "[h", ":Gitsigns prev_hunk<CR>", desc = "Previous git hunk" },
      { "<leader>gb", ":Gitsigns toggle_current_line_blame<CR>", desc = "Toggle git blame" },
      { "<leader>gd", ":Gitsigns diffthis<CR>", desc = "Git diff" },
      { "<leader>gp", ":Gitsigns preview_hunk<CR>", desc = "Preview git hunk" },
      { "<leader>gr", ":Gitsigns reset_hunk<CR>", desc = "Reset git hunk" },
      { "<leader>gR", ":Gitsigns reset_buffer<CR>", desc = "Reset git buffer" },
      { "<leader>gs", ":Gitsigns stage_hunk<CR>", desc = "Stage git hunk" },
      { "<leader>gS", ":Gitsigns stage_buffer<CR>", desc = "Stage git buffer" },
      { "<leader>gu", ":Gitsigns undo_stage_hunk<CR>", desc = "Undo stage git hunk" },
    },
  },

  -- Diff View
  {
    "sindrets/diffview.nvim",
    cmd = {
      "DiffviewOpen",
      "DiffviewClose",
      "DiffviewToggleFiles",
      "DiffviewFocusFiles",
      "DiffviewRefresh",
    },
    keys = {
      { "<leader>do", ":DiffviewOpen<CR>", desc = "Diffview Open" },
      { "<leader>dc", ":DiffviewClose<CR>", desc = "Diffview Close" },
      { "<leader>dp", ":DiffviewToggleFiles<CR>", desc = "Diffview Toggle Files" },
    },
    config = function()
      require("diffview").setup({
        diff_binaries = false, -- disable binary diffing
        enhanced_diff_hl = true,
        use_icons = true, -- Requires nvim-web-devicons
        file_panel = {
          listing_style = "tree", -- Use "tree" view for file panel
          tree_options = { flatten = true },
        },
        key_bindings = {
          -- You can customize or disable default keybindings here:
          disable_defaults = false,
          view = {
            ["q"] = ":DiffviewClose<CR>",
          },
        },
      })
    end,
  },

  -- LazyGit
  {
    "kdheepak/lazygit.nvim",
    cmd = "LazyGit",
    keys = {
      { "<leader>gg", "<cmd>LazyGit<CR>", desc = "LazyGit" },
    },
    config = function()
      -- Optionally: adjust lazygit's floating window transparency
      vim.g.lazygit_floating_window_winblend = 0
      -- More lazygit configuration can be added here if needed
    end,
  },
}
