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
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "wintermute-cell/gitignore.nvim",
    },
    opts = {
      default_file_explorer = true,
      watch_for_changes = true,
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
        ["<a-h>"] = false,

        -- Open current file in buffer
        ["<a-s>"] = { "actions.select", opts = { vertical = true } },
        ["<a-v>"] = { "actions.select", opts = { horizontal = true } },
        ["<a-t>"] = { "actions.select", opts = { tab = true } },

        -- Standard Oil mappings
        ["g?"] = { "actions.show_help", mode = "n" },
        ["<CR>"] = "actions.select",
        ["m"] = "actions.preview",
        ["q"] = { "actions.close", mode = "n" },
        ["r"] = "actions.refresh",
        ["<BS>"] = { "actions.parent", mode = "n" },
        ["<c-/>"] = { "actions.open_cwd", mode = "n" },
        ["gs"] = { "actions.change_sort", mode = "n" },
        ["gx"] = "actions.open_external",
        ["g."] = { "actions.toggle_hidden", mode = "n" },
        ["."] = {
          function() end,
          mode = "n",
          desc = "Set root for Neotree",
        },
        ["g\\"] = { "actions.toggle_trash", mode = "n" },
        ["~"] = { "actions.open_cwd", mode = "n" },
        ["<leader>cd"] = { "actions.tcd", mode = "n" },
        ["<leader>gi"] = "<cmd>Gitignore<CR>",

        -- Add file to buffers using <Tab>
        ["<Tab>"] = function()
          local currentDir = require("oil").get_current_dir()
          if not currentDir then
            vim.notify("No directory info available", vim.log.levels.WARN)
            return
          end
          local line = vim.fn.getline(".")
          -- Extract the entry name from the current line (adjust the pattern as needed)
          local filename = line:match("([^%s]+)$")
          if not filename then
            vim.notify("Could not determine file/directory from line", vim.log.levels.WARN)
            return
          end
          local fullpath = vim.fn.fnamemodify(currentDir .. "/" .. filename, ":p")
          if vim.fn.isdirectory(fullpath) == 1 then
            vim.notify("Selected entry is a directory; cannot add to buffers", vim.log.levels.WARN)
          else
            vim.cmd("badd " .. vim.fn.fnameescape(fullpath))
            vim.notify("Added file to buffers: " .. fullpath)
          end
        end,

        -- Remove file or directory from buffers using <S-Tab>
        ["<S-Tab>"] = function()
          local currentDir = require("oil").get_current_dir()
          if not currentDir then
            vim.notify("No directory info available", vim.log.levels.WARN)
            return
          end
          local line = vim.fn.getline(".")
          local filename = line:match("([^%s]+)$")
          if not filename then
            vim.notify("Could not determine file/directory from line", vim.log.levels.WARN)
            return
          end
          local fullpath = vim.fn.fnamemodify(currentDir .. filename, ":p")
          if vim.fn.isdirectory(fullpath) == 1 then
            for _, bufnr_local in ipairs(vim.api.nvim_list_bufs()) do
              local buf_name = vim.api.nvim_buf_get_name(bufnr_local)
              local normalized_buf = vim.fn.fnamemodify(buf_name, ":p")
              if normalized_buf:sub(1, #fullpath) == fullpath then
                require("mini.bufremove").delete(bufnr_local, false)
              end
            end
            vim.notify("Removed buffers for directory: " .. fullpath)
          else
            local normalized = vim.fn.fnamemodify(fullpath, ":p")
            for _, bufnr_local in ipairs(vim.api.nvim_list_bufs()) do
              local buf_name = vim.api.nvim_buf_get_name(bufnr_local)
              if buf_name == normalized then
                require("mini.bufremove").delete(bufnr_local, false)
                vim.notify("Removed file from buffers: " .. fullpath)
                return
              end
            end
            vim.notify("File not found in buffers: " .. fullpath)
          end
        end,
        -- ["<leader>vf"] = {
        --   function()
        --     local current_dir = require("oil").get_current_dir()
        --     if current_dir then
        --       require("plugins/utils/lsp").generate_filelist_and_reload(current_dir)
        --       -- NOTE: Since there is no reload function for oil.nvim API, then we must use watch_for_changes option set to true
        --     else
        --       vim.notify("Could not determine Oil directory", vim.log.levels.ERROR)
        --     end
        --   end,
        --   desc = "Generate verible.filelist and reload LSP",
        -- },
      },
      use_default_mappings = false,
      view_options = {
        show_hidden = false,
        highlight_filename = require("plugins.utils.git_status").highlight_filename,
      },
      win_options = {},
    },
    config = function(_, opts)
      -- Declare a global function to retrieve Oil's current directory for the winbar display.
      function _G.get_oil_winbar()
        local bufnr = vim.api.nvim_win_get_buf(vim.g.statusline_winid)
        local dir = require("oil").get_current_dir(bufnr)
        if dir then
          return vim.fn.fnamemodify(dir, ":~")
        else
          return vim.api.nvim_buf_get_name(0)
        end
      end
      opts.win_options.winbar = "%!v:lua.get_oil_winbar()"
      require("oil").setup(opts)
    end,
    keys = {
      {
        "<A-n>",
        function()
          local buf = vim.api.nvim_get_current_buf()
          local is_empty_buf = vim.fn.expand("%") == ""
          local win_count = 0

          -- Count how many windows are using the current buffer
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            if vim.api.nvim_win_get_buf(win) == buf then
              win_count = win_count + 1
            end
          end

          -- Open oil.nvim
          vim.cmd("Oil")

          -- Only delete the buffer if it was used in a single window
          if win_count == 1 and not is_empty_buf then
            -- Guard against the buffer being invalid or deleted already
            if vim.api.nvim_buf_is_valid(buf) then
              require("mini.bufremove").delete(buf, false)
            end
          end
        end,
        desc = "Open file explorer (delete buffer)",
      },
      {
        "<A-S-n>",
        function()
          if vim.fn.expand("%") == "" then
            vim.cmd("Oil " .. vim.fn.getcwd())
          else
            vim.cmd("Oil")
          end
        end,
        desc = "Open file explorer",
      },
    },
  },

  -- Better WEB navigation
  {
    "chrisgrieser/nvim-spider",
    event = "VeryLazy",
    opts = {
      skipInsignificantPunctuation = false,
    },
    keys = {
      {
        mode = { "n", "o", "x" },
        "w",
        function()
          require("spider").motion("w")
        end,
        desc = "Spider-w",
      },
      {
        mode = { "n", "o", "x" },
        "e",
        function()
          require("spider").motion("e")
        end,
        desc = "Spider-e",
      },
      {
        mode = { "n", "o", "x" },
        "b",
        function()
          require("spider").motion("b")
        end,
        desc = "Spider-b",
      },
    },
  },
}
