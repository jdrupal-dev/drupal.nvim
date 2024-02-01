local M = {}

M.current_dir = function ()
  local path = vim.api.nvim_buf_get_name(0)
  return path:match("(.*/)")
end

M.file_exists = function(name)
  local f = io.open(name, "r")
  if f ~= nil then
    io.close(f)
    return true
  else
    return false
  end
end

return M
