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
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
      },

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
          stdin = true
        },
      },
    },
  },
}
