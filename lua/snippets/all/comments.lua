local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local f = ls.function_node
local i = ls.insert_node

local prefixes = { "/", "//", "#", "##", "$", "$$", ";;", ";" }
local suffixes = { "-", "=" }

local autosnippets = {}

for _, prefix in ipairs(prefixes) do
  for _, suffix in ipairs(suffixes) do
    table.insert(
      autosnippets,
      s({
        trig = prefix .. string.rep(suffix, 2),
        snippetType = "autosnippet",
        condition = require("luasnip.extras.expand_conditions").line_begin,
      }, {
        t(prefix .. " "),
        i(1),
        t({ "", prefix .. " " }),
        f(function(args)
          return string.rep(suffix, #args[1][1])
        end, { 1 }),
      })
    )
  end
end

return autosnippets
