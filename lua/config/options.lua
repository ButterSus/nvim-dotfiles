local opt = vim.opt

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Tabs & Indentation
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smartindent = true

-- Search & UI
opt.ignorecase = true
opt.smartcase = true
opt.termguicolors = true
opt.signcolumn = "yes"
opt.cursorline = true

-- System Clipboard integration
opt.clipboard = "unnamedplus"

-- Save undo history across Neovim sessions
opt.undofile = true
opt.updatetime = 250

-- Disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local vscode = require "vscode"

vim.notify = vscode.notify
