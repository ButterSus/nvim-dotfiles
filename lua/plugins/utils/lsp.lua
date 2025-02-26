-- In lsp.lua:
local M = {}

M.generate_filelist_and_reload = function(root_dir)
  if not root_dir then
    vim.notify("No root directory specified", vim.log.levels.ERROR)
    return
  end

  local cmd = string.format(
    "find %s -type f -name '*.sv' -o -name '*.svh' -o -name '*.v' > %s/verible.filelist",
    vim.fn.shellescape(root_dir),
    vim.fn.shellescape(root_dir)
  )

  vim.fn.system(cmd)

  -- Check if file was created successfully
  if vim.fn.filereadable(root_dir .. "/verible.filelist") == 1 then
    -- Check if Verible LSP is active in any buffer
    local has_verible = false
    for _, client in pairs(vim.lsp.get_clients()) do
      if client.name == "verible" then
        has_verible = true
        break
      end
    end
    -- Reload Verible LSP
    if has_verible then
      vim.cmd("LspRestart verible")
    end
    vim.notify("Generated verible.filelist in " .. root_dir .. " and reloaded LSP", vim.log.levels.INFO)
  else
    vim.notify("Failed to generate verible.filelist in " .. root_dir, vim.log.levels.ERROR)
  end
end

-- Add this at the end of the file:
return M
