-- Split management with Oil integration
vim.keymap.set("n", "<leader>wh", function()
  vim.cmd("split")
end, { silent = true, desc = "Split horizontal" })

vim.keymap.set("n", "<leader>wv", function()
  vim.cmd("vsplit")
end, { silent = true, desc = "Split vertical" })

-- Split management
vim.keymap.set("n", "<leader>ws", "<C-w>x", { silent = true, desc = "Swap splits" })
vim.keymap.set("n", "<leader>wo", "<C-w>o", { silent = true, desc = "Only keep current split" })

-- Split resizing
vim.keymap.set("n", "-", ":vertical resize -2<CR>", { silent = true })
vim.keymap.set("n", "=", ":vertical resize +2<CR>", { silent = true })
vim.keymap.set("n", "_", ":resize -2<CR>", { silent = true })
vim.keymap.set("n", "+", ":resize +2<CR>", { silent = true })
