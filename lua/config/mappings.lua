local map = vim.keymap.set

-- VS Code style Tab / Shift-Tab indenting in Visual Mode
map("v", "<Tab>", ">gv", { desc = "Indent selection" })
map("v", "<S-Tab>", "<gv", { desc = "Unindent selection" })
