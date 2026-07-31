-- This file should be 100% compatible with Visual Studio Code
-- use vim.g.vscode to exclude logic

local map = vim.keymap.set

-- VS Code style Tab / Shift-Tab indenting in Visual Mode
map("v", "<Tab>", ">gv", { desc = "Indent Selection" })
map("v", "<S-Tab>", "<gv", { desc = "Unindent Selection" })

if not vim.g.vscode then
  map("n", "<Tab>", "<cmd>bnext<cr>", { desc = "Next Buffer" })
  map("n", "<S-Tab>", "<cmd>bprevious<cr>", { desc = "Previous Buffer" })
else
  -- editor.action.nextEditor
  map("n", "<Tab>", function()
    require("vscode").action "workbench.action.nextEditor"
  end, { desc = "Next Buffer" })
  map("n", "<S-Tab>", function()
    require("vscode").action "workbench.action.previousEditor"
  end, { desc = "Previous Buffer" })
end

if vim.g.vscode then
  map("n", "|", function()
    require("vscode").action "workbench.action.splitEditor"
  end, { desc = "Split Vertically" })
  map("n", "\\", function()
    require("vscode").action "workbench.action.splitEditorDown"
  end, { desc = "Split Horizontally" })
else
  map("n", "|", "<cmd>vsplit<cr>", { desc = "Split Vertically" })
  map("n", "\\", "<cmd>split<cr>", { desc = "Split Horizontally" })
end

if not vim.g.vscode then
  -- Lazy
  map("n", "<leader>L", "<cmd>Lazy<cr>", { desc = "Open Lazy Dashboard" })

  map("n", "<leader>Q", "<cmd>qa<cr>", { desc = "Quit All" })

  -- Seamless window navigation with Ctrl+hjkl
  vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
  vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to lower window" })
  vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to upper window" })
  vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })
end
