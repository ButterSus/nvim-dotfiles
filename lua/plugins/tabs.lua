return {
  -- TODO: Test for bugs
  {
    'akinsho/bufferline.nvim',
    version = "*",
    dependencies = {
      'nvim-tree/nvim-web-devicons',
      'tiagovla/scope.nvim',
    },
    opts = {
      options = {
        mode = "tabs",
        numbers = "none",
        close_command = function(bufnum)
          require("bufdelete").bufdelete(bufnum, true)
        end,
        indicator = {
          style = 'underline',
        },
        buffer_close_icon = '󰅖',
        modified_icon = '●',
        close_icon = '',
        left_trunc_marker = '',
        right_trunc_marker = '',
        diagnostics = "nvim_lsp",
        diagnostics_indicator = function(_, _, diag)
          local icons = { error = ' ', warning = ' ', info = ' ' }
          local ret = (diag.error and icons.error .. diag.error .. ' ' or '')
            .. (diag.warning and icons.warning .. diag.warning or '')
          return vim.trim(ret)
        end,
        offsets = {
          {
            filetype = "oil",
            text = "File Explorer",
            highlight = "Directory",
            separator = true
          }
        },
        color_icons = true,
        show_buffer_icons = true,
        show_buffer_close_icons = true,
        show_close_icon = false,
        show_tab_indicators = true,
        separator_style = "thin",
        enforce_regular_tabs = true,
        always_show_bufferline = true,
        hover = {
          enabled = true,
          delay = 200,
          reveal = {'close'}
        },
      }
    },
    keys = {
      { "<Tab>", "<cmd>tabnext<CR>", desc = "Next tab" },
      { "<S-Tab>", "<cmd>tabprevious<CR>", desc = "Previous tab" },
      { "<leader>x", "<cmd>tabclose<CR>", desc = "Close tab" },
      { "<leader>tc", "<cmd>tabclose<CR>", desc = "Close tab" },
      { "<leader>to", "<cmd>tabonly<CR>", desc = "Close other tabs" },
    }
  },

  {
    'tiagovla/scope.nvim',
    opts = {},
    config = function(_, opts)
      require("scope").setup(opts)
      -- Each window will retain its own independent buffer history
      -- require("telescope").load_extension("scope")
    end
  }
}
