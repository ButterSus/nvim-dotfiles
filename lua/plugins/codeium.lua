return {
  {
    "Exafunction/codeium.nvim",
    event = "User AstroFile",
    cmd = "Codeium",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "hrsh7th/nvim-cmp",
      "AstroNvim/astroui",
    },
    opts = {
      enable_chat = true,
      enable_cmp_source = true,
    },
    config = function(_, opts)
      -- Get the Codeium icon from astroui
      local codeium_icon = require("astroui").get_icon("Codeium", 1, true)

      require("codeium").setup(opts)

      -- Setup keybindings
      vim.keymap.set("n", "<Leader>;", function() end, { desc = codeium_icon .. " Codeium" })
      vim.keymap.set("n", "<Leader>;o", function() vim.cmd "Codeium Chat" end, { desc = "Open Chat" })
    end,
  },
}
