-- Indent in Visual Mode
vim.keymap.set("v", "<Tab>", ">gv", { desc = "Indent selection" })
vim.keymap.set("v", "<S-Tab>", "<gv", { desc = "Unindent selection" })

-- Search selection
vim.keymap.set("x", "//", 'y/<C-R>"<CR>N', { desc = "Search for selected text", silent = true })

-- Split resizing
vim.keymap.set("n", "-", ":vertical resize -2<CR>", { silent = true, desc = "Decrease width" })
vim.keymap.set("n", "=", ":vertical resize +2<CR>", { silent = true, desc = "Increase width" })
vim.keymap.set("n", "_", ":resize -2<CR>", { silent = true, desc = "Decrease height" })
vim.keymap.set("n", "+", ":resize +2<CR>", { silent = true, desc = "Increase height" })

-- Enter Normal mode in Terminal
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { noremap = true })

-- Reset highlight
vim.keymap.set({ "n" }, "<Esc>", ":noh<CR>", { silent = true })
