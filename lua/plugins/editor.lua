-- This file should be 100% compatible with Visual Studio Code
-- use vim.g.vscode to exclude logic

-- Flash text briefly on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank {
      higroup = "IncSearch",
      timeout = 200,
    }
  end,
})

local has_local, local_settings = pcall(require, "local_settings")
local extra_parsers = (has_local and local_settings.extra_parsers) or {}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    -- This plugin does not support lazy-loading.
    lazy = false,
    build = ":TSUpdate",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
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

      for _, parser in ipairs(extra_parsers) do
        table.insert(parsers, parser)
      end

      -- Explicitly trigger parser installation programmatically for the main branch
      if #parsers > 0 then
        require("nvim-treesitter").install(parsers)
      end

      -- 3. Enable Native Neovim Highlighting & Indent
      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          pcall(vim.treesitter.start)
          vim.bo.indentexpr = "v:lua.vim.treesitter.indentexpr()"
        end,
      })

      -- 4. Setup Textobjects Configuration
      require("nvim-treesitter-textobjects").setup {
        select = {
          lookahead = true,
          selection_modes = {},
          include_surrounding_whitespace = false,
        },
      }

      -- 5. Textobjects Keymaps
      vim.keymap.set({ "x", "o" }, "af", function()
        require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects")
      end, { desc = "Select Around Function" })
      vim.keymap.set({ "x", "o" }, "if", function()
        require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects")
      end, { desc = "Select Inner Function" })

      vim.keymap.set({ "x", "o" }, "ac", function()
        require("nvim-treesitter-textobjects.select").select_textobject("@class.outer", "textobjects")
      end, { desc = "Select Around Class" })
      vim.keymap.set({ "x", "o" }, "ic", function()
        require("nvim-treesitter-textobjects.select").select_textobject("@class.inner", "textobjects")
      end, { desc = "Select Inner Class" })

      vim.keymap.set({ "x", "o" }, "aa", function()
        require("nvim-treesitter-textobjects.select").select_textobject("@parameter.outer", "textobjects")
      end, { desc = "Select Around Argument" })
      vim.keymap.set({ "x", "o" }, "ia", function()
        require("nvim-treesitter-textobjects.select").select_textobject("@parameter.inner", "textobjects")
      end, { desc = "Select Inner Argument" })

      vim.keymap.set({ "x", "o" }, "as", function()
        require("nvim-treesitter-textobjects.select").select_textobject("@local.scope", "locals")
      end, { desc = "Select Language Scope" })
    end,
  },
  {
    "matze/vim-move",
    cond = not vim.g.vscode,
    lazy = false,
  },
}
