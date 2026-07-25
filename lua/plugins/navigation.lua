-- VSCode specific navigation

local vscode = require "vscode"

local function action(cmd, args)
  return function()
    vscode.action(cmd, { args = args })
  end
end

local has_local, local_settings = pcall(require, "local_settings")
local file_explorer = (has_local and local_settings.file_explorer) or "vscode"

if file_explorer == "vscode" then
  vim.keymap.set("n", "<leader>e", action "workbench.view.explorer", { desc = "File Explorer" })
else
  vim.keymap.set("n", "<leader>e", action "oil-code.open", { desc = "File Explorer" })

  vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
    callback = function()
      if vim.bo.filetype == "oil" then
        vim.keymap.set("n", "<C-o>", action "oil-code.close", { buffer = true })
      end
    end,
  })
end

return {}
