return {
  -- Codeium AI
  {
    "Exafunction/codeium.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "hrsh7th/nvim-cmp",
    },
    config = function()
      require("codeium").setup({
        enable_cmp_source = false,
        virtual_text = {
          enabled = true,
          map_keys = true,
          key_bindings = {
            accept = "<A-i>",
            next = "<A-]>",
            prev = "<A-[>",
          },
        },
      })
    end,
  },
}
