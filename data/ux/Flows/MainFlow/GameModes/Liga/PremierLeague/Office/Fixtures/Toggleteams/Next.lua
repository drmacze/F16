local toggleNext = {}
local teamCount = #TeamList
function toggleNext:new(init)
  local o = init or {}
  setmetatable(o, self)
  self.__index = self
  o:Next()
  o:Loop()
  o.nav.Event(nil, "evt_back")
  
  return o
end
function toggleNext:Next()
  selectedteam = selectedteam + 1
end
function toggleNext:Loop()
  if selectedteam == teamCount + 1 then
    selectedteam = 0
  end
end
function toggleNext:finalize()
end

return toggleNext