return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      local has_local, local_settings = pcall(require, "local_settings")
      local extra_servers = (has_local and local_settings.extra_servers) or {}

      local servers = { "lua_ls" }
      for _, server in ipairs(extra_servers) do
        table.insert(servers, server)
      end

      require("mason").setup()
      require("mason-lspconfig").setup {
        ensure_installed = servers,
        automatic_installation = true,
      }

      -- Standard Neovim 0.11+ LSP keymaps when a client attaches
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          local opts = { buffer = ev.buf }
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
          vim.keymap.set("n", "gy", vim.lsp.buf.type_definition, opts)
          vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "<leader>ls", vim.lsp.buf.signature_help, opts)
          vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, opts)
          vim.keymap.set({ "n", "v" }, "<leader>la", vim.lsp.buf.code_action, opts)
          -- I don't think I'll ever use workspaces
          -- vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
          -- vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
          -- vim.keymap.set("n", "<leader>wl", function()
          --   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          -- end, opts)
          vim.keymap.set("n", "[d", function()
            vim.diagnostic.jump { count = -1, float = true }
          end, opts)
          vim.keymap.set("n", "]d", function()
            vim.diagnostic.jump { count = 1, float = true }
          end, opts)
          vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)
          vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, opts)
        end,
      })

      -- Enable only the servers defined in local settings
      for _, server in ipairs(servers) do
        vim.lsp.enable(server)
      end
    end,
  },
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre", "BufNewFile" },
    cmd = { "ConformInfo" },
    opts = function()
      local has_local, local_settings = pcall(require, "local_settings")
      local extra_formatters = (has_local and local_settings.extra_formatters) or {}

      local formatters = {
        lua = { "stylua" },
      }

      -- Merge extra_formatters from local_settings
      for ft, fmt in pairs(extra_formatters) do
        formatters[ft] = fmt
      end

      return {
        formatters_by_ft = formatters,
        format_on_save = function(bufnr)
          if vim.bo[bufnr].filetype == "lua" then
            return {
              timeout_ms = 500,
              lsp_format = "fallback",
            }
          end
        end,
      }
    end,
    keys = {
      {
        "<leader>lf",
        function()
          require("conform").format { async = true, lsp_format = "fallback" }
        end,
        mode = { "n", "x" },
        desc = "Format Buffer",
      },
    },
  },
}
