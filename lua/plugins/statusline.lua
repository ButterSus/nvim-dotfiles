local function format_time_ago(diff)
  if diff < 60 then
    return "just now"
  elseif diff < 3600 then
    local minutes = math.floor(diff / 60)
    return string.format("%d min ago", minutes)
  elseif diff < 86400 then
    local hours = math.floor(diff / 3600)
    return string.format("%d hr ago", hours)
  else
    local days = math.floor(diff / 86400)
    return string.format("%d day%s ago", days, days > 1 and "s" or "")
  end
end

return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function()
      local function auto_session_status()
        -- Check if there's an active session
        local session_name = require("auto-session.lib").current_session_name(true)
        if session_name == "" then
          return "󰒲  No Session"
        end
        if _G.AutoSessionInfo and _G.AutoSessionInfo.last_save_time then
          local current_time = os.time()
          local diff = os.difftime(current_time, _G.AutoSessionInfo.last_save_time)
          return string.format("󱣪 Saved %s", format_time_ago(diff))
        end
        return "󱙃 Not Saved"
      end
      return {
        options = {
          theme = "auto",
          component_separators = "|",
          section_separators = "",
          globalstatus = true,
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = { "filename" },
          lualine_x = { auto_session_status, "filetype" },
          lualine_y = {},
          lualine_z = { "location" },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { "filename" },
          lualine_x = { "location" },
          lualine_y = {},
          lualine_z = {},
        },
      }
    end,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
  },
}
