return {
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "BurntSushi/ripgrep",
      "smartpde/telescope-recent-files",
      "nvim-telescope/telescope-ui-select.nvim",
    },
    opts = {
      extensions = {
        recent_files = {
          ignore_patterns = { "/tmp/", "\\." },
          show_current_file = true,
        },
        ["ui-select"] = {
          require("telescope.themes").get_dropdown({
            winblend = 10,
            borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
            initial_mode = "normal",
          }),
        },
      },
      defaults = {
        initial_mode = "insert",
      },
    },
    config = function(_, opts)
      local function flash(prompt_bufnr)
        require("flash").jump({
          pattern = "^",
          label = { after = { 0, 0 } },
          search = {
            mode = "search",
            exclude = {
              function(win)
                return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= "TelescopeResults"
              end,
            },
          },
          action = function(match)
            local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
            picker:set_selection(match.pos[1] - 1)
          end,
        })
      end
      opts.defaults = vim.tbl_deep_extend("force", opts.defaults or {}, {
        mappings = {
          n = { s = flash },
          i = { ["<c-s>"] = flash },
        },
      })
      require("telescope").setup(opts)
      require("telescope").load_extension("recent_files")
      require("telescope").load_extension("ui-select")
    end,
    keys = {
      { "<leader>fn", require("telescope").extensions.fidget.fidget, desc = "Telescope: List all notifications" },
      { "<leader>fr", require("telescope.builtin").oldfiles, desc = "Telescope: Find recent files" },
      { "<leader>fs", require("telescope.builtin").lsp_dynamic_workspace_symbols, desc = "Telescope: Find symbols" },
      {
        "<leader><leader>",
        "<cmd>lua require('telescope').extensions.recent_files.pick()<cr>",
        desc = "Telescope: Find buffers",
      },
    },
  },
}
