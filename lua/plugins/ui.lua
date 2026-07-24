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
}
