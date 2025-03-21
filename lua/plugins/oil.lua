return {
  {
    "stevearc/oil.nvim",
    -- Preserve community configuration while overriding specific options
    opts = function(_, opts)
      return vim.tbl_deep_extend("force", opts, { -- Merges with existing opts
        keymaps = {
          ["<A-v>"] = { "actions.select", opts = { vertical = true } },
          ["<C-s>"] = false,
          ["<A-h>"] = { "actions.select", opts = { horizontal = true } },
          ["<C-h>"] = false,
          ["<A-t>"] = { "actions.select", opts = { tab = true } },
          ["<C-t>"] = false,
          ["<A-p>"] = "actions.preview",
          ["<C-p>"] = false,
          ["<A-c>"] = { "actions.close", mode = "n" },
          ["<C-c>"] = false,
          ["<A-l>"] = "actions.refresh",
          ["<C-l>"] = false,
        },
      })
    end,
  },
}
