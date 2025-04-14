-- Utility module for handling placeholder buffers
local M = {}

-- Create a placeholder buffer and display it
-- @return buffer number of the created placeholder
function M.create_placeholder_buffer()
  -- Create a placeholder buffer
  local placeholder_buf = vim.api.nvim_create_buf(false, true)
  
  -- Set buffer options (keep modifiable true until we set lines)
  vim.bo[placeholder_buf].buftype = "nofile"
  vim.bo[placeholder_buf].bufhidden = "wipe"
  vim.bo[placeholder_buf].swapfile = false
  vim.bo[placeholder_buf].buflisted = false
  
  -- Function to center text horizontally
  local function centered_text(text)
    local width = vim.api.nvim_win_get_width(0)
    -- Subtract 6 for better horizontal alignment, accounting for sign column and number column
    local shift = math.floor((width - 6) / 2) - math.floor(string.len(text) / 2)
    return string.rep(' ', shift > 0 and shift or 0) .. text
  end

  -- Function to update buffer content with proper centering
  local function update_buffer_content()
    if not vim.api.nvim_buf_is_valid(placeholder_buf) then return end
    
    vim.bo[placeholder_buf].modifiable = true
    
    -- Get window height for vertical centering
    local height = vim.api.nvim_win_get_height(0)
    local content = {}
    
    -- Add empty lines for vertical centering (about 1/3 down from the top)
    local top_padding = math.floor(height / 3)
    for _ = 1, top_padding do
      table.insert(content, "")
    end
    
    -- Add the actual content
    table.insert(content, centered_text("Empty Buffer Placeholder"))
    table.insert(content, "")
    table.insert(content, centered_text("Press <leader>ff to find files"))
    table.insert(content, centered_text("Press <leader>fo to open recent files"))
    table.insert(content, centered_text("Press <leader>n to create a new file"))
    table.insert(content, centered_text("Press <leader>e to explore filetree"))
    
    vim.api.nvim_buf_set_lines(placeholder_buf, 0, -1, false, content)
    vim.bo[placeholder_buf].modifiable = false
  end

  -- Initialize the content
  update_buffer_content()
  
  -- Add autocmd to recenter text when window is resized
  vim.api.nvim_create_autocmd({"VimResized", "WinScrolled"}, {
    buffer = placeholder_buf,
    callback = update_buffer_content
  })
  
  -- Set buffer as non-modifiable after setting content
  vim.bo[placeholder_buf].modifiable = false
  vim.bo[placeholder_buf].filetype = "placeholder"
  
  -- Set buffer name
  vim.api.nvim_buf_set_name(placeholder_buf, "[Placeholder]")
  
  return placeholder_buf
end

-- Checks if a buffer is a placeholder buffer
-- @param bufnr The buffer number to check
-- @return boolean True if the buffer is a placeholder
function M.is_placeholder_buffer(bufnr)
  if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) then return false end
  
  local buf_name = vim.api.nvim_buf_get_name(bufnr)
  return buf_name:match ".*%[Placeholder%].*" ~= nil
end

return M 