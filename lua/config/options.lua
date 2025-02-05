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

-- Disable sign column (gutter)
vim.opt.signcolumn = "no"

-- Disable providers you don't need
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_python3_provider = 0

-- Enable mouse interactions
vim.opt.mouse = "a"

-- Highlight yank
vim.api.nvim_create_autocmd("TextYankPost", {
  pattern = "*",
  callback = function()
    vim.highlight.on_yank { higroup = "IncSearch", timeout = 180 }
  end,
  group = vim.api.nvim_create_augroup("highlight_yank", { clear = true })
})
