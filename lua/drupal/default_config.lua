return {
  services_cmp_trigger_character = '@',
  get_drush_executable = function()
    return "drush"
  end,
  get_webroot = function()
    return "web"
  end,
  enabled_snippets = {
    general = true,
    hooks = true,
  }
}
