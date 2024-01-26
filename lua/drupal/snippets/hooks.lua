local file_exists = require("drupal.utils.file_utils").file_exists
local luasnip = require("luasnip")

local s = luasnip.snippet
local t = luasnip.text_node
local i = luasnip.insert_node
local f = luasnip.function_node

local Job = require('plenary.job')

local tmp_file_path = "/tmp/hooks.txt"
local hooks = {}
if file_exists(tmp_file_path) then
  for line in io.lines(tmp_file_path) do
    table.insert(hooks, line)
  end
end

-- Regenerate tmp file if empty or it doesn't exist. 
if next(hooks) == nil then
  hooks = Job:new({
    command = 'rg',
    args = { '-e', 'function hook_', '-uu', '-g', '*.api.php', '--no-filename', vim.loop.cwd() },
    env = { PATH = vim.env.PATH },
  }):sync(1500)

  local file = assert(io.open(tmp_file_path, "w"))
  for _, name in pairs(hooks) do
    file:write(name .. "\n")
  end
  file:close()
end

local get_filename = function ()
  return vim.fn.expand('%:t:r')
end

local snippets = {}
for _, name in pairs(hooks) do
  local _, _, hook_name = string.find(name, 'function (.+)%(')
  local _, _, signature = string.find(name, 'function hook(.+)')
  table.insert(snippets,
    s(hook_name, {
      t({ "/**", "" }),
      t({ " * Implements " .. hook_name .. "()", "" }),
      t({ " */", "" }),
      t("function "),
      f(get_filename, {}),
      t({ signature, "\t" }),
      i(0),
      t({ "", "}" }),
    }))
end

luasnip.add_snippets("php", snippets)
