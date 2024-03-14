local M = {}

function M.setup(cfg)
  M.__conf = vim.tbl_deep_extend("keep", cfg or {}, require("drupal.default_config"))
  require("drupal.services").setup(M.__conf)
  if M.__conf.enabled_snippets.hooks then
    require("drupal.snippets.hooks")
  end
  if M.__conf.enabled_snippets.general then
    require("drupal.snippets.general")
  end
end

return M
