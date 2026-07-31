-- This file should be 100% compatible with Visual Studio Code
-- use vim.g.vscode to exclude logic

return {
  {
    "nvim-treesitter/nvim-treesitter",
    -- This plugin does not support lazy-loading.
    lazy = false,
    build = ":TSUpdate",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    keys = {
      -- Functions
      {
        "af",
        function()
          require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects")
        end,
        mode = { "x", "o" },
        desc = "Select Around Function",
      },
      {
        "if",
        function()
          require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects")
        end,
        mode = { "x", "o" },
        desc = "Select Inner Function",
      },

      -- Classes / structs
      {
        "ac",
        function()
          require("nvim-treesitter-textobjects.select").select_textobject("@class.outer", "textobjects")
        end,
        mode = { "x", "o" },
        desc = "Select Around Class",
      },
      {
        "ic",
        function()
          require("nvim-treesitter-textobjects.select").select_textobject("@class.inner", "textobjects")
        end,
        mode = { "x", "o" },
        desc = "Select Inner Class",
      },

      -- Parameters / arguments
      {
        "aa",
        function()
          require("nvim-treesitter-textobjects.select").select_textobject("@parameter.outer", "textobjects")
        end,
        mode = { "x", "o" },
        desc = "Select Around Argument",
      },
      {
        "ia",
        function()
          require("nvim-treesitter-textobjects.select").select_textobject("@parameter.inner", "textobjects")
        end,
        mode = { "x", "o" },
        desc = "Select Inner Argument",
      },

      -- Language scope (locals query)
      {
        "as",
        function()
          require("nvim-treesitter-textobjects.select").select_textobject("@local.scope", "locals")
        end,
        mode = { "x", "o" },
        desc = "Select Language Scope",
      },

      -- Conditionals (if/else)
      {
        "ai",
        function()
          require("nvim-treesitter-textobjects.select").select_textobject("@conditional.outer", "textobjects")
        end,
        mode = { "x", "o" },
        desc = "Select Around Conditional",
      },
      {
        "ii",
        function()
          require("nvim-treesitter-textobjects.select").select_textobject("@conditional.inner", "textobjects")
        end,
        mode = { "x", "o" },
        desc = "Select Inner Conditional",
      },

      -- Loops (for/while)
      {
        "al",
        function()
          require("nvim-treesitter-textobjects.select").select_textobject("@loop.outer", "textobjects")
        end,
        mode = { "x", "o" },
        desc = "Select Around Loop",
      },
      {
        "il",
        function()
          require("nvim-treesitter-textobjects.select").select_textobject("@loop.inner", "textobjects")
        end,
        mode = { "x", "o" },
        desc = "Select Inner Loop",
      },

      -- Comments
      {
        "aC",
        function()
          require("nvim-treesitter-textobjects.select").select_textobject("@comment.outer", "textobjects")
        end,
        mode = { "x", "o" },
        desc = "Select Around Comment",
      },

      -- Calls (function calls: foo(a, b))
      {
        "am",
        function()
          require("nvim-treesitter-textobjects.select").select_textobject("@call.outer", "textobjects")
        end,
        mode = { "x", "o" },
        desc = "Select Around Call",
      },
      {
        "im",
        function()
          require("nvim-treesitter-textobjects.select").select_textobject("@call.inner", "textobjects")
        end,
        mode = { "x", "o" },
        desc = "Select Inner Call",
      },

      -- Return statements
      {
        "ar",
        function()
          require("nvim-treesitter-textobjects.select").select_textobject("@return.outer", "textobjects")
        end,
        mode = { "x", "o" },
        desc = "Select Around Return",
      },

      -- Assignments (x = y;)
      {
        "a=",
        function()
          require("nvim-treesitter-textobjects.select").select_textobject("@assignment.outer", "textobjects")
        end,
        mode = { "x", "o" },
        desc = "Select Around Assignment",
      },
      {
        "i=",
        function()
          require("nvim-treesitter-textobjects.select").select_textobject("@assignment.inner", "textobjects")
        end,
        mode = { "x", "o" },
        desc = "Select Inner Assignment (RHS)",
      },

      -- Movement: functions
      {
        "]f",
        function()
          require("nvim-treesitter-textobjects.move").goto_next_start("@function.outer", "textobjects")
        end,
        mode = { "n", "x", "o" },
        desc = "Next Function Start",
      },
      {
        "]F",
        function()
          require("nvim-treesitter-textobjects.move").goto_next_end("@function.outer", "textobjects")
        end,
        mode = { "n", "x", "o" },
        desc = "Next Function End",
      },
      {
        "[f",
        function()
          require("nvim-treesitter-textobjects.move").goto_previous_start("@function.outer", "textobjects")
        end,
        mode = { "n", "x", "o" },
        desc = "Previous Function Start",
      },
      {
        "[F",
        function()
          require("nvim-treesitter-textobjects.move").goto_previous_end("@function.outer", "textobjects")
        end,
        mode = { "n", "x", "o" },
        desc = "Previous Function End",
      },

      -- Movement: classes / structs
      {
        "]c",
        function()
          require("nvim-treesitter-textobjects.move").goto_next_start("@class.outer", "textobjects")
        end,
        mode = { "n", "x", "o" },
        desc = "Next Class/Struct Start",
      },
      {
        "[c",
        function()
          require("nvim-treesitter-textobjects.move").goto_previous_start("@class.outer", "textobjects")
        end,
        mode = { "n", "x", "o" },
        desc = "Previous Class/Struct Start",
      },

      -- Movement: parameters
      {
        "]a",
        function()
          require("nvim-treesitter-textobjects.move").goto_next_start("@parameter.inner", "textobjects")
        end,
        mode = { "n", "x", "o" },
        desc = "Next Parameter",
      },
      {
        "[a",
        function()
          require("nvim-treesitter-textobjects.move").goto_previous_start("@parameter.inner", "textobjects")
        end,
        mode = { "n", "x", "o" },
        desc = "Previous Parameter",
      },
    },
    config = function()
      require("nvim-treesitter").setup()

      local parsers = {}

      -- Default core parsers load ONLY when not in VS Code
      if not vim.g.vscode then
        parsers = {
          "lua",
          "vim",
          "vimdoc",
          "query",
          "markdown",
          "markdown_inline",
          "bash",
          "json",
          "yaml",
        }
      end

      local has_local, local_settings = pcall(require, "local_settings")
      local extra_parsers = (has_local and local_settings.extra_parsers) or {}

      for _, parser in ipairs(extra_parsers) do
        table.insert(parsers, parser)
      end

      -- Explicitly trigger parser installation programmatically for the main branch
      if #parsers > 0 then
        require("nvim-treesitter").install(parsers)
      end

      -- Enable native neovim highlighting & indent
      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          pcall(vim.treesitter.start)
          -- It has proven to be unreliable
          -- vim.bo.indentexpr = "v:lua.vim.treesitter.indentexpr()"
        end,
      })

      -- Setup textobjects configuration
      require("nvim-treesitter-textobjects").setup {
        select = {
          lookahead = true,
          selection_modes = {},
          include_surrounding_whitespace = false,
        },
      }
    end,
  },
  {
    "matze/vim-move",
    cond = not vim.g.vscode,
    lazy = false,
  },
  {
    "tommcdo/vim-exchange",
    lazy = false,
  },
  {
    "kylechui/nvim-surround",
    version = "^4.0.0",
    keys = { "ys", "ds", "cs", { "S", mode = "x" } },
  },
  {
    "andymass/vim-matchup",
    cond = not vim.g.vscode,
    event = "VeryLazy",
    opts = {},
  },
  {
    "echasnovski/mini.pairs",
    cond = not vim.g.vscode,
    event = "InsertEnter",
    opts = {},
  },
}
