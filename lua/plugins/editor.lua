return {
  -- Autocomplete braces
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {},
  },

  -- Exchange text (cx{motion} or X in visual mode)
  {
    "tommcdo/vim-exchange",
    event = "VeryLazy",
    init = function()
      -- Use X for visual mode exchange, like in IdeaVim
      vim.keymap.set("x", "X", "<Plug>(Exchange)", { desc = "Exchange selections" })
    end,
  },

  -- Surround text objects (better than vim-surround)
  {
    "echasnovski/mini.surround",
    version = false,
    event = "VeryLazy",
    opts = {
      mappings = {
        add = "ys", -- Add surrounding in Normal and Visual modes
        delete = "ds", -- Delete surrounding
        find = "gsf", -- Find surrounding (to the right)
        find_left = "gsF", -- Find surrounding (to the left)
        highlight = "gsh", -- Highlight surrounding
        replace = "cs", -- Change surrounding
        update_n_lines = "", -- Update `n_lines`
        suffix_last = "", -- Suffix to search with "prev" method
        suffix_next = "", -- Suffix to search with "next" method
      },
      -- Add custom surrounds
      custom_surrounds = {
        -- Add function call surround
        f = {
          input = { "%f[%w]([^()]*%f[^%w])", "%f[%w][%w_]+" },
          output = function(input)
            -- If we captured a function name, use it, otherwise use empty
            return {
              left = (input[2] or "") .. "(",
              right = ")",
            }
          end,
        },
      },
      n_lines = 50,
      respect_selection_type = false,
      search_method = "cover",
    },
  },

  -- Enhanced text objects
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPost", "BufNewFile" },
  },

  -- Distraction-free coding
  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    opts = {
      window = {
        width = 0.85, -- width will be 85% of the editor width
        options = {
          number = true,
          relativenumber = true,
          signcolumn = "no",
          cursorline = false,
          cursorcolumn = false,
          foldcolumn = "0",
          list = false,
        },
      },
      plugins = {
        options = {
          enabled = true,
          ruler = false,
          showcmd = false,
        },
        twilight = { enabled = true }, -- dims inactive portions of the code
        gitsigns = { enabled = false },
        tmux = { enabled = false },
      },
      on_open = function(_)
        vim.opt.wrap = true
        vim.opt.linebreak = true
      end,
      on_close = function()
        vim.opt.wrap = false
        vim.opt.linebreak = false
      end,
    },
    keys = {
      { "<leader>z", "<cmd>ZenMode<CR>", desc = "Toggle Zen Mode" },
      { "<leader>tw", "<cmd>Twilight<CR>", desc = "Toggle Twilight" },
    },
    dependencies = {
      "folke/twilight.nvim",
      opts = {
        dimming = {
          alpha = 0.25, -- amount of dimming
          color = { "Normal", "#ffffff" },
          term_bg = "#000000", -- if guibg=NONE, this will be used to calculate text color
          inactive = false, -- when true, other windows will be fully dimmed (unless they contain the same buffer)
        },
        context = 40, -- amount of lines we will try to show around the current line
        treesitter = true, -- use treesitter when available for the filetype
        expand = { -- for treesitter, we we always try to expand to the top-most ancestor with these types
          "function",
          "method",
          "table",
          "if_statement",
        },
      },
    },
  },

  -- Better TODO comments
  {
    "folke/todo-comments.nvim",
    lazy = false,
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
    keys = {
      {
        "]t",
        function()
          require("todo-comments").jump_next()
        end,
        desc = "Jump to next todo",
        mode = { "n", "v" },
      },
      {
        "[t",
        function()
          require("todo-comments").jump_prev()
        end,
        desc = "Jump to previous todo",
        mode = { "n", "v" },
      },
    },
  },

  -- Kitty Config Files
  {
    "fladson/vim-kitty",
    ft = "kitty",
    tag = "*", -- You can select a tagged version
  },
}
