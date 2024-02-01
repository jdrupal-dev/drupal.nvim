local composer_file_load = function()
  local composer = vim.loop.cwd() .. "/composer.json"
  local exists = vim.loop.fs_stat(composer)
  if not exists then
    return
  end

  local content = vim.fn.readfile(composer)

  return vim.fn.json_decode(content)
end

local M = {}

function M.setup(conf)
  local composer = composer_file_load()
  if not composer then
    return
  end

  local cwd = vim.loop.cwd()
  local command = "cp composer.json composer.json.orig; cp composer.lock composer.lock.orig"
  -- Install the autoload-drupal package, if not already installed in.
  if not vim.loop.fs_stat(vim.loop.cwd() .. "/vendor/fenetikm/autoload-drupal") then
    command = command .. "; composer require fenetikm/autoload-drupal"
  end

  vim.fn.jobstart(
    command,
    {
      cwd = cwd,
      on_exit = function ()
        local webroot = conf.get_webroot(require("drupal.utils").current_dir()) .. "/"
        -- Remove extra trailing slash, if user had already included one.
        webroot = webroot:gsub("//", "/")

        if webroot == "/" or webroot == "." then
          webroot = ""
        end

        local composer_additions = {
          config = {
            ["allow-plugins"] = {
              ["fenetikm/autoload-drupal"] = true,
            },
          },
          extra = {
            ["autoload-drupal"] = {
              ["modules"] = {
                webroot .. "modules/contrib",
                webroot .. "modules/custom",
                webroot .. "core/modules",
              },
            }
          }
        }
        local new_composer = vim.tbl_deep_extend("keep", composer, composer_additions)

        vim.fn.writefile({ vim.fn.json_encode(new_composer) }, cwd .. "/composer.json")
        vim.fn.jobstart(
          "composer dump-autoload; mv composer.json.orig composer.json; mv composer.lock.orig composer.lock",
          {
            cwd = cwd,
            on_exit = function ()
              print("Drupal modules were successfully added to the autoloader.")
            end
          }
        )
      end
    }
  )
end

return M
