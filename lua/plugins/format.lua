return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>fm",
        function()
          require("conform").format({ async = true, lsp_fallback = true })
        end,
        mode = { "x", "n" },
        desc = "Format buffer",
      },
      {
        "<leader>ft",
        function()
          vim.b.disable_autoformat = not vim.b.disable_autoformat
          print("Format on save (Local): " .. (vim.b.disable_autoformat and "OFF" or "ON"))
        end,
        mode = { "x", "n" },
        desc = "Toggle format on save (buffer)",
      },
      {
        "<leader>fT",
        function()
          vim.g.disable_autoformat = not vim.g.disable_autoformat
          print("Format on save (Global): " .. (vim.g.disable_autoformat and "OFF" or "ON"))
        end,
        mode = { "x", "n" },
        desc = "Toggle format on save (global)",
      },
    },
    opts = {
      formatters_by_ft = {
        lua = { "stylua", "trim_whitespace" },
        python = { "black", "trim_whitespace" },
        javascript = { "prettierd", "trim_whitespace" },
        typescript = { "prettierd", "trim_whitespace" },
        json = { "prettierd", "trim_whitespace" },
        yaml = { "prettierd", "trim_whitespace" },
        markdown = { "prettierd", "trim_whitespace" },
        systemverilog = { "verible_verilog_format", "trim_whitespace" },
        verilog = { "verible_verilog_format", "trim_whitespace" },
      },

      -- Set up format-on-save
      format_on_save = function(bufnr)
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end
        return { timeout_ms = 500, lsp_fallback = true }
      end,

      -- Customize formatters
      formatters = {
        stylua = {
          prepend_args = { "--indent-type", "Spaces", "--indent-width", "2" },
        },
        black = {
          prepend_args = { "--line-length", "120" },
        },
        verible_verilog_format = {
          command = "verible-verilog-format",
          args = { "--indentation_spaces=2", "-" },
          stdin = true,
        },
      },
    },
  },
}
