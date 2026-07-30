return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPre", "BufNewFile" },
    ---@module "ibl"
    ---@type ibl.config
    opts = {
      indent = {
        char = "▏", -- A much thinner, more subtle character that blends into the background
      },
    },
  },

  -- ToggleTerm
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    keys = {
      {
        "<leader>t",
        function()
          local count = vim.v.count > 0 and vim.v.count or 1
          vim.cmd(count .. "ToggleTerm")
        end,
        desc = "Toggle Terminal (count = instance number)",
      },
    },
    opts = {
      direction = "horizontal",
      start_in_insert = true,
      persist_size = true,
      persist_mode = true,
      on_open = function(term)
        local map_opts = { buffer = term.bufnr, silent = true }
        vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], map_opts)
        vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], map_opts)
        vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], map_opts)
        vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], map_opts)
      end,
    },
  },

  -- Mini Status Line
  {
    "echasnovski/mini.statusline",
    event = "VeryLazy",
    opts = {
      use_icons = true,
    },
  },

  -- Mini Tab Line
  {
    "echasnovski/mini.tabline",
    event = "VeryLazy",
    opts = {},
  },
}
