-- This file should be 100% compatible with Visual Studio Code
-- use vim.g.vscode to exclude logic

return {
  {
    "nvim-treesitter/nvim-treesitter",
    -- This plugin does not support lazy-loading.
    lazy = false,
    build = ":TSUpdate",
  },
  {
    "matze/vim-move",
    cond = not vim.g.vscode,
    lazy = false,
  },
}
