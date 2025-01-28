-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Line swapping
vim.keymap.set("n", "<leader>j", ":m .+1<CR>==", { desc = "Move line down", silent = true })
vim.keymap.set("n", "<leader>k", ":m .-2<CR>==", { desc = "Move line up", silent = true })
vim.keymap.set("x", "<leader>j", ":m '>+1<CR>gv=gv", { desc = "Move selection down", silent = true })
vim.keymap.set("x", "<leader>k", ":m '<-2<CR>gv=gv", { desc = "Move selection up", silent = true })

-- Indent in Visual Mode
vim.keymap.set("v", "<Tab>", ">gv", { desc = "Indent selection" })
vim.keymap.set("v", "<S-Tab>", "<gv", { desc = "Unindent selection" })

-- Undo/Redo
vim.keymap.set({ "n", "x", "i" }, "<C-z>", "<cmd>undo<CR>", { desc = "Undo", silent = true })
vim.keymap.set({ "n", "x", "i" }, "<C-y>", "<cmd>redo<CR>", { desc = "Redo", silent = true })

-- Exit & Restart
vim.keymap.set("n", "<leader>q", "<cmd>wqa<CR>", { desc = "Quit all", silent = true })
vim.keymap.set("n", "<leader>Q", "<cmd>qa!<CR>", { desc = "Restart Neovim", silent = true })
