return {
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "wintermute-cell/gitignore.nvim",
      "echasnovski/mini.bufremove", -- Added for better buffer management
    },
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

        -- Mapping for changing Neovim's current working directory
        vim.keymap.set("n", "<leader>cd", function()
          local node = api.tree.get_node_under_cursor().parent
          local dir = node.absolute_path

          if node.type == "directory" then
            -- Set Neovim's CWD
            vim.cmd("cd " .. dir)

            -- Reload NvimTree to reflect new root
            api.tree.change_root(dir)
            api.tree.reload()

            vim.notify("Changed directory to: " .. dir)
          else
            vim.notify("Not a directory", vim.log.levels.WARN)
          end
        end, { buffer = bufnr, desc = "Change to current directory" })

        -- Open file in a new buffer of current tab
        vim.keymap.set("n", "<Tab>", function()
          local node = api.tree.get_node_under_cursor()
          if node.type == "file" then
            vim.cmd("badd " .. node.absolute_path)
          end
        end, { buffer = bufnr, desc = "Add file to current tab buffers" })

        -- Remove file or directory from buffers
        vim.keymap.set("n", "<S-Tab>", function()
          local node = api.tree.get_node_under_cursor()

          local function remove_file_buffer(file_path)
            local normalized_path = vim.fn.fnamemodify(file_path, ":p")
            for _, bufnr_local in ipairs(vim.api.nvim_list_bufs()) do
              local buf_name = vim.api.nvim_buf_get_name(bufnr_local)
              if buf_name == normalized_path then
                require("mini.bufremove").delete(bufnr_local, false)
                break
              end
            end
          end

          local function process_path(path)
            if vim.fn.isdirectory(path) == 1 then
              local items = vim.fn.glob(path .. "/*", true, true)
              for _, item in ipairs(items) do
                process_path(item)
              end
            else
              remove_file_buffer(path)
            end
          end

          if node.type == "file" then
            remove_file_buffer(node.absolute_path)
          elseif node.type == "directory" then
            process_path(node.absolute_path)
          end

          vim.notify("Removed buffers for " .. node.absolute_path)
        end, { buffer = bufnr, desc = "Remove file or directory buffers" })
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
