local M = {}

function M.setup(cfg)
  M.__conf = vim.tbl_deep_extend("keep", cfg or {}, require("drupal.default_config"))
  require("drupal.services").setup(M.__conf)
  require("drupal.snippets")
end

return M
