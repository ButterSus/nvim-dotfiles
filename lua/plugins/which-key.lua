return {
  "folke/which-key.nvim",
  opts = function(_, _)
    local wk = require "which-key"
    wk.add {
      { "<leader>m", group = "󰆾 MultiCursor" },
    }
  end,
}
