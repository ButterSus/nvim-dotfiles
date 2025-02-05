-- Split management with Oil integration
vim.keymap.set('n', 'sh', function()
  if vim.bo.filetype == "oil" then
    vim.cmd("Oil")
    vim.cmd("split")
    vim.cmd("Oil")
  else
    vim.cmd("split")
  end
end, { silent = true, desc = "Split horizontal" })

vim.keymap.set('n', 'sv', function()
  if vim.bo.filetype == "oil" then
    vim.cmd("Oil")
    vim.cmd("vsplit")
    vim.cmd("Oil")
  else
    vim.cmd("vsplit")
  end
end, { silent = true, desc = "Split vertical" })

-- -- Split management
vim.keymap.set('n', 'ss', '<C-w>x', { silent = true, desc = "Swap splits" })
vim.keymap.set('n', 'so', '<C-w>o', { silent = true, desc = "Only keep current split" })

-- -- Tab management with Oil integration
vim.keymap.set('n', '<leader>tn', function()
  vim.cmd("tabnew")
  vim.cmd("Oil")
end, { silent = true, desc = "New tab with Oil" })

-- Split resizing
vim.keymap.set('n', '-', ':vertical resize -2<CR>', { silent = true })
vim.keymap.set('n', '=', ':vertical resize +2<CR>', { silent = true })
vim.keymap.set('n', '_', ':resize -2<CR>', { silent = true })
vim.keymap.set('n', '+', ':resize +2<CR>', { silent = true })
