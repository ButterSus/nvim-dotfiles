---@type LazySpec
return {
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      ensure_installed = {
        "lua_ls",
      },
    },
  },
  {
    "jay-babu/mason-null-ls.nvim",
    opts = function(_, opts)
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, {
        "stylua",
      })
    end,
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    opts = function(_, opts)
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, {
        "python",
      })
    end,
  },
}
