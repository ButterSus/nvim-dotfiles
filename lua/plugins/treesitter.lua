return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      highlight = {
        enable = true,
        disable = function(_, buf)
          local max_filesize = 100 * 1024 -- 100 KB
          local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
          if ok and stats and stats.size > max_filesize then
            return true
          end
        end,
        additional_vim_regex_highlighting = false,
        use_languagetree = false,
      },
      indent = { enable = true },
      ensure_installed = {
        "lua",
        "luadoc",
        "python",
        "hyprlang",
        "markdown",
        "verilog",
        "tmux",
        "toml",
        "json",
        "yaml",
        "bash",
        "c",
        "cpp",
        "cmake",
        "css",
        "html",
        "javascript",
      },
      auto_install = false,

      -- Enable incremental selection
      incremental_selection = {
        enable = true,
        keymaps = {
          node_incremental = "v",
          node_decremental = "V",
        },
      },

      -- Enable matchups
      matchup = {
        enable = true,
      },

      -- Enable text objects
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          include_surrounding_whitespace = function(a)
            if a.query_string == "@parameter.outer" then
              return true
            elseif a.query_string == "@loop.outer" then
              return true
            elseif a.query_string == "@conditional.outer" then
              return true
            elseif a.query_string == "@block.outer" then
              return true
            elseif a.query_string == "@assignment.outer" then
              return true
            elseif a.query_string == "@module.outer" then
              return true
            elseif a.query_string == "@macro.outer" then
              return true
            elseif a.query_string == "@call.outer" then
              return true
            elseif a.query_string == "@comment.outer" then
              return true
            elseif a.query_string == "@statement.outer" then
              return true
            elseif a.query_string == "@function.outer" then
              return true
            elseif a.query_string == "@class.outer" then
              return true
            else
              return false
            end
          end,
          keymaps = {
            -- You can use the capture groups defined in textobjects.scm
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
            ["aa"] = "@parameter.outer",
            ["ia"] = "@parameter.inner",
            ["al"] = "@loop.outer",
            ["il"] = "@loop.inner",
            ["ai"] = "@conditional.outer",
            ["ii"] = "@conditional.inner",
            ["av"] = "@field.outer",
            ["iv"] = "@field.inner",
            ["ab"] = "@block.outer",
            ["ib"] = "@block.inner",
            -- NOTE: There is no @statement.inner, I've spent so much time debugging. Lol
            -- But I'll keep it here, for me Inner & Outer have very basic difference ->
            -- Surrounding whitespace is handled differently, since a<motion> is mostly
            -- used to delete or change all block.
            ["is"] = "@statement.inner",
            ["as"] = "@statement.outer",
            ["aq"] = "@call.outer",
            ["iq"] = "@call.inner",
            ["i/"] = "@comment.inner",
            ["a/"] = "@comment.outer",
            ["aA"] = "@assignment.outer",
            ["iA"] = "@assignment.inner",
            ["iH"] = "@assignment.lhs",
            ["iL"] = "@assignment.rhs",
            ["im"] = "@module.inner",
            ["am"] = "@module.outer",
            ["id"] = "@macro.inner",
            ["ad"] = "@macro.outer",
          },
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            ["]f"] = "@function.outer",
            ["]c"] = "@class.outer",
            ["]a"] = "@parameter.outer",
            ["]l"] = "@loop.outer",
            ["]i"] = "@conditional.outer",
            ["]v"] = "@field.outer",
            ["]b"] = "@block.outer",
            ["]q"] = "@call.outer",
            ["]m"] = "@module.outer",
            ["]s"] = "@statement.outer",
            ["]]"] = "@assignment.outer", -- NOTE: We're out of symbols to map
          },
          goto_next_end = {
            ["]F"] = "@function.outer",
            ["]C"] = "@class.outer",
            ["]A"] = "@parameter.outer",
            ["]L"] = "@loop.outer",
            ["]I"] = "@conditional.outer",
            ["]V"] = "@field.outer",
            ["]B"] = "@block.outer",
            ["]Q"] = "@call.outer",
            ["]M"] = "@module.outer",
            ["]S"] = "@statement.outer",
            ["]}"] = "@assignment.outer",
          },
          goto_previous_start = {
            ["[f"] = "@function.outer",
            ["[c"] = "@class.outer",
            ["[a"] = "@parameter.outer",
            ["[l"] = "@loop.outer",
            ["[i"] = "@conditional.outer",
            ["[v"] = "@field.outer",
            ["[b"] = "@block.outer",
            ["[q"] = "@call.outer",
            ["[m"] = "@module.outer",
            ["[s"] = "@statement.outer",
            ["[["] = "@assignment.outer",
          },
          goto_previous_end = {
            ["[F"] = "@function.outer",
            ["[C"] = "@class.outer",
            ["[A"] = "@parameter.outer",
            ["[L"] = "@loop.outer",
            ["[I"] = "@conditional.outer",
            ["[V"] = "@field.outer",
            ["[B"] = "@block.outer",
            ["[Q"] = "@call.outer",
            ["[M"] = "@module.outer",
            ["[S"] = "@statement.outer",
            ["[{"] = "@assignment.outer",
          },
        },
        swap = {
          enable = true,
          swap_next = {
            ["<leader>a"] = "@parameter.inner",
          },
          swap_previous = {
            ["<leader>A"] = "@parameter.inner",
          },
        },
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
      vim.filetype.add({
        pattern = { [".*/hypr/.*%.conf"] = "hyprlang" },
      })
    end,
  },

  -- Indentation lines
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {},
  },

  -- Textobjects plugin as a dependency
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = "nvim-treesitter/nvim-treesitter",
  },
  {
    "chrisgrieser/nvim-various-textobjs",
    lazy = false,
    opts = {
      keymaps = {
        useDefaults = false,
      },
    },
    keys = {
      {
        "gx",
        function()
          -- select URL
          require("various-textobjs").url()

          -- plugin only switches to visual mode when textobj is found
          local foundURL = vim.fn.mode() == "v"
          if not foundURL then
            return
          end

          -- retrieve URL with the z-register as intermediary
          vim.cmd.normal({ '"zy', bang = true })
          local url = vim.fn.getreg("z")
          vim.ui.open(url) -- requires nvim 0.10
        end,
        desc = "URL Opener",
        mode = "n",
      },
      {
        "i ",
        function()
          require("various-textobjs").subword("inner")
        end,
        desc = "inner Subword",
        mode = { "o", "x" },
      },
      {
        "a ",
        function()
          require("various-textobjs").subword("outer")
        end,
        desc = "outer Subword",
        mode = { "o", "x" },
      },
    },
  },

  -- MatchUp
  {
    "andymass/vim-matchup",
    event = "VeryLazy",
    init = function()
      vim.g.matchup_matchparen_offscreen = { method = "popup" }
      vim.g.matchup_surround_enabled = 1
    end,
  },
}
