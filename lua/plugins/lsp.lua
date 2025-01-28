-- Setup LSP bindings when an LSP attaches
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local bufnr = args.buf

    -- Initialize lsp_signature
    require("lsp_signature").on_attach({
      bind = true,
      handler_opts = {
        border = "rounded",
      },
      hint_enable = false,
      floating_window = true,
      toggle_key = false,
      doc_lines = 0,  -- only show the first line, no markdown
      hint_prefix = "",  -- remove hint prefix
      hint_scheme = "String",  -- highlight group for the hint
      hi_parameter = "Search",  -- highlight group for the current parameter
      max_height = 12,
      max_width = 120,
      wrap = true,  -- wrap long lines
      fix_pos = false,  -- let the signature window float naturally
      extra_trigger_chars = {}, -- no extra triggers
    }, bufnr)
  end,
})

return {
  -- LSP Support
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason.nvim",
      "mason-lspconfig.nvim",
      "folke/neodev.nvim",
    },
  },

  -- Package Manager for LSP/DAP/Linters
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = {
      { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" },
    },
    opts = {
      ensure_installed = {
        "lua-language-server",
        "pyright",
        "ruff",
      },
    },
    config = function(_, opts)
      require("mason").setup(opts)
      local mr = require("mason-registry")
      for _, tool in ipairs(opts.ensure_installed) do
        local p = mr.get_package(tool)
        if not p:is_installed() then
          p:install()
        end
      end
    end,
  },

  -- Smag tagfunc
  {
    "weilbith/nvim-lsp-smag",
    lazy = true,
    dependencies = {
      "neovim/nvim-lspconfig",
    },
  },

  -- Hover
  {
    "lewis6991/hover.nvim",
    opts = {
      init = function()
        require("hover.providers.lsp")
        require("hover.providers.diagnostic")
        require("hover.providers.gh_user")
      end,
    },
    mouse_providers = { "LSP" },
  },

  -- Show signatures as you type
  {
    "ray-x/lsp_signature.nvim",
    lazy = true,
    dependencies = {
      "neovim/nvim-lspconfig",
    },
  },

  -- Bridge between mason and lspconfig
  -- TODO: Add verilator linter & verilog LSP
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      automatic_installation = true,
    },
    config = function()
      -- Setup neodev first
      require("neodev").setup({
        library = { plugins = { "nvim-dap-ui" }, types = true },
      })

      local lspconfig = require("lspconfig")
      lspconfig.lua_ls.setup({
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
            workspace = {
              checkThirdParty = false,
            },
          },
        },
      })

      lspconfig.pyright.setup({})
      lspconfig.ruff.setup({})

      -- Global LSP mappings
      vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
      vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover documentation" })
      vim.keymap.set("n", "gh", function()
        local buf_ft = vim.bo.filetype
        if buf_ft == "python" then
          vim.cmd("DevdocsOpenCurrentFloat")
        else
          vim.lsp.buf.hover()
          vim.defer_fn(function()
            vim.lsp.buf.hover()
          end, 5)
        end
      end, { desc = "Online documentation" })
      vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })
      vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename" })
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code actions" })
      vim.keymap.set("n", "<A-e>", vim.lsp.buf.code_action, { desc = "Code actions" })
      vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "Show references" })
      vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "Float diagnostic" })

      -- Diagnostic navigation
      vim.keymap.set("n", "[e", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
      vim.keymap.set("n", "]e", vim.diagnostic.goto_next, { desc = "Next diagnostic" })

      -- Diagnostic toggles
      vim.keymap.set("n", "<leader>td", function()
        local new_value = not vim.diagnostic.is_disabled()
        vim.diagnostic.disable(0)
        if not new_value then
          vim.diagnostic.enable(0)
        end
        print("Diagnostics: " .. (new_value and "OFF" or "ON"))
      end, { desc = "Toggle diagnostics" })

      -- Toggle specific diagnostic levels
      vim.keymap.set("n", "<leader>te", function()
        local current = vim.diagnostic.config().severity_sort
        vim.diagnostic.config({
          severity_sort = not current,
          virtual_text = {
            severity = {
              min = vim.diagnostic.severity.ERROR
            }
          }
        })
        print("Error-only mode: " .. (not current and "ON" or "OFF"))
      end, { desc = "Toggle error-only diagnostics" })

      -- Hover.nvim
      vim.keymap.set("n", "<C-p>", function()
        require("hover").hover_switch("previous")
      end, { desc = "hover.nvim (previous source)" })
      vim.keymap.set("n", "<C-n>", function()
        require("hover").hover_switch("next")
      end, { desc = "hover.nvim (next source)" })
    end,
  },
}
