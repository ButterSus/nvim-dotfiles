return {
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons", "wintermute-cell/gitignore.nvim" },
    opts = {
      on_attach = function(bufnr)
        local api = require("nvim-tree.api")

        -- Default mappings
        api.config.mappings.default_on_attach(bufnr)

        -- Remove the `-` mapping
        vim.keymap.del("n", "-", { buffer = bufnr })

        -- Add <A-n> for directory up
        vim.keymap.set("n", "<A-n>", api.tree.change_root_to_parent, { buffer = bufnr, desc = "Up directory" })

        -- Gitignore
        vim.keymap.set("n", "<leader>gi", "<cmd>Gitignore<CR>", { buffer = bufnr, desc = "Edit .gitignore" })
      end,
      disable_netrw = true,
      hijack_netrw = true,
      hijack_cursor = true,
      hijack_unnamed_buffer_when_opening = false,
      sync_root_with_cwd = true,
      respect_buf_cwd = true,
      update_focused_file = {
        enable = true,
        update_root = true,
      },
      filters = {
        dotfiles = false,
        custom = { "^.git$" },
      },
      view = {
        adaptive_size = false,
        side = "left",
        width = 30,
        preserve_window_proportions = true,
        float = {
          enable = false,
        },
        signcolumn = "yes",
      },
      tab = {
        sync = {
          open = true,
          close = true,
        },
      },
      git = {
        enable = true,
        ignore = false,
      },
      filesystem_watchers = {
        enable = true,
      },
      actions = {
        open_file = {
          resize_window = true,
          quit_on_open = false,
        },
      },
      renderer = {
        root_folder_label = false,
        highlight_git = true,
        highlight_opened_files = "none",
        indent_markers = {
          enable = true,
        },
        icons = {
          show = {
            file = true,
            folder = true,
            folder_arrow = true,
            git = false,
          },
        },
      },
    },
    keys = {
      { "<leader>e", "<cmd>NvimTreeToggle<CR>", desc = "Toggle file explorer" },
      { "<leader>fe", "<cmd>NvimTreeFocus<CR>", desc = "Focus file explorer" },
      {
        "<C-n>",
        function()
          require("nvim-tree.api").tree.toggle({ focus = false })
        end,
        desc = "Toggle file explorer (no focus)",
      },
    },
  },
}
