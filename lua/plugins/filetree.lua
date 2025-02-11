return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    lazy = false,
    branch = "v2.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
      "wintermute-cell/gitignore.nvim",
      "echasnovski/mini.bufremove",
    },
    opts = {
      sources = { "filesystem", "buffers", "git_status", "document_symbols" },
      default_component_configs = {
        indent = {
          with_expanders = true,
          expander_collapsed = "",
          expander_expanded = "",
          expander_highlight = "NeoTreeExpander",
        },
        icon = {
          folder_closed = "",
          folder_open = "",
          folder_empty = "",
          default = "",
        },
        modified = {
          symbol = "[+]",
          highlight = "NeoTreeModified",
        },
      },
      window = {
        position = "left",
        width = 30,
        mappings = {
          ["<CR>"] = "open",
          ["o"] = "open",
          ["S"] = "open_split",
          ["s"] = "open_vsplit",
          ["t"] = "open_tabnew",
          ["<Tab>"] = function(state)
            local node = state.tree:get_node()
            if node and node.type == "file" then
              vim.cmd("badd " .. vim.fn.fnameescape(node.path))
              vim.notify("Added file to current tab buffers: " .. node.path)
            else
              vim.notify("Selected node is not a file", vim.log.levels.WARN)
            end
          end,
          ["<S-Tab>"] = function(state)
            local node = state.tree:get_node()
            if not node then
              return
            end
            if node.type == "directory" then
              local target_dir = vim.fn.fnamemodify(node.path, ":p")
              for _, bufnr_local in ipairs(vim.api.nvim_list_bufs()) do
                local buf_name = vim.api.nvim_buf_get_name(bufnr_local)
                local normalized_buf = vim.fn.fnamemodify(buf_name, ":p")
                if normalized_buf:sub(1, #target_dir) == target_dir then
                  require("mini.bufremove").delete(bufnr_local, false)
                end
              end
              vim.notify("Removed buffers for directory: " .. target_dir)
            elseif node.type == "file" then
              local normalized_path = vim.fn.fnamemodify(node.path, ":p")
              for _, bufnr_local in ipairs(vim.api.nvim_list_bufs()) do
                local buf_name = vim.api.nvim_buf_get_name(bufnr_local)
                if buf_name == normalized_path then
                  require("mini.bufremove").delete(bufnr_local, false)
                  break
                end
              end
              vim.notify("Removed file from buffers: " .. node.path)
            else
              vim.notify("Selected node is neither file nor directory", vim.log.levels.WARN)
            end
          end,
          ["<leader>cd"] = function(state)
            local node = state.tree:get_node()
            if not node then
              vim.notify("No node selected", vim.log.levels.WARN)
              return
            end
            local target_dir = ""
            if node.type == "directory" or node.type == "file" then
              target_dir = vim.fn.fnamemodify(node.path, ":h")
            else
              vim.notify("Selected node is neither file nor directory", vim.log.levels.WARN)
              return
            end
            vim.cmd("cd " .. target_dir)
            vim.notify("Changed directory to: " .. target_dir)
          end,
        },
      },
      filesystem = {
        hijack_netrw_behavior = "open_default",
        filtered_items = {
          visible = false,
          hide_dotfiles = false,
          hide_gitignored = false,
          hide_hidden = true,
          never_show = { ".git" },
        },
        follow_current_file = true,
        group_empty_dirs = true,
        window = {
          mappings = {
            ["<A-n>"] = "navigate_up",
            ["<leader>gi"] = {
              function()
                vim.cmd([[ Gitignore ]])
              end,
              desc = "Create .gitignore",
            },
          },
        },
      },
      buffers = {
        show_unloaded = true,
      },
      git_status = {
        show_untracked = true,
      },
    },
    keys = {
      { "<leader>e", "<cmd>Neotree toggle<CR>", desc = "Toggle file explorer" },
      { "<leader>fe", "<cmd>Neotree focus<CR>", desc = "Focus file explorer" },
      {
        "<C-n>",
        function()
          require("neo-tree.command").execute({ toggle = true, reveal = false })
        end,
        desc = "Toggle file explorer (no focus)",
      },
    },
  },
}
