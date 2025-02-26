-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Line swapping
vim.keymap.set("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down", silent = true })
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up", silent = true })
vim.keymap.set("x", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down", silent = true })
vim.keymap.set("x", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up", silent = true })

-- Indent in Visual Mode
vim.keymap.set("v", "<Tab>", ">gv", { desc = "Indent selection" })
vim.keymap.set("v", "<S-Tab>", "<gv", { desc = "Unindent selection" })

-- Undo/Redo
vim.keymap.set({ "n", "x", "i" }, "<C-z>", "<cmd>undo<CR>", { desc = "Undo", silent = true })
vim.keymap.set({ "n", "x", "i" }, "<C-y>", "<cmd>redo<CR>", { desc = "Redo", silent = true })

-- Exit & Restart
vim.keymap.set("n", "<leader>q", function()
  -- Kill all terminals first, then quit all
  require("toggleterm").kill_all_terms()
  vim.cmd("wqa")
end, { desc = "Quit all", silent = true })
vim.keymap.set("n", "<leader>Q", "<cmd>qa!<CR>", { desc = "Force Quit All", silent = true })

-- Lazy
vim.keymap.set("n", "<leader>L", "<cmd>Lazy<CR>", { desc = "Open Lazy", silent = true })

-- Telescope keymaps
vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Find Files", silent = true })
vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", { desc = "Live Grep", silent = true })
vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "List Buffers", silent = true })
vim.keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "Help Tags", silent = true })

-- Hunk keymaps
vim.keymap.set("n", ",", function()
  require("gitsigns").nav_hunk("prev")
end, { desc = "Previous git hunk" })

vim.keymap.set("n", ".", function()
  require("gitsigns").nav_hunk("next")
end, { desc = "Next git hunk" })

vim.keymap.set("n", "H", "^", { desc = "Go to first non-blank char in line" })
vim.keymap.set("n", "L", "$", { desc = "Go to end-of-line" })

vim.keymap.set("n", "<Esc>", ":noh<CR>", { desc = "Clear search highlights", silent = true })
vim.keymap.set("n", ";", ":", { desc = "Enter command-line mode" })
vim.keymap.set("n", "<C-o>", "<C-o>zz", { desc = "Jump back then recenter", silent = true })
vim.keymap.set("n", "<C-i>", "<C-i>zz", { desc = "Jump forward then recenter", silent = true })

-- Normal mode: remap J and K for 6-line movement
vim.keymap.set("n", "J", "6j", { desc = "Move 6 lines down" })
vim.keymap.set("n", "K", "6k", { desc = "Move 6 lines up" })

-- Map U to the native join (like pressing "J" in normal mode)
vim.keymap.set("n", "U", function()
  vim.cmd("normal! J")
end, { desc = "Join line with next line (native)", silent = true })

-- Map <A-CR> in insert mode to act as a regular enter
vim.keymap.set("i", "<A-CR>", function()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, true, true), "n", false)
end, { desc = "Insert line below" })

-- Search for selected text
vim.keymap.set("x", "//", 'y/<C-R>"<CR>N', { desc = "Search for selected text", silent = true })
