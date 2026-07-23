-- This file should be 100% compatible with Visual Studio Code
-- use vim.g.vscode to exclude logic

return {
  {
    "matze/vim-move",
    cond = not vim.g.vscode,
    lazy = false,
  },
}
