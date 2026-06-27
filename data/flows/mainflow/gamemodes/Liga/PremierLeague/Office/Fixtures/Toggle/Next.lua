local toggleNext = {}
local matchCount = #TeamList
function toggleNext:new(init)
  local o = init or {}
  setmetatable(o, self)
  self.__index = self
  o:Next()
  o.nav.Event(nil, "evt_back")
  
  return o
end
function toggleNext:Next()
  if round < ((matchCount * 2) - 2) then
    round = round + 1
  end
end
function toggleNext:finalize()
end

return toggleNext