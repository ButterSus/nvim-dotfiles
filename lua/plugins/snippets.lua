return {
  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
      
      local ls = require("luasnip")
      -- Some basic snippets
      ls.add_snippets("all", {
        ls.snippet("main", {
          ls.text_node({"if __name__ == '__main__':", "    "}),
          ls.insert_node(0),
        }),
      })

      -- Keymaps
      vim.keymap.set({"i", "s"}, "<C-k>", function()
        if ls.expand_or_jumpable() then
          ls.expand_or_jump()
        end
      end, { silent = true })

      vim.keymap.set({"i", "s"}, "<C-j>", function()
        if ls.jumpable(-1) then
          ls.jump(-1)
        end
      end, { silent = true })
    end,
  }
} 