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
      doc_lines = 0, -- only show the first line, no markdown
      hint_prefix = "", -- remove hint prefix
      hint_scheme = "String", -- highlight group for the hint
      hi_parameter = "Search", -- highlight group for the current parameter
      max_height = 12,
      max_width = 120,
      wrap = true, -- wrap long lines
      fix_pos = false, -- let the signature window float naturally
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
        "python-lsp-server",
        "verible",
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
        require("hover.providers.default_fallback")
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

      -- Function to handle reference navigation
      local function goto_reference(next)
        local params = vim.lsp.util.make_position_params()
        params.context = { includeDeclaration = true }

        vim.lsp.buf_request(0, "textDocument/references", params, function(err, result, _, _)
          if err or not result or vim.tbl_isempty(result) then
            return
          end

          local locations = vim.lsp.util.locations_to_items(result, "utf-8")
          local current_pos = vim.api.nvim_win_get_cursor(0)
          local current_line = current_pos[1]

          -- Find the next/previous reference
          local target_pos
          if next then
            for _, loc in ipairs(locations) do
              if loc.lnum > current_line then
                target_pos = { loc.lnum, loc.col }
                break
              end
            end
            -- Wrap around to first reference if at end
            if not target_pos then
              target_pos = { locations[1].lnum, locations[1].col }
            end
          else
            for i = #locations, 1, -1 do
              if locations[i].lnum < current_line then
                target_pos = { locations[i].lnum, locations[i].col }
                break
              end
            end
            -- Wrap around to last reference if at start
            if not target_pos then
              local last = locations[#locations]
              target_pos = { last.lnum, last.col }
            end
          end

          if target_pos then
            vim.api.nvim_win_set_cursor(0, target_pos)
          end
        end)
      end

      -- Common on_attach function for LSP symbol highlighting
      local on_attach = function(client, bufnr)
        if client.server_capabilities.documentHighlightProvider then
          vim.cmd([[
            hi! LspReferenceRead cterm=bold ctermbg=red guibg=#51576d
            hi! LspReferenceText cterm=bold ctermbg=red guibg=#51576d
            hi! LspReferenceWrite cterm=bold ctermbg=red guibg=#51576d
          ]])
          vim.api.nvim_create_augroup("lsp_document_highlight", {
            clear = false,
          })
          vim.api.nvim_clear_autocmds({
            buffer = bufnr,
            group = "lsp_document_highlight",
          })
          vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            group = "lsp_document_highlight",
            buffer = bufnr,
            callback = vim.lsp.buf.document_highlight,
          })
          vim.api.nvim_create_autocmd("CursorMoved", {
            group = "lsp_document_highlight",
            buffer = bufnr,
            callback = vim.lsp.buf.clear_references,
          })
        end
      end

      lspconfig.lua_ls.setup({
        on_attach = on_attach,
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

      lspconfig.pylsp.setup({
        on_attach = on_attach,
        settings = {
          pylsp = {
            plugins = {
              -- Disable pylint, pyflakes, etc. since we use ruff
              pycodestyle = { enabled = false },
              pylint = { enabled = false },
              pyflakes = { enabled = false },
              flake8 = { enabled = false },
              mccabe = { enabled = false },

              -- Keep completion-related plugins enabled
              rope_completion = {
                enabled = true,
              },
              rope_autoimport = {
                enabled = true,
              },
              jedi_completion = {
                enabled = true,
                include_params = true,
              },
              jedi = {
                environment = vim.fn.exepath("python3") or vim.fn.exepath("python"),
                extra_paths = {},
              },
            },
          },
        },
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
      })
      lspconfig.verible.setup({
        on_attach = on_attach,
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
        root_dir = function()
          return vim.uv.cwd()
        end,
        cmd = { "verible-verilog-ls", "--rules_config", vim.fn.expand("~/.config/nvim/.rules.verible_lint") },

        on_new_config = function(new_config, root_dir)
          -- Generate a unique temp file path
          local tmp_file = vim.fn.tempname()
          local max_files = 20 -- Set the maximum number of files

          -- Find all Verilog files and save the list in the temp file
          local cmd = string.format(
            'find %s -name "*.sv" -o -name "*.svh" -o -name "*.v" | sort | head -n %d > %s',
            vim.fn.shellescape(root_dir),
            max_files,
            vim.fn.shellescape(tmp_file)
          )

          -- Run the find command asynchronously
          vim.fn.jobstart(cmd, {
            on_exit = function()
              -- Update the LSP command with the generated filelist
              new_config.cmd = {
                "verible-verilog-ls",
                "--rules_config",
                vim.fn.expand("~/.config/nvim/.rules.verible_lint"),
                "--file_list_path",
                tmp_file,
              }
            end,
          })
        end,
      })

      lspconfig.ruff.setup({})

      -- Global LSP mappings
      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
      vim.keymap.set("n", "gh", require("hover").hover, { desc = "Hover documentation" })
      vim.keymap.set("n", "Q", require("hover").hover, { desc = "Hover documentation" })
      vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })
      vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename" })
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code actions" })
      vim.keymap.set("n", "<A-e>", vim.lsp.buf.code_action, { desc = "Code actions" })
      vim.keymap.set("n", "gr", function()
        builtin.lsp_references({ initial_mode = "normal" })
      end, { desc = "Show references" })
      vim.keymap.set("n", "<leader>df", vim.diagnostic.open_float, { desc = "Float diagnostic" })

      -- Diagnostic navigation
      vim.keymap.set("n", "[e", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
      vim.keymap.set("n", "]e", vim.diagnostic.goto_next, { desc = "Next diagnostic" })

      -- Diagnostic toggles
      vim.keymap.set("n", "<leader>td", function()
        local new_value = vim.diagnostic.is_enabled()
        vim.diagnostic.enable(false)
        if not new_value then
          vim.diagnostic.enable(true)
        end
        print("Diagnostics: " .. (new_value and "OFF" or "ON"))
      end, { desc = "Toggle diagnostics" })

      -- Toggle specific diagnostic levels with state
      local error_only_mode = false

      vim.keymap.set("n", "<leader>te", function()
        error_only_mode = not error_only_mode

        if error_only_mode then
          vim.diagnostic.config({
            severity_sort = true,
            virtual_text = {
              severity = { min = vim.diagnostic.severity.ERROR },
            },
          })
          print("Error-only diagnostics: ON")
        else
          -- Revert to default virtual_text (or your preferred configuration)
          vim.diagnostic.config({
            severity_sort = false,
            virtual_text = true, -- set back to default virtual text display
          })
          print("Error-only diagnostics: OFF")
        end
      end, { desc = "Toggle error-only diagnostics" })

      -- Add reference navigation keymaps
      vim.keymap.set("n", "]r", function()
        goto_reference(true)
      end, { desc = "Next reference" })
      vim.keymap.set("n", "[r", function()
        goto_reference(false)
      end, { desc = "Previous reference" })
    end,
  },

  -- Better Comments
  {
    "numToStr/Comment.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
  },
}
