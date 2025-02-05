return {
  -- Using HJKL keys with TMUX
  {
    "christoomey/vim-tmux-navigator",
    lazy = false,
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
      "TmuxNavigatorProcessList",
    },
    keys = {
      { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
      { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
      { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
      { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
    },
  },

  -- Better netrw alternative
  {
    "stevearc/oil.nvim",
    lazy = false,
    opts = {
      default_file_explorer = true,
      keymaps = {
        -- Remove old mappings
        ["<C-s>"] = false,
        ["<C-h>"] = false,
        ["<C-t>"] = false,
        ["<C-p>"] = false,
        ["<C-c>"] = false,
        ["<C-l>"] = false,
        ["-"] = false,
        ["_"] = false,

        -- Mappings
        ["g?"] = { "actions.show_help", mode = "n" },
        ["<CR>"] = "actions.select",
        ["<a-s>"] = { "actions.select", opts = { vertical = true } },
        ["<a-h>"] = { "actions.select", opts = { horizontal = true } },
        ["<a-t>"] = { "actions.select", opts = { tab = true } },
        ["p"] = "actions.preview",
        ["q"] = { "actions.close", mode = "n" },
        ["r"] = "actions.refresh",
        ["<BS>"] = { "actions.parent", mode = "n" },
        ["<c-/>"] = { "actions.open_cwd", mode = "n" },
        ["`"] = { "actions.cd", mode = "n" },
        ["~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
        ["gs"] = { "actions.change_sort", mode = "n" },
        ["gx"] = "actions.open_external",
        ["g."] = { "actions.toggle_hidden", mode = "n" },
        ["g\\"] = { "actions.toggle_trash", mode = "n" },
        ["<leader>cd"] = function()
          local oil = require("oil")
          local dir = oil.get_current_dir()
          if dir then
            -- Set Neovim's CWD
            vim.cmd("cd " .. dir)
            -- Update NvimTree root if it's loaded
            local ok, api = pcall(require, "nvim-tree.api")
            if ok then
              api.tree.change_root(dir)
              api.tree.reload()
            end
            vim.notify("Changed directory to: " .. dir)
          end
        end,
      },
      use_default_mappings = false,
      view_options = {
        show_hidden = false,
      },
      win_options = {
        signcolumn = "yes:2",
      },
    },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<a-n>", "<cmd>Oil<CR>", desc = "Open file explorer" },
    },
  },

  -- Oil Git Status
  {
    "refractalize/oil-git-status.nvim",
    dependencies = {
      "stevearc/oil.nvim",
    },
    config = true,
  },
}
