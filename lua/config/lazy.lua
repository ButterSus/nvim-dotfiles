-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Handle directory argument before lazy setup
local function handle_directory_arg()
  local raw_arg = vim.fn.argv(0)
  if not raw_arg or raw_arg == "" then
    return
  end

  -- Remove oil:// prefix if present
  local arg = raw_arg:gsub("^oil://", "")
  local stat = vim.loop.fs_stat(arg)

  if stat and stat.type == "directory" then
    -- Change directory without using shellescape
    vim.cmd.cd(arg)
    -- Schedule NvimTree opening after lazy load
    vim.schedule(function()
      require("nvim-tree.api").tree.open()
      -- Focus the editor window
      vim.cmd("wincmd p")
    end)
  end
end

-- Execute directory handling
handle_directory_arg()

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    {
      import = "plugins",
    },
  },
  change_detection = {
    notify = false,
  },
  install = { colorscheme = { "gruvbox" } },
  checker = { enabled = false },
}, {
  -- Run directory handling after lazy setup
  ui = {
    custom_keys = {
      ["<CR>"] = handle_directory_arg,
    },
  },
})
