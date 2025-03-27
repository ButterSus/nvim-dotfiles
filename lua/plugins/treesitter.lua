---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  opts = {
    ensure_installed = {
      "lua",
      "vim",
    },
    highlight = {
      enable = false,
    },
    indent = {
      enable = false,
    },
    textobjects = {
      enable = false,
    },
  },
}
