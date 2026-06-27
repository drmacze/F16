local data = ...
local Progress = {}

function Progress:new(init)
  local o = init or {}
  setmetatable(o, self)
  self.__index = self
  
  o.nav.Event(nil, "evt_back")
  
  return o
end

function Progress:finalize()
end

return Progress