return {
  {
    "nvimtools/none-ls.nvim",  -- fork of null-ls
    dependencies = { "nvim-lua/plenary.nvim" },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local null_ls = require("null-ls")

      null_ls.setup({
        sources = {
          -- Python
          null_ls.builtins.diagnostics.ruff,
        }
      })
    end
  }
} 