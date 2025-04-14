if true then return {} end -- TODO: Remove when finished

return {
  {
    "rebelot/heirline.nvim",
    opts = function(_, opts)
      local status = require "astroui.status"

      -- Find and remove the LSP components from the statusline
      local new_statusline = {}
      for _, component in ipairs(opts.statusline or {}) do
        -- Skip components that are the LSP status indicators
        if not (type(component) == "table" and component.provider and component.provider == status.provider.lsp) then
          table.insert(new_statusline, component)
        end
      end

      opts.statusline = new_statusline
      return opts
    end,
  },
}
