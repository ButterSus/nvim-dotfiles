local lsp_util = vim.lsp.util

-- Check if a line contains non-whitespace characters
local function has_content(line)
  return line and line:match("%S") ~= nil
end

-- Check if the given range fully contains the line's content (excluding whitespace)
local function is_complete_line(line, start_col, end_col)
  if not line then
    return false
  end

  -- Find first and last non-whitespace characters
  local content_start = line:find("%S")
  local content_end = line:reverse():find("%S")
  if not content_start or not content_end then
    return true -- Empty or whitespace-only line
  end
  content_end = #line - content_end + 1

  -- Check if our range contains the entire content
  return start_col <= content_start and end_col >= content_end
end

-- Expand selection until we have complete lines
local function expand_to_complete_lines(bufnr, node)
  if not node then
    return nil
  end

  local start_row, start_col, end_row, end_col = node:range()
  local lines = vim.api.nvim_buf_get_lines(bufnr, start_row, end_row + 1, false)

  -- If we already have complete lines, return current node
  if
    #lines > 0
    and (lines[1] and is_complete_line(lines[1], start_col, #lines[1]))
    and (#lines == 1 or is_complete_line(lines[#lines], 1, end_col))
  then
    return node
  end

  -- Try parent nodes until we find one that contains complete lines
  local current = node
  while current:parent() do
    current = current:parent()
    start_row, start_col, end_row, end_col = current:range()
    lines = vim.api.nvim_buf_get_lines(bufnr, start_row, end_row + 1, false)

    if
      #lines > 0
      and (lines[1] and is_complete_line(lines[1], start_col, #lines[1]))
      and (#lines == 1 or is_complete_line(lines[#lines], 1, end_col))
    then
      return current
    end
  end

  return current -- Return the largest node if no better match found
end

local function get_definition_preview(bufnr, pos)
  -- Build parameters for LSP's "textDocument/definition" request
  local params = lsp_util.make_position_params()
  if pos and type(pos) == "table" and #pos >= 2 then
    params.position.line = pos[1] - 1
    params.position.character = pos[2]
  end

  local results = vim.lsp.buf_request_sync(bufnr, "textDocument/definition", params, 1000)
  if not results or vim.tbl_isempty(results) then
    return nil
  end

  local def_location = nil
  for _, res in pairs(results) do
    if res.result and not vim.tbl_isempty(res.result) then
      if vim.tbl_islist(res.result) then
        def_location = res.result[1]
      else
        def_location = res.result
      end
      break
    end
  end
  if not def_location then
    return nil
  end

  local uri = def_location.uri or def_location.targetUri
  if not uri then
    return nil
  end

  local filename = vim.uri_to_fname(uri)
  local range = def_location.range or def_location.targetSelectionRange

  -- Get target buffer and ensure it's loaded
  local target_bufnr
  if vim.fn.bufexists(filename) == 1 then
    target_bufnr = vim.fn.bufnr(filename)
  else
    target_bufnr = vim.fn.bufadd(filename)
    vim.fn.bufload(target_bufnr)
  end

  -- Get initial node at definition location
  local parser = vim.treesitter.get_parser(target_bufnr)
  if not parser then
    return nil
  end

  local tree = parser:parse()[1]
  if not tree then
    return nil
  end

  local root = tree:root()
  local start_node =
    root:named_descendant_for_range(range.start.line, range.start.character, range.start.line, range.start.character)

  if not start_node then
    return nil
  end

  -- Expand selection to get complete lines
  local expanded_node = expand_to_complete_lines(target_bufnr, start_node)
  if not expanded_node then
    return nil
  end

  -- Get the expanded range
  local start_row, start_col, end_row, end_col = expanded_node:range()

  -- Get lines for the expanded node
  local lines = vim.api.nvim_buf_get_lines(target_bufnr, start_row, end_row + 1, false)

  -- Process the lines
  if #lines > 0 then
    -- Handle first line
    if start_col > 0 then
      lines[1] = lines[1]:sub(start_col + 1)
    end

    -- Handle last line
    if #lines > 1 then
      lines[#lines] = lines[#lines]:sub(1, end_col)
    end

    -- Remove leading/trailing empty lines while preserving internal ones
    while #lines > 0 and not has_content(lines[1]) do
      table.remove(lines, 1)
    end
    while #lines > 0 and not has_content(lines[#lines]) do
      table.remove(lines)
    end
  end

  return lines
end

local provider = {
  name = "USH", -- Universal Smart Hover
  priority = 10,
  enabled = function(opts)
    if type(opts) ~= "table" then
      opts = { bufnr = vim.api.nvim_get_current_buf() }
    end

    local bufnr = opts.bufnr or vim.api.nvim_get_current_buf()
    local ok, parser = pcall(vim.treesitter.get_parser, bufnr)
    return ok and parser ~= nil
  end,
  execute = function(opts, done)
    if type(opts) ~= "table" then
      opts = { bufnr = vim.api.nvim_get_current_buf() }
    end

    local bufnr = opts.bufnr or vim.api.nvim_get_current_buf()
    local pos = opts.pos or vim.api.nvim_win_get_cursor(0)
    local preview = get_definition_preview(bufnr, pos)

    if preview then
      done({
        lines = preview,
        filetype = vim.bo[bufnr].filetype,
      })
    else
      done(false)
    end
  end,
}

require("hover").register(provider)
return provider
