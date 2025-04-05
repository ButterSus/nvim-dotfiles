return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "onsails/lspkind.nvim",
      "AstroNvim/astroui",
      -- Additional completion sources
      "hrsh7th/cmp-buffer", -- Buffer completions
      "rasulomaroff/cmp-bufname", -- Buffer name completions
      "mtoohey31/cmp-fish", -- Fish shell completions
      "garyhurtz/cmp_kitty", -- Kitty terminal completions
      {
        "chrisgrieser/cmp_yanky",
        dependencies = { "gbprod/yanky.nvim" },
      }, -- Yank history via yanky.nvim
    },
    config = function()
      local lspkind = require "lspkind"

      -- Configure lspkind
      lspkind.init {
        mode = "symbol_text",
        preset = "codicons",
        symbol_map = {
          Text = "󰉿",
          Method = "󰆧",
          Function = "󰊕",
          Constructor = "",
          Field = "󰜢",
          Variable = "󰀫",
          Class = "󰠱",
          Interface = "",
          Module = "",
          Property = "󰜢",
          Unit = "󰑭",
          Value = "󰎠",
          Enum = "",
          Keyword = "󰌋",
          Snippet = "",
          Color = "󰏘",
          File = "󰈙",
          Reference = "󰈇",
          Folder = "󰉋",
          EnumMember = "",
          Constant = "󰏿",
          Struct = "󰙅",
          Event = "",
          Operator = "󰆕",
          TypeParameter = "",
          Codeium = require("astroui").get_icon("Codeium", 1, true),
          -- Additional sources
          Buffer = "󰦨", -- Buffer icon
          Bufname = "󰛖", -- Buffer name icon
          Fish = "󰈺", -- Fish shell icon
          Kitty = "󰄛", -- Kitty terminal icon
          Yanky = "󱚢", -- Yank icon for yanky.nvim
        },
      }

      -- Configure cmp to use lspkind
      local cmp = require "cmp"
      cmp.setup {
        formatting = {
          format = lspkind.cmp_format {
            mode = "symbol", -- show only symbol annotations
            maxwidth = {
              menu = 50, -- leading text (labelDetails)
              abbr = 50, -- actual suggestion item
            },
            ellipsis_char = "...", -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead
            show_labelDetails = true, -- show labelDetails in menu

            -- The function below will be called before any actual modifications from lspkind
            before = function(_, vim_item) return vim_item end,
          },
        },
        -- Add key mappings
        mapping = {
          -- Use Ctrl+Space to trigger completion menu
          ["<C-Space>"] = cmp.mapping.complete(),
          
          -- Select previous/next item
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<Up>"] = cmp.mapping.select_prev_item(),
          ["<Down>"] = cmp.mapping.select_next_item(),
          
          -- Scroll docs
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          
          -- Tab for completion and navigation
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            else
              fallback()
            end
          end, { "i", "s" }),
          
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            else
              fallback()
            end
          end, { "i", "s" }),
          
          -- Accept completion
          ["<CR>"] = cmp.mapping.confirm({ select = false }),
          
          -- Close completion menu
          ["<C-e>"] = cmp.mapping.abort(),
        },
        -- Configure sources
        sources = cmp.config.sources {
          { name = "nvim_lsp", priority = 1000 },
          { name = "luasnip", priority = 750 },
          { name = "codeium", priority = 600, max_item_count = 3 }, -- Limit Codeium to 3 items
          { name = "buffer", priority = 500 },
          { name = "path", priority = 400 },
          { name = "bufname", priority = 350 },
          { name = "fish", priority = 300 },
          { name = "kitty", priority = 250 },
          { name = "yanky", priority = 200 },
        },
      }
    end,
  },
}
