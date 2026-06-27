local MissionHub = {}
missionmode = "ER"

function MissionHub:new(init)
  local o = init or {}
  setmetatable(o, self)
  self.__index = self
  
  o.nav.Event(nil, "evt_setup")
  
  return o
end

function MissionHub:finalize()
end

return MissionHub