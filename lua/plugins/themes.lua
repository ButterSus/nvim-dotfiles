return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
  },
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
  },
  {
    "rebelot/kanagawa.nvim",
    priority = 1000,
  },
  {
    "rose-pine/neovim",
    name = "rose-pine",
    priority = 1000,
  },
  {
    "projekt0n/github-nvim-theme",
    priority = 1000,
  },
  -- Theme switcher
  {
    "zaldih/themery.nvim",
    lazy = false,
    opts = {
      themes = {
        "tokyonight",
        "tokyonight-night",
        "tokyonight-storm",
        "tokyonight-day",
        "tokyonight-moon",
        "catppuccin",
        "catppuccin-latte",
        "catppuccin-frappe",
        "catppuccin-macchiato",
        "catppuccin-mocha",
        "gruvbox",
        "kanagawa",
        "kanagawa-wave",
        "kanagawa-dragon",
        "kanagawa-lotus",
        "rose-pine",
        "rose-pine-moon",
        "rose-pine-dawn",
        "github_dark",
        "github_dark_dimmed",
        "github_dark_high_contrast",
        "github_light",
        "github_light_high_contrast",
      },
      livePreview = true,
      globalAfter = [[
        vim.api.nvim_set_hl(0, "GitSignsIgnored", { fg = "#777777", italic = true })
        vim.api.nvim_set_hl(0, "GitSignsAddNr", { fg = "#d4d4d4", bg = "#2a4d3e" })
        vim.api.nvim_set_hl(0, "GitSignsChangeNr", { fg = "#d4d4d4", bg = "#34415d" })
        vim.api.nvim_set_hl(0, "GitSignsDeleteNr", { fg = "#d4d4d4", bg = "#55393d" })
        vim.api.nvim_set_hl(0, "GitSignsChangedeleteNr", { link = "GitSignsChangeNr" })
        vim.api.nvim_set_hl(0, "GitSignsTopdeleteNr", { link = "GitSignsDeleteNr" })
        vim.api.nvim_set_hl(0, "GitSignsUntrackedNr", { link = "GitSignsAddNr" })
      ]],
    },
    keys = {
      { "<leader>ct", "<cmd>Themery<CR>", desc = "Theme switcher" },
    },
  },
}
