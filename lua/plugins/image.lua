if true then return {} end -- TODO: fix this

-- Override only the enabled setting for image.nvim from astrocommunity
return {
  {
    "3rd/image.nvim",
    optional = true, -- This makes the plugin optional and prevents errors if not found
    cond = vim.env.TERM == "xterm-kitty",
    build = false,
  },
}
