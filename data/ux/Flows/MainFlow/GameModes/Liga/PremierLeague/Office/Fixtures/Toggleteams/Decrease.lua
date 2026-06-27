local toggleDecrease = {}
function toggleDecrease:new(init)
  local o = init or {}
  setmetatable(o, self)
  self.__index = self
  o:Decrease()
  o.nav.Event(nil, "evt_back")
  
  return o
end
function toggleDecrease:Decrease()
  if selectedteam > 0 then
    selectedteam = selectedteam - 1
  end
end
function toggleDecrease:finalize()
end

return toggleDecrease