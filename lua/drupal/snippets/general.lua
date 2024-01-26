local luasnip = require("luasnip")

local s = luasnip.snippet
local t = luasnip.text_node
local i = luasnip.insert_node

local snippets = {
  -- Create an inheritdoc doc block.
  s("ihdoc", {
    t({ "/**", "" }),
    t({ " * {@inheritdoc}", "" }),
    t({ " */" })
  }),
  -- Create an empty doc block.
  s("/**", {
    t({ "/**", "" }),
    t({ " * " }),
    i(0),
    t({ "", " */" })
  }),
}

luasnip.add_snippets("php", snippets)
