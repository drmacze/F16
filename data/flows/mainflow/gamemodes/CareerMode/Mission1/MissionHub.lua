local MissionHub = {}
missionmode = "ER"

function MissionHub:new(init)
  local o = init or {}
  setmetatable(o, self)
  self.__index = self
  if missionstatus == "set" then
    o.nav.Event(nil, "evt_back")
  else
    o.nav.Event(nil, "evt_setup")
  end
  
  return o
end

function MissionHub:finalize()
end

return MissionHub