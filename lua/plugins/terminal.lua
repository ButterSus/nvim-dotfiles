return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    opts = {
      size = function(term)
        if term.direction == "horizontal" then
          return 15
        elseif term.direction == "vertical" then
          return vim.o.columns * 0.4
        end
      end,
      open_mapping = [[<c-\>]],
      hide_numbers = true,
      shade_filetypes = {},
      shade_terminals = false,
      start_in_insert = true,
      insert_mappings = true,
      terminal_mappings = true,
      persist_size = true,
      direction = "horizontal",
      close_on_exit = true,
      shell = vim.o.shell,
      float_opts = {
        border = "curved",
        winblend = 0,
        highlights = {
          border = "Normal",
          background = "Normal",
        },
      },
    },
    keys = {
      { "<leader>tt", "<cmd>ToggleTerm direction=horizontal<cr>", desc = "Terminal (horizontal)" },
      { "<leader>tf", "<cmd>ToggleTerm direction=float<cr>", desc = "Terminal (float)" },
      { "<leader>tv", "<cmd>ToggleTerm direction=vertical<cr>", desc = "Terminal (vertical)" },
    },
    config = function(_, opts)
      local toggleterm = require("toggleterm")
      toggleterm.setup(opts)

      -- Function to kill all terminal buffers
      toggleterm.kill_all_terms = function()
        for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
          if vim.bo[bufnr].filetype == "toggleterm" then
            vim.api.nvim_buf_delete(bufnr, { force = true })
          end
        end
      end

      -- Add mapping to kill all terminals
      vim.keymap.set("n", "<leader>tk", toggleterm.kill_all_terms, { desc = "Kill all terminals" })

      -- Auto-close terminal buffers
      vim.api.nvim_create_autocmd({ "TermEnter" }, {
        callback = function()
          for _, buffers in ipairs(vim.fn.getbufinfo()) do
            local filetype = vim.api.nvim_buf_get_option(buffers.bufnr, "filetype")
            if filetype == "toggleterm" then
              vim.api.nvim_create_autocmd({ "BufWriteCmd", "FileWriteCmd", "FileAppendCmd" }, {
                buffer = buffers.bufnr,
                callback = function()
                  toggleterm.kill_all_terms()
                  return true
                end,
              })
            end
          end
        end,
      })

      -- Terminal navigation
      local map = vim.keymap.set
      map("t", "<Esc>", [[<C-\><C-n>]], { desc = "Enter Normal mode" })
      map("t", "<C-h>", [[<C-\><C-n><C-w>h]], { desc = "Switch window left" })
      map("t", "<C-l>", [[<C-\><C-n><C-w>l]], { desc = "Switch window right" })
      map("t", "<C-j>", [[<C-\><C-n><C-w>j]], { desc = "Switch window down" })
      map("t", "<C-k>", [[<C-\><C-n><C-w>k]], { desc = "Switch window up" })

      -- Map <C-x><C-h/j/k/l> to send corresponding keypresses in terminal
      local _, _ = pcall(vim.keymap.del, "t", "<C-x>")
      map("t", "<C-x><Esc>", "<Esc>", { desc = "Send <Esc> in terminal" })
      map("t", "<C-x><C-x>", "<C-x>", { desc = "Send <C-x> in terminal" })
      map("t", "<C-x><C-h>", "<C-h>", { desc = "Send <C-h> in terminal" })
      map("t", "<C-x><C-l>", "<C-l>", { desc = "Send <C-l> in terminal" })
      map("t", "<C-x><C-j>", "<C-j>", { desc = "Send <C-j> in terminal" })
      map("t", "<C-x><C-k>", "<C-k>", { desc = "Send <C-k> in terminal" })
    end,
  },
}

