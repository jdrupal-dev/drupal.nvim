local flatten = require("drupal.utils.flatten")
local services = {}

local registered = false

local getPath = function(str)
  return str:match("(.*/)")
end

local service_names = {}

services.setup = function(conf)
  if registered then
    return
  end
  registered = true

  -- Retrieve list of services when entering php/yml files.
  vim.api.nvim_create_autocmd("BufRead", {
    pattern = "*.yml,*.php",
    callback = function ()
      local current_dir = getPath(vim.api.nvim_buf_get_name(0));
      -- Clear list of service names to avoid duplicates.
      service_names = {}
      vim.fn.jobstart(
        conf.get_drush_executable(current_dir) .. " devel:services --format=list",
        {
          cwd = current_dir,
          on_exit = function ()
            print("Drupal services were updated.")
          end,
          on_stdout = function (_, data)
            table.insert(service_names, data)
          end,
        }
      )
    end
  })

  local has_cmp, cmp = pcall(require, 'cmp')
  if not has_cmp then
    return
  end

  local source = {}

  source.new = function()
    return setmetatable({}, {__index = source})
  end

  source.get_trigger_characters = function()
    return { conf.services_cmp_trigger_character }
  end

  source.get_keyword_pattern = function()
    -- Add dot to existing keyword characters (\k).
    return [[\%(\k\|\.\)\+]]
  end

  source.complete = function(_, request, callback)
    local input = string.sub(request.context.cursor_before_line, request.offset - 1)
    local prefix = string.sub(request.context.cursor_before_line, 1, request.offset - 1)

    local trigger = conf.services_cmp_trigger_character
    if vim.startswith(input, trigger) and (prefix == trigger or vim.endswith(prefix, trigger)) then
      local items = {}
      for _, name in pairs(flatten(service_names)) do
        table.insert(items, {
          filterText = name,
          label = name,
          textEdit = {
            newText = name,
            range = {
              start = {
                line = request.context.cursor.row - 1,
                character = request.context.cursor.col - 1 - #input,
              },
              ['end'] = {
                line = request.context.cursor.row - 1,
                character = request.context.cursor.col - 1,
              },
            },
          },
        }
        )
      end
      callback {
        items = items,
        isIncomplete = false,
      }
    else
      callback({ isIncomplete = true })
    end
  end

  -- TODO: Find a way to append the source, instead of overwriting.
  cmp.register_source('drupal_services', source.new())
  cmp.setup.filetype('php', {
    sources = cmp.config.sources({
      { name = "nvim_lsp" },
      { name = "luasnip" },
      { name = "buffer" },
      { name = "nvim_lua" },
      { name = "path" },
      { name = "drupal_services" },
    }),
  })
  cmp.setup.filetype('yaml', {
    sources = cmp.config.sources({
      { name = "nvim_lsp" },
      { name = "luasnip" },
      { name = "buffer" },
      { name = "nvim_lua" },
      { name = "path" },
      { name = "drupal_services" },
    }),
  })
end

return services
