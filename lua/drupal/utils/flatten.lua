local function noop(...)
  return ...
end

-- convert a nested table to a flat table
local function flatten(t, sep, key_modifier, res)
  if type(t) ~= 'table' then
    return t
  end

  if sep == nil then
    sep = '.'
  end

  if res == nil then
    res = {}
  end

  if key_modifier == nil then
    key_modifier = noop
  end

  for k, v in pairs(t) do
    if type(v) == 'table' then
      local v = flatten(v, sep, key_modifier, {})
      for k2, v2 in pairs(v) do
        res[key_modifier(k) .. sep .. key_modifier(k2)] = v2
      end
    else
      res[key_modifier(k)] = v
    end
  end
  return res
end

return flatten
