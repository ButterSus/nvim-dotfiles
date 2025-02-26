local M = {}

-- Cache table to store git status information
M.git_cache = {
  status_cache = {},
  root_cache = {},
  last_dir = nil,
}

-- Function to clear cache when directory changes
local function clear_cache_if_needed(current_dir)
  if M.git_cache.last_dir ~= current_dir then
    M.git_cache.status_cache = {}
    M.git_cache.root_cache = {}
    M.git_cache.last_dir = current_dir
  end
end

-- Function to get git root with caching
local function get_cached_git_root(current_dir)
  if M.git_cache.root_cache[current_dir] == nil then
    local git_root =
      vim.fn.systemlist("git -C " .. vim.fn.shellescape(current_dir) .. " rev-parse --show-toplevel 2>/dev/null")[1]
    M.git_cache.root_cache[current_dir] = git_root and vim.v.shell_error == 0 and git_root or false
  end
  return M.git_cache.root_cache[current_dir]
end

-- Function to get git status for all files in directory with caching
local function get_cached_git_status(current_dir)
  if M.git_cache.status_cache[current_dir] == nil then
    local git_root = get_cached_git_root(current_dir)
    if not git_root then
      M.git_cache.status_cache[current_dir] = false
      return false
    end

    -- Use --untracked-files=all to include untracked files
    local git_status =
      vim.fn.systemlist("git -C " .. vim.fn.shellescape(current_dir) .. " status --porcelain --untracked-files=all")

    if vim.v.shell_error == 0 then
      M.git_cache.status_cache[current_dir] = {}
      for _, status_line in ipairs(git_status) do
        local status_code = status_line:sub(1, 2)
        local file_name = status_line:sub(4)
        M.git_cache.status_cache[current_dir][file_name] = status_code
      end
    else
      M.git_cache.status_cache[current_dir] = false
    end
  end

  return M.git_cache.status_cache[current_dir]
end

-- Main highlight function
function M.highlight_filename(entry, is_hidden, is_link_target, is_link_orphan)
  -- Only process files, not directories
  if entry.type == "directory" or entry.name == ".." then
    return nil
  end

  local current_dir = require("oil").get_current_dir()
  if not current_dir then
    return nil
  end

  -- Clear cache if directory changed
  clear_cache_if_needed(current_dir)

  -- Check if we're in a git repository
  local git_root = get_cached_git_root(current_dir)
  if not git_root then
    return nil
  end

  -- Get cached status for current directory
  local status_cache = get_cached_git_status(current_dir)
  if not status_cache then
    return nil
  end

  -- Get relative path to git root
  local rel_path = vim.fn.fnamemodify(
    vim.fn.resolve(current_dir .. "/" .. entry.name), -- Resolve full path of the file
    ":." .. git_root -- Make it relative to the git root
  )

  -- Get status for current file from cache
  local status_code = status_cache[rel_path]
  if not status_code then
    return nil
  end

  -- Map status codes to GitSigns highlight groups
  if status_code == "??" then
    return "GitSignsUntracked"
  elseif status_code:match("^A") then
    return "GitSignsAdd"
  elseif status_code:match("^M") or status_code:match("^ M") then
    return "GitSignsChange"
  elseif status_code:match("^D") or status_code:match("^ D") then
    return "GitSignsDelete"
  end

  return nil
end

return M
