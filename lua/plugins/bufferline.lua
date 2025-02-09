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
              filetype = "NvimTree",
              text = "File Explorer",
              highlight = "Directory",
              separator = true,
            },
          },
          color_icons = true,
          show_buffer_icons = true,
          show_buffer_close_icons = true,
          show_close_icon = true,
          show_tab_indicators = true,
          separator_style = "thin",
          enforce_regular_tabs = true,
          always_show_bufferline = true,
          hover = {
            enabled = true,
            delay = 200,
            reveal = { "close" },
          },
          custom_filter = function(buf_number, _)
            local buf_ft = vim.bo[buf_number].filetype
            return buf_ft ~= "oil"
          end,
        },
      })
    end,
    keys = {
      -- Buffer Navigation
      { "<Tab>", "<cmd>BufferLineCycleNext<CR>", desc = "Next buffer" },
      { "<S-Tab>", "<cmd>BufferLineCyclePrev<CR>", desc = "Previous buffer" },

      -- Tab Navigation
      { "gt", "<cmd>tabnext<CR>", desc = "Next tab" },
      { "gT", "<cmd>tabprevious<CR>", desc = "Previous tab" },
      { "<leader>tn", "<cmd>tabnew<CR>", desc = "New tab" },
      { "<leader>tc", "<cmd>tabclose<CR>", desc = "Close current tab" },
      { "<leader>to", "<cmd>tabonly<CR>", desc = "Close other tabs" },

      -- Direct Tab Switching
      { "<C-1>", "1gt", desc = "Switch to tab 1" },
      { "<C-2>", "2gt", desc = "Switch to tab 2" },
      { "<C-3>", "3gt", desc = "Switch to tab 3" },
      { "<C-4>", "4gt", desc = "Switch to tab 4" },
      { "<C-5>", "5gt", desc = "Switch to tab 5" },

      -- Buffer Management
      {
        "<leader>x",
        function()
          local win_nr = vim.api.nvim_get_current_win()
          vim.api.nvim_win_close(win_nr, true)
        end,
        desc = "Close current window",
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
        desc = "Delete current buffer",
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
