-- TODO: Add auto-sessions
_G.AutoSessionInfo = _G.AutoSessionInfo or {}
local suppressed_dirs = { "~/", "~/Dev", "~/Downloads", "/" }

local function is_suppressed_dir(path)
  if path ~= "" and path:sub(-1) ~= "/" then
    path = path .. "/"
  end
  path = vim.fn.expand(path)
  for _, dir in ipairs(suppressed_dirs) do
    local expanded_dir = vim.fn.expand(dir)
    if path == expanded_dir then
      return true
    end
  end

  return false
end

return {
  {
    "rmagatti/auto-session",
    lazy = false,
    opts = {
      -- Save / Load ?
      auto_save = false,
      auto_restore = true,
      post_cwd_changed_cmds = {
        function()
          require("lualine").refresh()
        end,
      },
      suppressed_dirs = suppressed_dirs,
      session_lens = {
        load_on_setup = true,
        previewer = true,
      },
    },
    keys = {
      {
        "<leader>ss",
        function()
          require("auto-session").SaveSession()
          _G.AutoSessionInfo.last_save_time = os.time()
        end,
        desc = "Save Session",
      },
      { "<leader>sr", "<cmd>SessionRestore<CR>", desc = "Restore Session" },
      { "<leader>sd", "<cmd>SessionDelete<CR>", desc = "Delete Session" },
      {
        "<leader>sf",
        function()
          local current_dir = vim.fn.getcwd()
          if not is_suppressed_dir(current_dir) then
            require("auto-session").SaveSession()
            _G.AutoSessionInfo.last_save_time = os.time()
          end
          vim.cmd("SessionSearch")
        end,
        desc = "Telescope Session + Save",
      },
      { "<leader>sF", "<cmd>SessionSearch<CR>", desc = "Telescope Session" },
    },
  },
}
