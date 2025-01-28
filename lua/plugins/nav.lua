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
    'stevearc/oil.nvim',
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

        -- Mappings
        ["g?"] = { "actions.show_help", mode = "n" },
        ["<CR>"] = "actions.select",
        ["<a-s>"] = { "actions.select", opts = { vertical = true } },
        ["<a-h>"] = { "actions.select", opts = { horizontal = true } },
        ["<a-t>"] = { "actions.select", opts = { tab = true } },
        ["p"] = "actions.preview",
        ["q"] = { "actions.close", mode = "n" },
        ["r"] = "actions.refresh",
        ["<c-n>"] = { "actions.parent", mode = "n" },
        ["<BS>"] = { "actions.parent", mode = "n" },
        ["/"] = { "actions.open_cwd", mode = "n" },
        ["`"] = { "actions.cd", mode = "n" },
        ["~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
        ["gs"] = { "actions.change_sort", mode = "n" },
        ["gx"] = "actions.open_external",
        ["g."] = { "actions.toggle_hidden", mode = "n" },
        ["g\\"] = { "actions.toggle_trash", mode = "n" },
      },
      use_default_mappings = false
    },
    dependencies = { { "echasnovski/mini.icons", opts = {} } },
    keys = {
      { "<c-n>", "<cmd>Oil<CR>", desc = "Open file explorer" },
      { "<leader>e", "<cmd>Oil<CR>", desc = "Open file explorer" },
    }
  },
}
