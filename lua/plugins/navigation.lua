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

-- Picker Actions
vim.keymap.set("n", "<leader>ff", action "workbench.action.quickOpen", { desc = "Find Files" })
vim.keymap.set("n", "<leader>fw", action "workbench.action.findInFiles", { desc = "Live Grep" })
vim.keymap.set("n", "<leader>fb", action "workbench.action.showAllEditors", { desc = "Find Buffers" })
vim.keymap.set("n", "<leader>fo", action "workbench.action.openRecent", { desc = "Recent Folders" })
vim.keymap.set("n", "<leader>fs", action "workbench.action.gotoSymbol", { desc = "LSP Symbols" })
vim.keymap.set("n", "<leader>fd", action "workbench.actions.view.problems", { desc = "Diagnostics" })
vim.keymap.set("n", "<leader>fq", action "workbench.panel.markers.view.focus", { desc = "Quickfix/Problems" })
vim.keymap.set("x", "<leader>fc", action "workbench.action.findInFiles", { desc = "Grep Word/Selection" })
vim.keymap.set("n", "<leader>fc", function()
  local word = vim.fn.expand "<cword>"
  vscode.action("workbench.action.findInFiles", { args = { query = word } })
end, { desc = "Grep Word/Selection" })
vim.keymap.set("n", "<leader>fk", action "workbench.action.openGlobalKeybindings", { desc = "Keymaps" })
vim.keymap.set("n", "<leader>fp", action "workbench.view.extensions", { desc = "Extensions" })

return {}
