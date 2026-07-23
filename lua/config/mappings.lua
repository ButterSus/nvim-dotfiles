-- This file should be 100% compatible with Visual Studio Code
-- use vim.g.vscode to exclude logic

local map = vim.keymap.set

-- VS Code style Tab / Shift-Tab indenting in Visual Mode
map("v", "<Tab>", ">gv", { desc = "Indent Selection" })
map("v", "<S-Tab>", "<gv", { desc = "Unindent Selection" })
