return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>fm",
        function()
          local conform = require("conform")

          -- Check if we are in visual mode
          local mode = vim.fn.mode()
          if mode == "v" or mode == "V" or mode == "\22" then -- "\22" is for block mode
            local start_pos = vim.fn.getpos("'<")
            local end_pos = vim.fn.getpos("'>")

            conform.format({
              async = true,
              lsp_fallback = true,
              range = {
                start = { start_pos[2], start_pos[3] - 1 },
                ["end"] = { end_pos[2], end_pos[3] },
              },
            })
          else
            conform.format({ async = true, lsp_fallback = true }) -- Format entire buffer
          end
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
      {
        "<leader>cf",
        function()
          local ts = require("vim.treesitter")
          local lang = vim.bo.filetype
          if lang == "systemverilog" then
            lang = "verilog"
          end
          local query = require("vim.treesitter.query").get(lang, "beautifier_objects")
          if not query then
            vim.notify("No query for " .. lang, vim.log.levels.WARN)
            return
          end
          local node = ts.get_node()

          while node do
            local parent = node:parent()

            for id, capture_node in query:iter_captures(node, 0) do
              if capture_node == node then
                local capture_name = query.captures[id]

                if capture_name == "field.outer" or capture_name == "block.outer" then
                  local row1, col1, row2, col2 = capture_node:range()
                  require("conform").format({
                    async = true,
                    lsp_fallback = true,
                    range = {
                      start = { row1, col1 },
                      ["end"] = { row2, col2 },
                    },
                  })
                  return
                end
              end
            end

            node = parent
          end
        end,
        desc = "Smart format",
        mode = { "n" },
      },
    },
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "black" },
        javascript = { "prettierd" },
        typescript = { "prettierd" },
        json = { "fixjson" },
        yaml = { "yamlfix" },
        css = { "stylelint" },
        markdown = { "mdformat" },
        html = { "htmlbeautifier" },
        systemverilog = { "verible_verilog_format", "trim_whitespace" },
        verilog = { "verible_verilog_format", "trim_whitespace" },
      },

      -- Set up format-on-save
      format_on_save = function(bufnr)
        local ft = vim.bo[bufnr].filetype
        local excluded_filetypes = { markdown = true, verilog = true, systemverilog = true }
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat or excluded_filetypes[ft] then
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
          args = {
            "--indentation_spaces=4",
            "--module_net_variable_alignment=align",
            "--struct_union_members_alignment=align",
            "--assignment_statement_alignment=align",
            "--named_port_alignment=align",
            "--named_port_indentation=indent",
            "--port_declarations_right_align_packed_dimensions=true",
            "--try_wrap_long_lines=true",
            "-",
          },
          stdin = true,
        },
      },
    },
    config = function(_, opts)
      require("conform").setup(opts)
    end,
  },
}
