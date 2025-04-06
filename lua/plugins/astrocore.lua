---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    -- Automatically Restore Previous Session
    autocmds = {
      restore_session = {
        {
          event = "VimEnter",
          desc = "Restore previous directory session if neovim opened with no arguments",
          nested = true, -- trigger other autocommands as buffers open
          callback = function()
            -- Only load the session if nvim was started with no args
            -- and we are not running inside the VSCode extension
            if vim.fn.argc(-1) == 0 and not vim.g.vscode then
              -- try to load a directory session using the current working directory
              require("resession").load(vim.fn.getcwd(), { dir = "dirsession", silence_errors = true })
            end
          end,
        },
      },
      -- Add new group for alpha handling
      alpha_handling = {
        {
          event = { "BufAdd", "BufEnter" },
          desc = "Close alpha buffer when a new buffer is opened",
          callback = function()
            local bufs = vim.fn.getbufinfo()
            local listed_bufs = 0
            local alpha_buf = nil
            
            -- Count listed buffers and find alpha buffer
            for _, buf in ipairs(bufs) do
              if buf.listed == 1 and buf.name:match(".*neo%-tree.*") == nil then
                listed_bufs = listed_bufs + 1
              end
              if buf.name:match(".*alpha.*") then
                alpha_buf = buf.bufnr
              end
            end
            
            -- If we have other buffers and alpha buffer exists, close alpha
            if listed_bufs > 1 and alpha_buf then
              local current_buf = vim.api.nvim_get_current_buf()
              if current_buf ~= alpha_buf then
                vim.api.nvim_buf_delete(alpha_buf, { force = true })
              end
            end
          end,
        },
      },
    },
    -- Configuration table of session options for AstroNvim's session management powered by Resession
    sessions = {
      -- Configure auto saving
      autosave = {
        last = true, -- auto save last session
        cwd = true, -- auto save session for each working directory
      },
      -- Patterns to ignore when saving sessions
      ignore = {
        dirs = {}, -- working directories to ignore sessions in
        filetypes = { "gitcommit", "gitrebase" }, -- filetypes to ignore sessions
        buftypes = {}, -- buffer types to ignore sessions
      },
    },
    -- Configure core features of AstroNvim
    features = {
      large_buf = { size = 1024 * 256, lines = 10000 },
      autopairs = true,
      cmp = true,
      diagnostics_mode = 3,
      highlighturl = true,
      notifications = true,
    },
    -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
    diagnostics = {
      virtual_text = true,
      underline = true,
    },
    -- vim options can be configured here
    options = {
      opt = {
        relativenumber = true,
        number = true,
        spell = false,
        signcolumn = "yes",
        wrap = false,
      },
      g = {},
    },
    -- Mappings can be configured through AstroCore as well.
    -- NOTE: keycodes follow the casing in the vimdocs. For example, `<Leader>` must be capitalized
    mappings = {
      n = {
        -- Navigate buffer tabs
        ["]b"] = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" },
        ["[b"] = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Previous buffer" },
        ["<Tab>"] = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" },
        ["<S-Tab>"] = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Previous buffer" },

        -- Mappings seen under group name "Buffer"
        ["<Leader>bd"] = {
          function()
            require("astroui.status.heirline").buffer_picker(
              function(bufnr) require("astrocore.buffer").close(bufnr) end
            )
          end,
          desc = "Close buffer from tabline",
        },

        -- Open Alpha automatically when no more buffers
        ["<Leader>c"] = {
          function()
            local bufs = vim.fn.getbufinfo { buflisted = 1 }
            
            -- If this is the last buffer, show alpha after closing
            if #bufs <= 1 and require("astrocore").is_available "alpha-nvim" then
              -- Close current buffer first
              require("astrocore.buffer").close(0)
              -- Then create alpha buffer (automatically becomes current)
              require("alpha").start(true)
            else
              -- Standard buffer close for non-last buffer
              require("astrocore.buffer").close(0)
            end
          end,
          desc = "Close buffer",
        },
      },
    },
  },
}
