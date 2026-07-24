-- This file should be 100% compatible with Visual Studio Code
-- use vim.g.vscode to exclude logic

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
    end,
  },
  {
    "matze/vim-move",
    cond = not vim.g.vscode,
    lazy = false,
  },
}
