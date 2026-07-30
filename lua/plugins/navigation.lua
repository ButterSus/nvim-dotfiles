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

-- Buffer Actions
vim.keymap.set("n", "<leader>bc", action "workbench.action.closeActiveEditor", { desc = "Close Buffer" })
vim.keymap.set("n", "<leader>bC", action "workbench.action.closeActiveEditor", { desc = "Force Close Buffer" })
vim.keymap.set("n", "<leader>ba", action "workbench.action.closeEditorsInGroup", { desc = "Close All Buffers" })
vim.keymap.set("n", "<leader>bo", action "workbench.action.closeOtherEditors", { desc = "Close Other Buffers" })
vim.keymap.set(
  "n",
  "<leader>bl",
  action "workbench.action.closeEditorsToTheRight",
  { desc = "Close Buffers to the Right" }
)
vim.keymap.set(
  "n",
  "<leader>bh",
  action "workbench.action.closeEditorsToTheLeft",
  { desc = "Close Buffers to the Left" }
)

return {}
