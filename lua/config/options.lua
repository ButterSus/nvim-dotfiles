vim.opt.mousemoveevent = true

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 10

vim.opt.splitkeep = "screen"

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 2

-- use number of spaces to insert a <Tab>
vim.opt.expandtab = true

vim.opt.swapfile = false

vim.opt.splitright = true
vim.opt.splitbelow = true

-- highlight the line number of the cursor
vim.opt.cursorline = true
vim.opt.cursorlineopt = "number"

vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

vim.opt.termguicolors = true
vim.opt.cmdheight = 0

-- Use system clipboard by default
vim.opt.clipboard = "unnamedplus"

-- Disable gf mapping
vim.keymap.set("n", "gf", "<Nop>", { noremap = true })
vim.keymap.set("x", "gf", "<Nop>", { noremap = true })
