-- VSCode specific navigation

local vscode = require "vscode"
local map = vim.keymap.set
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
  callback = function()
    map("n", "<leader>e", function()
      vscode.action "oil-code.open"
    end)
  end,
})

return {}
