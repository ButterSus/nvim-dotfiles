-- VSCode specific UI mappings

local vscode = require "vscode"

local function action(cmd, args)
  return function()
    vscode.action(cmd, { args = args })
  end
end

vim.keymap.set("n", "<leader>t", action "workbench.action.terminal.toggleTerminal", { desc = "Toggle Terminal" })

return {}
