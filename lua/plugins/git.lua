return {
  -- Git Signs
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
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
      {
        "]h",
        function()
          require("gitsigns").nav_hunk("next")
        end,
        desc = "Next git hunk",
      },
      {
        "[h",
        function()
          require("gitsigns").nav_hunk("prev")
        end,
        desc = "Previous git hunk",
      },
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
    lazy = false,
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
      { "<leader>gG", "<cmd>LazyGit<CR>", desc = "LazyGit" },
    },
    config = function()
      vim.g.lazygit_floating_window_winblend = 0
    end,
  },

  -- Git Graph
  {
    "isakbm/gitgraph.nvim",
    dependencies = { "sindrets/diffview.nvim" },
    opts = {
      symbols = {
        merge_commit = "",
        commit = "",
        merge_commit_end = "",
        commit_end = "",

        -- Advanced symbols
        GVER = "",
        GHOR = "",
        GCLD = "",
        GCRD = "╭",
        GCLU = "",
        GCRU = "",
        GLRU = "",
        GLRD = "",
        GLUD = "",
        GRUD = "",
        GFORKU = "",
        GFORKD = "",
        GRUDCD = "",
        GRUDCU = "",
        GLUDCD = "",
        GLUDCU = "",
        GLRDCL = "",
        GLRDCR = "",
        GLRUCL = "",
        GLRUCR = "",
      },
      format = {
        timestamp = "%H:%M:%S %d-%m-%Y",
        fields = { "hash", "timestamp", "author", "branch_name", "tag" },
      },
      hooks = {
        -- Check diff of a commit
        on_select_commit = function(commit)
          vim.notify("DiffviewOpen " .. commit.hash .. "^!")
          vim.cmd(":DiffviewOpen " .. commit.hash .. "^!")
        end,
        -- Check diff from commit a -> commit b
        on_select_range_commit = function(from, to)
          vim.notify("DiffviewOpen " .. from.hash .. "~1.." .. to.hash)
          vim.cmd(":DiffviewOpen " .. from.hash .. "~1.." .. to.hash)
        end,
      },
    },
    keys = {
      {
        "<leader>gl",
        function()
          require("gitgraph").draw({}, { all = true, max_count = 5000 })
        end,
        desc = "GitGraph - Draw",
      },
    },
  },

  -- NeoGit

  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
      "nvim-telescope/telescope.nvim",
    },
    config = true,
    keys = {
      { "<leader>gg", "<cmd>Neogit kind=split_below_all<CR>", desc = "Neogit" },
    },
  },
}
