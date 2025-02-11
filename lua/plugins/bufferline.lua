return {
  {
    "akinsho/bufferline.nvim",
    lazy = false,
    version = "*",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "tiagovla/scope.nvim",
      "echasnovski/mini.bufremove", -- Added for better buffer management
    },
    config = function()
      local bufferline = require("bufferline")
      bufferline.setup({
        options = {
          mode = "buffers", -- Changed to tabs mode
          numbers = "none",
          close_command = function(bufnum)
            require("mini.bufremove").delete(bufnum, false)
          end,
          right_mouse_command = "vertical sbuffer %d",
          left_mouse_command = "buffer %d",
          sort_by = "id",
          indicator = {
            style = "underline",
          },
          highlights = {
            fill = {
              bg = { attribute = "bg", highlight = "Normal" },
            },
            background = {
              bg = { attribute = "bg", highlight = "Normal" },
            },
            buffer_selected = {
              bold = true,
              italic = false,
            },
          },
          buffer_close_icon = "󰅖",
          modified_icon = "●",
          close_icon = "",
          left_trunc_marker = "",
          right_trunc_marker = "",
          diagnostics = "nvim_lsp",
          diagnostics_indicator = function(_, _, diag)
            local icons = { error = " ", warning = " ", info = " " }
            local ret = (diag.error and icons.error .. diag.error .. " " or "")
              .. (diag.warning and icons.warning .. diag.warning or "")
            return vim.trim(ret)
          end,
          offsets = {
            {
              filetype = "neo-tree",
              text = "File Explorer",
              highlight = "Directory",
              separator = false,
            },
            -- -- Added for Oil (Optional)
            -- {
            --   filetype = "oil",
            --   text = "Oil Explorer",
            --   separator = false,
            -- },
          },
          color_icons = true,
          show_buffer_icons = true,
          show_buffer_close_icons = true,
          show_close_icon = true,
          show_tab_indicators = true,
          separator_style = "slant",
          enforce_regular_tabs = true,
          always_show_bufferline = true,
          hover = {
            enabled = true,
            delay = 200,
            reveal = { "close" },
          },
          custom_filter = function(buf_number, _)
            local buf_ft = vim.bo[buf_number].filetype
            return buf_ft ~= "oil" and buf_ft ~= "neo-tree"
          end,
        },
      })
    end,
    keys = {
      -- Buffer Navigation
      { "<Tab>", "<cmd>BufferLineCycleNext<CR>", desc = "Next buffer" },
      { "<S-Tab>", "<cmd>BufferLineCyclePrev<CR>", desc = "Previous buffer" },

      -- Direct Buffer Switching
      { "<A-1>", "<cmd>BufferLineGoToBuffer 1<CR>", desc = "Switch to buffer 1" },
      { "<A-2>", "<cmd>BufferLineGoToBuffer 2<CR>", desc = "Switch to buffer 2" },
      { "<A-3>", "<cmd>BufferLineGoToBuffer 3<CR>", desc = "Switch to buffer 3" },
      { "<A-4>", "<cmd>BufferLineGoToBuffer 4<CR>", desc = "Switch to buffer 4" },
      { "<A-5>", "<cmd>BufferLineGoToBuffer 5<CR>", desc = "Switch to buffer 5" },
      { "<A-6>", "<cmd>BufferLineGoToBuffer 6<CR>", desc = "Switch to buffer 6" },
      { "<A-7>", "<cmd>BufferLineGoToBuffer 7<CR>", desc = "Switch to buffer 7" },
      { "<A-8>", "<cmd>BufferLineGoToBuffer 8<CR>", desc = "Switch to buffer 8" },
      { "<A-9>", "<cmd>BufferLineGoToBuffer 9<CR>", desc = "Switch to buffer 9" },

      -- Tab Navigation
      { "gt", "<cmd>tabnext<CR>", desc = "Next tab" },
      { "gT", "<cmd>tabprevious<CR>", desc = "Previous tab" },
      { "<A-h>", "<cmd>tabprevious<CR>", desc = "Previous tab" },
      { "<A-l>", "<cmd>tabnext<CR>", desc = "Next tab" },

      -- Tab Management
      {
        "<leader>tn",
        function()
          local current_dir = vim.fn.expand("%:p:h")
          vim.cmd.tabnew()
          require("oil").open(current_dir)
        end,
        desc = "New tab",
      },
      { "<leader>tc", "<cmd>tabnew %<cr>", desc = "Clone to new tab" },
      { "<leader>tx", "<cmd>tabclose<CR>", desc = "Close current tab" },
      { "<leader>to", "<cmd>tabonly<CR>", desc = "Close other tabs" },
      {
        "<leader>tm",
        function()
          local buf = vim.api.nvim_get_current_buf()
          vim.cmd.tabnew()
          vim.api.nvim_set_current_buf(buf)
          require("mini.bufremove").delete(0, false) -- Close original buffer
        end,
        desc = "Move buffer to a new tab",
      },

      -- Direct Tab Switching
      { "<C-1>", "1gt", desc = "Switch to tab 1" },
      { "<C-2>", "2gt", desc = "Switch to tab 2" },
      { "<C-3>", "3gt", desc = "Switch to tab 3" },
      { "<C-4>", "4gt", desc = "Switch to tab 4" },
      { "<C-5>", "5gt", desc = "Switch to tab 5" },
      { "<C-6>", "6gt", desc = "Switch to tab 6" },
      { "<C-6>", "7gt", desc = "Switch to tab 7" },
      { "<C-6>", "8gt", desc = "Switch to tab 8" },
      { "<C-6>", "9gt", desc = "Switch to tab 9" },

      -- Buffer Management
      {
        "<leader>X",
        function()
          local win_nr = vim.api.nvim_get_current_win()
          vim.api.nvim_win_close(win_nr, true)
        end,
        desc = "Close current window",
      },
      {
        "<leader>x",
        function()
          local buf = vim.api.nvim_get_current_buf()

          -- Delete buffer only if it's a normal file buffer
          if vim.bo[buf].buftype == "" and vim.bo[buf].buflisted then
            local win_count = 0

            -- Count how many windows are using the current buffer
            for _, win in ipairs(vim.api.nvim_list_wins()) do
              if vim.api.nvim_win_get_buf(win) == buf then
                win_count = win_count + 1
              end
            end

            -- Only delete the buffer if it was used in a single window
            if win_count == 1 then
              -- Guard against the buffer being invalid or deleted already
              if vim.api.nvim_buf_is_valid(buf) then
                require("mini.bufremove").delete(buf, false)
              end
            end
          end

          local win = vim.api.nvim_get_current_win()
          vim.api.nvim_win_close(win, true)
        end,
        desc = "Close window and buffer",
      },
      {
        "<leader>bo",
        function()
          -- Close buffers not used in current tab
          local current_tab = vim.api.nvim_get_current_tabpage()
          local tab_wins = vim.api.nvim_tabpage_list_wins(current_tab)
          local used_buffers = {}

          for _, win in ipairs(tab_wins) do
            used_buffers[vim.api.nvim_win_get_buf(win)] = true
          end

          for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if not used_buffers[buf] and vim.bo[buf].buflisted then
              vim.api.nvim_buf_delete(buf, { force = true })
            end
          end
        end,
        desc = "Delete unused buffers in current tab",
      },
      {
        "<leader>bd",
        function()
          require("mini.bufremove").delete(0, false)
        end,
        desc = "Delete current buffer",
      },
      {
        "<leader>bD",
        function()
          require("mini.bufremove").delete(0, true)
        end,
        desc = "Delete current buffer (force)",
      },
    },
  },

  {
    "echasnovski/mini.bufremove",
    version = "*",
    config = function()
      require("mini.bufremove").setup()
    end,
  },

  {
    "tiagovla/scope.nvim",
    config = function()
      require("scope").setup({
        -- Scope buffers to tabs
        restore_tab_buffers = true,
      })
      pcall(require("telescope").load_extension, "scope")
    end,
  },
}
