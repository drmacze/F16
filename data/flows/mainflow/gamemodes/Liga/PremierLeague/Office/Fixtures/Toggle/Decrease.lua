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
  if round > 1 then
    round = round - 1
  end
end
function toggleDecrease:finalize()
end

return toggleDecrease